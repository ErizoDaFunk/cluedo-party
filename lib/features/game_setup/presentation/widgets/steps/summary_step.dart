import 'package:flutter/material.dart';
import '../../../domain/entities/player.dart';

/// Step 5: Summary before starting the game
class SummaryStep extends StatelessWidget {
  final List<Player> players;
  final bool requireWeapon;
  final bool requireLocation;
  final List<String>? customWeapons;
  final List<String>? customLocations;

  const SummaryStep({
    super.key,
    required this.players,
    required this.requireWeapon,
    required this.requireLocation,
    this.customWeapons,
    this.customLocations,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen de la configuración',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Revisa que todo esté correcto antes de comenzar',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 24),
        
        // Players summary
        _SummaryCard(
          icon: Icons.people,
          title: 'Jugadores',
          value: '${players.length}',
          details: players.map((p) => p.name).join(', '),
        ),
        const SizedBox(height: 12),
        
        // Weapon rule summary
        _SummaryCard(
          icon: Icons.sports_martial_arts,
          title: 'Armas',
          value: requireWeapon ? 'Obligatorias' : 'Desactivadas',
          details: requireWeapon && customWeapons != null
              ? '${customWeapons!.length} armas configuradas'
              : null,
          isActive: requireWeapon,
        ),
        const SizedBox(height: 12),
        
        // Location rule summary
        _SummaryCard(
          icon: Icons.location_on,
          title: 'Lugares',
          value: requireLocation ? 'Obligatorios' : 'Desactivados',
          details: requireLocation && customLocations != null
              ? '${customLocations!.length} lugares configurados'
              : null,
          isActive: requireLocation,
        ),
        const SizedBox(height: 32),
        
        // Ready message
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.shade200, width: 2),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green.shade700,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '¡Todo listo! Pulsa "Iniciar Juego" para comenzar',
                  style: TextStyle(
                    color: Colors.green.shade900,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? details;
  final bool isActive;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    this.details,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (details != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      details!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
