import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/game_constants.dart';
import '../../bloc/game_setup_bloc.dart';
import '../../bloc/game_setup_event.dart';

/// Step 4: Locations customization
class LocationsSetupStep extends StatefulWidget {
  final List<String>? customLocations;

  const LocationsSetupStep({
    super.key,
    this.customLocations,
  });

  @override
  State<LocationsSetupStep> createState() => _LocationsSetupStepState();
}

class _LocationsSetupStepState extends State<LocationsSetupStep> {
  late List<String> _locations;
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _locations = widget.customLocations?.toList() ??
        GameConstants.defaultLocations.toList();
  }

  @override
  void didUpdateWidget(LocationsSetupStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local state when props change (e.g., when navigating back to this step)
    if (widget.customLocations != oldWidget.customLocations) {
      _locations = widget.customLocations?.toList() ??
          GameConstants.defaultLocations.toList();
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _addLocation() {
    if (_locationController.text.trim().isEmpty) return;

    setState(() {
      _locations.add(_locationController.text.trim());
      _locationController.clear();
    });
    
    context.read<GameSetupBloc>().add(UpdateCustomLocations(_locations));
  }

  void _removeLocation(int index) {
    setState(() {
      _locations.removeAt(index);
    });
    
    context.read<GameSetupBloc>().add(UpdateCustomLocations(_locations));
  }

  void _resetToDefault() {
    setState(() {
      _locations = GameConstants.defaultLocations.toList();
    });
    
    context.read<GameSetupBloc>().add(UpdateCustomLocations(_locations));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personaliza los lugares del juego',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Añade, elimina o modifica los lugares disponibles',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 24),
        
        // Add location input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Nuevo lugar',
                  hintText: 'Ej: Ático',
                  prefixIcon: Icon(Icons.add_location),
                ),
                onSubmitted: (_) => _addLocation(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addLocation,
              child: const Text('Añadir'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Reset button
        TextButton.icon(
          onPressed: _resetToDefault,
          icon: const Icon(Icons.refresh),
          label: const Text('Restaurar lugares por defecto'),
        ),
        const SizedBox(height: 16),
        
        // Locations count
        Text(
          'Lugares: ${_locations.length}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        
        // Locations list
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: _locations.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(_locations[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeLocation(index),
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
