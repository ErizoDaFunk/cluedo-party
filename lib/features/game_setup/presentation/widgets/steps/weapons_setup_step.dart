import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/game_constants.dart';
import '../../bloc/game_setup_bloc.dart';
import '../../bloc/game_setup_event.dart';

/// Step 3: Weapons customization
class WeaponsSetupStep extends StatefulWidget {
  final List<String>? customWeapons;

  const WeaponsSetupStep({
    super.key,
    this.customWeapons,
  });

  @override
  State<WeaponsSetupStep> createState() => _WeaponsSetupStepState();
}

class _WeaponsSetupStepState extends State<WeaponsSetupStep> {
  late List<String> _weapons;
  final _weaponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weapons = widget.customWeapons?.toList() ??
        GameConstants.defaultWeapons.toList();
  }

  @override
  void dispose() {
    _weaponController.dispose();
    super.dispose();
  }

  void _addWeapon() {
    if (_weaponController.text.trim().isEmpty) return;

    setState(() {
      _weapons.add(_weaponController.text.trim());
      _weaponController.clear();
    });
    
    context.read<GameSetupBloc>().add(UpdateCustomWeapons(_weapons));
  }

  void _removeWeapon(int index) {
    setState(() {
      _weapons.removeAt(index);
    });
    
    context.read<GameSetupBloc>().add(UpdateCustomWeapons(_weapons));
  }

  void _resetToDefault() {
    setState(() {
      _weapons = GameConstants.defaultWeapons.toList();
    });
    
    context.read<GameSetupBloc>().add(UpdateCustomWeapons(_weapons));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personaliza las armas del juego',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Añade, elimina o modifica las armas disponibles',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 24),
        
        // Add weapon input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _weaponController,
                decoration: const InputDecoration(
                  labelText: 'Nueva arma',
                  hintText: 'Ej: Sartén',
                  prefixIcon: Icon(Icons.add_circle_outline),
                ),
                onSubmitted: (_) => _addWeapon(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addWeapon,
              child: const Text('Añadir'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Reset button
        TextButton.icon(
          onPressed: _resetToDefault,
          icon: const Icon(Icons.refresh),
          label: const Text('Restaurar armas por defecto'),
        ),
        const SizedBox(height: 16),
        
        // Weapons count
        Text(
          'Armas: ${_weapons.length}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        
        // Weapons list
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: _weapons.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.sports_martial_arts),
                  title: Text(_weapons[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeWeapon(index),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
