import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/room.dart';
import '../../domain/usecases/sync_game_state.dart';

class ActiveGamePage extends StatefulWidget {
  final String roomCode;
  final String playerId;

  const ActiveGamePage({
    super.key,
    required this.roomCode,
    required this.playerId,
  });

  @override
  State<ActiveGamePage> createState() => _ActiveGamePageState();
}

class _ActiveGamePageState extends State<ActiveGamePage> {
  final WatchRoomUseCase _watchRoomUseCase = getIt<WatchRoomUseCase>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partida Activa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Consulta tu objetivo tantas veces como necesites'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _watchRoomUseCase(widget.roomCode),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Cargando partida...'),
            );
          }

          return snapshot.data!.fold(
            (failure) {
              return Center(
                child: Text('Error: ${failure.message}'),
              );
            },
            (room) {
              final currentPlayer = room.players[widget.playerId];
              
              if (currentPlayer == null) {
                return const Center(
                  child: Text('Error: Jugador no encontrado'),
                );
              }

              final target = currentPlayer.targetId != null
                  ? room.players[currentPlayer.targetId]
                  : null;

              final alivePlayers = room.players.values.where((p) => p.isAlive).length;
              final totalPlayers = room.players.length;

              // Check if game is finished
              if (room.status == RoomStatus.finished || alivePlayers == 1) {
                return _buildGameFinished(room, currentPlayer);
              }

              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Player Status Card
                      Card(
                        elevation: 4,
                        color: currentPlayer.isAlive
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Icon(
                                currentPlayer.isAlive
                                    ? Icons.favorite
                                    : Icons.heart_broken,
                                size: 48,
                                color: currentPlayer.isAlive
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentPlayer.isAlive ? 'Estás Vivo' : 'Has Muerto',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: currentPlayer.isAlive
                                      ? Colors.green.shade900
                                      : Colors.red.shade900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Eliminaciones: ${currentPlayer.killCount}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Mission Card (only if alive)
                      if (currentPlayer.isAlive && target != null) ...[
                        Card(
                          elevation: 4,
                          color: Colors.orange.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed, color: Colors.orange.shade900),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Tu Objetivo',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.orange.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.person, size: 20),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Víctima: ',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            target.name,
                                            style: const TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      if (currentPlayer.assignedWeapon != null) ...[
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.gavel, size: 20),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Arma: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              currentPlayer.assignedWeapon!,
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                      if (currentPlayer.assignedLocation != null) ...[
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on, size: 20),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Lugar: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              currentPlayer.assignedLocation!,
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showKillConfirmationDialog(context, room, currentPlayer, target);
                            },
                            icon: const Icon(Icons.report),
                            label: const Text(
                              'Reportar Asesinato',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],

                      // Players Board
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
                                    'Tablero de Jugadores',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '$alivePlayers/$totalPlayers vivos',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ...room.players.values.map((player) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        player.isAlive
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: player.isAlive
                                            ? Colors.green
                                            : Colors.red,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          player.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            decoration: player.isAlive
                                                ? null
                                                : TextDecoration.lineThrough,
                                            fontWeight: player.id == widget.playerId
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      if (player.id == widget.playerId)
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
                                      const SizedBox(width: 8),
                                      Text(
                                        '${player.killCount} 💀',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildGameFinished(Room room, RoomPlayer currentPlayer) {
    final sortedPlayers = room.players.values.toList()
      ..sort((a, b) => b.killCount.compareTo(a.killCount));
    
    final winner = sortedPlayers.first;
    final isWinner = winner.id == widget.playerId;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isWinner ? Icons.emoji_events : Icons.flag,
              size: 100,
              color: isWinner ? Colors.amber : Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              isWinner ? '¡Ganaste!' : 'Fin del Juego',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ganador: ${winner.name}',
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              'Eliminaciones: ${winner.killCount}',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Volver al Inicio'),
            ),
          ],
        ),
      ),
    );
  }

  void _showKillConfirmationDialog(
    BuildContext context,
    Room room,
    RoomPlayer killer,
    RoomPlayer victim,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Asesinato'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Confirmas que asesinaste a ${victim.name}?'),
            if (killer.assignedWeapon != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Arma: ${killer.assignedWeapon}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            if (killer.assignedLocation != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Lugar: ${killer.assignedLocation}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement kill verification use case
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidad de asesinato próximamente...'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
