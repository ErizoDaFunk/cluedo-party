import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/room.dart';
import '../../domain/usecases/sync_game_state.dart';
import '../../domain/usecases/update_game_settings.dart';
import '../bloc/room_bloc.dart';
import '../bloc/room_event.dart';
import '../widgets/game_settings_dialog.dart';
import 'active_game_page.dart';

class RoomLobbyPage extends StatefulWidget {
  final String roomCode;
  final String playerId;

  const RoomLobbyPage({
    super.key,
    required this.roomCode,
    required this.playerId,
  });

  @override
  State<RoomLobbyPage> createState() => _RoomLobbyPageState();
}

class _RoomLobbyPageState extends State<RoomLobbyPage> {
  final WatchRoomUseCase _watchRoomUseCase = getIt<WatchRoomUseCase>();
  final UpdateGameSettingsUseCase _updateGameSettingsUseCase = getIt<UpdateGameSettingsUseCase>();

  void _showSettingsDialog(GameSettings currentSettings) {
    showDialog(
      context: context,
      builder: (context) => GameSettingsDialog(
        initialSettings: currentSettings,
        onSave: (settings) async {
          await _updateGameSettingsUseCase(
            roomCode: widget.roomCode,
            settings: settings,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get RoomBloc before StreamBuilder to avoid context issues
    final roomBloc = context.read<RoomBloc>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sala de Espera'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder(
        stream: _watchRoomUseCase(widget.roomCode),
        builder: (context, snapshot) {
          print('[RoomLobby] StreamBuilder - hasData: ${snapshot.hasData}');
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Cargando sala...'),
            );
          }

          return snapshot.data!.fold(
            (failure) {
              return Center(
                child: Text('Error: ${failure.message}'),
              );
            },
            (room) {
              print('[RoomLobby] Rendering ${room.players.length} players');
              
              final isHost = room.hostId == widget.playerId;
              final playersList = room.players.values.toList();

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Room Code Card
                      Card(
                        elevation: 4,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Text(
                                'Código de Sala',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    room.code,
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 4,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: room.code));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Código copiado'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Comparte este código con otros jugadores',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Game Settings Card
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Configuración',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (isHost)
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _showSettingsDialog(room.settings),
                                      tooltip: 'Editar configuración',
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildSettingRow(
                                icon: Icons.gavel,
                                label: 'Arma requerida',
                                value: room.settings.requireWeapon ? 'Sí' : 'No',
                              ),
                              if (room.settings.requireWeapon && room.settings.availableWeapons.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 40, top: 4),
                                  child: Text(
                                    room.settings.availableWeapons.join(', '),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 4),
                              _buildSettingRow(
                                icon: Icons.location_on,
                                label: 'Lugar requerido',
                                value: room.settings.requireLocation ? 'Sí' : 'No',
                              ),
                              if (room.settings.requireLocation && room.settings.availableLocations.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 40, top: 4),
                                  child: Text(
                                    room.settings.availableLocations.join(', '),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 4),
                              _buildSettingRow(
                                icon: Icons.verified_user,
                                label: 'Verificación',
                                value: _getVerificationText(room.settings.killVerification),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Players list
                      Text(
                        'Jugadores (${playersList.length})',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Expanded(
                        child: Card(
                          elevation: 2,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemCount: playersList.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final player = playersList[index];
                              final isCurrentPlayer = player.id == widget.playerId;

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: player.isHost
                                      ? Colors.amber
                                      : Theme.of(context).primaryColor,
                                  child: Text(
                                    player.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      player.name,
                                      style: TextStyle(
                                        fontWeight: isCurrentPlayer
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    if (isCurrentPlayer) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'TÚ',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: player.isHost
                                    ? const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      )
                                    : null,
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Status and action button
                      if (room.status == RoomStatus.waiting) ...[
                        Text(
                          'Esperando jugadores... (mínimo 3)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (isHost)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: playersList.length >= 3
                                  ? () {
                                      roomBloc.add(
                                        StartGameEvent(room.code),
                                      );
                                    }
                                  : null,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text(
                                'Iniciar Juego',
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                      ] else if (room.status == RoomStatus.playing) ...[
                        const Text(
                          '¡El juego ha comenzado!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ActiveGamePage(
                                    roomCode: widget.roomCode,
                                    playerId: widget.playerId,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text(
                              'Ver Mi Objetivo',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getVerificationText(KillVerification verification) {
    final List<String> verifiers = [];
    if (verification.hostVerifies) verifiers.add('Host');
    if (verification.killerVerifies) verifiers.add('Asesino');
    if (verification.victimVerifies) verifiers.add('Víctima');
    
    return verifiers.isEmpty ? 'Ninguna' : verifiers.join(', ');
  }
}
