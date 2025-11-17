import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/room.dart';
import '../bloc/room_bloc.dart';
import '../bloc/room_event.dart';
import '../bloc/room_state.dart';

class RoomLobbyPage extends StatelessWidget {
  const RoomLobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sala de Espera'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<RoomBloc>().add(const LeaveRoomEvent());
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocConsumer<RoomBloc, RoomState>(
        listener: (context, state) {
          if (state is RoomError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is RoomInitial) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is RoomLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! RoomCreated && state is! RoomJoined && state is! RoomUpdated) {
            return const Center(
              child: Text('Error: Estado inválido'),
            );
          }

          final room = (state is RoomCreated)
              ? state.room
              : (state is RoomJoined)
                  ? state.room
                  : (state as RoomUpdated).room;

          final playerId = (state is RoomCreated)
              ? state.playerId
              : (state is RoomJoined)
                  ? state.playerId
                  : (state as RoomUpdated).playerId;

          final isHost = room.hostId == playerId;
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
                          final isCurrentPlayer = player.id == playerId;

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
      ),
    );
  }
}
