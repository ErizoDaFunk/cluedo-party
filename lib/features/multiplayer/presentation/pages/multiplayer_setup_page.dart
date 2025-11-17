import 'package:flutter/material.dart';

class MultiplayerSetupPage extends StatefulWidget {
  const MultiplayerSetupPage({super.key});

  @override
  State<MultiplayerSetupPage> createState() => _MultiplayerSetupPageState();
}

class _MultiplayerSetupPageState extends State<MultiplayerSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _roomCodeController = TextEditingController();
  final _playerNameJoinController = TextEditingController();
  final _playerNameCreateController = TextEditingController();

  @override
  void dispose() {
    _roomCodeController.dispose();
    _playerNameJoinController.dispose();
    _playerNameCreateController.dispose();
    super.dispose();
  }

  void _joinGame() {
    if (_formKey.currentState!.validate()) {
      final roomCode = _roomCodeController.text.trim().toUpperCase();
      final playerName = _playerNameJoinController.text.trim();
      
      // TODO: Implement join game logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uniéndose a sala $roomCode como $playerName')),
      );
    }
  }

  void _createRoom() {
    if (_playerNameCreateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce tu nombre')),
      );
      return;
    }

    final playerName = _playerNameCreateController.text.trim();
    
    // TODO: Implement create room logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Creando sala como $playerName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Multijugador'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Join existing game section
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.login,
                              color: Theme.of(context).primaryColor,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Unirse a una Partida',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _roomCodeController,
                          decoration: const InputDecoration(
                            labelText: 'Código de Sala',
                            hintText: 'Ej: ABC123',
                            prefixIcon: Icon(Icons.meeting_room),
                            border: OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.characters,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Introduce el código de sala';
                            }
                            if (value.trim().length < 4) {
                              return 'Código inválido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _playerNameJoinController,
                          decoration: const InputDecoration(
                            labelText: 'Tu Nombre',
                            hintText: 'Nombre del jugador',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Introduce tu nombre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _joinGame,
                            icon: const Icon(Icons.login),
                            label: const Text(
                              'Unirse al Juego',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Divider with text
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[400])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'O',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[400])),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Create new room section
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: Theme.of(context).primaryColor,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Crear Nueva Sala',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _playerNameCreateController,
                          decoration: const InputDecoration(
                            labelText: 'Tu Nombre',
                            hintText: 'Nombre del anfitrión',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _createRoom,
                            icon: const Icon(Icons.add),
                            label: const Text(
                              'Crear Sala',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
