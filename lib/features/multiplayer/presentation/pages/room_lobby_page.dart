import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/room.dart';
import '../../domain/usecases/sync_game_state.dart';
import '../bloc/room_bloc.dart';
import '../bloc/room_event.dart';

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

  @override
  Widget build(BuildContext context) {
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

                      const SizedBox(height: 24),

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
                                      context.read<RoomBloc>().add(
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
                        // TODO: Navegar a la pantalla del juego activo
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pantalla de juego próximamente...'),
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
}
