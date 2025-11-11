import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/game_setup_bloc.dart';
import '../../bloc/game_setup_event.dart';
import '../../bloc/game_setup_state.dart';

/// Step 2: Game rules configuration
class GameRulesStep extends StatelessWidget {
  const GameRulesStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameSetupBloc, GameSetupState>(
      builder: (context, state) {
        // Extract values from current state
        final bool requireWeapon = _extractRequireWeapon(state);
        final bool requireLocation = _extractRequireLocation(state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configura las reglas del juego',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Decide qué elementos serán obligatorios en cada asesinato',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),

            // Weapon requirement toggle
            Card(
              child: SwitchListTile(
                title: const Text(
                  '🔪 Arma obligatoria',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Cada asesinato debe realizarse con un arma específica',
                ),
                value: requireWeapon,
                onChanged: (value) {
                  context.read<GameSetupBloc>().add(
                        ToggleWeaponRequirement(value),
                      );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Location requirement toggle
            Card(
              child: SwitchListTile(
                title: const Text(
                  '🗺️ Lugar obligatorio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Cada asesinato debe ocurrir en un lugar específico',
                ),
                value: requireLocation,
                onChanged: (value) {
                  context.read<GameSetupBloc>().add(
                        ToggleLocationRequirement(value),
                      );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Info message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Si activas estas opciones, podrás personalizar las listas en los siguientes pasos',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  bool _extractRequireWeapon(GameSetupState state) {
    if (state is GameSetupLoaded) return state.requireWeapon;
    if (state is GameSetupSuccess) return state.config?.requireWeapon ?? true;
    return true;
  }

  bool _extractRequireLocation(GameSetupState state) {
    if (state is GameSetupLoaded) return state.requireLocation;
    if (state is GameSetupSuccess) return state.config?.requireLocation ?? true;
    return true;
  }
}