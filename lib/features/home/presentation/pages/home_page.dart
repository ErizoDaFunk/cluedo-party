import 'package:flutter/material.dart';
import '../../../../core/config/route_names.dart';
import '../../../../core/constants/game_constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Game icon
              Icon(
                Icons.person_search,
                size: 120,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              
              // Game title
              const Text(
                GameConstants.appTitle,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                '🎭 Mata antes de que te maten 🔪',
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              
              // Single device mode button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteNames.gameSetup);
                  },
                  icon: const Icon(Icons.phone_android, size: 28),
                  label: const Text(
                    'Modo Un Dispositivo',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Multiplayer mode button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteNames.multiplayerSetup);
                  },
                  icon: const Icon(Icons.devices, size: 28),
                  label: const Text(
                    'Modo Varios Dispositivos',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
