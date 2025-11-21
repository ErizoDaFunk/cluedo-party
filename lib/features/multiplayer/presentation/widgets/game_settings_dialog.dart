import 'package:flutter/material.dart';
import '../../domain/entities/room.dart';

class GameSettingsDialog extends StatefulWidget {
  final GameSettings initialSettings;
  final Function(GameSettings) onSave;

  const GameSettingsDialog({
    super.key,
    required this.initialSettings,
    required this.onSave,
  });

  @override
  State<GameSettingsDialog> createState() => _GameSettingsDialogState();
}

class _GameSettingsDialogState extends State<GameSettingsDialog> {
  late bool requireWeapon;
  late bool requireLocation;
  late List<String> availableWeapons;
  late List<String> availableLocations;
  late bool hostVerifies;
  late bool killerVerifies;
  late bool victimVerifies;

  final TextEditingController _weaponController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requireWeapon = widget.initialSettings.requireWeapon;
    requireLocation = widget.initialSettings.requireLocation;
    availableWeapons = List.from(widget.initialSettings.availableWeapons);
    availableLocations = List.from(widget.initialSettings.availableLocations);
    hostVerifies = widget.initialSettings.killVerification.hostVerifies;
    killerVerifies = widget.initialSettings.killVerification.killerVerifies;
    victimVerifies = widget.initialSettings.killVerification.victimVerifies;
  }

  @override
  void dispose() {
    _weaponController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _addWeapon() {
    final weapon = _weaponController.text.trim();
    if (weapon.isNotEmpty && !availableWeapons.contains(weapon)) {
      setState(() {
        availableWeapons.add(weapon);
        _weaponController.clear();
      });
    }
  }

  void _removeWeapon(String weapon) {
    setState(() {
      availableWeapons.remove(weapon);
    });
  }

  void _addLocation() {
    final location = _locationController.text.trim();
    if (location.isNotEmpty && !availableLocations.contains(location)) {
      setState(() {
        availableLocations.add(location);
        _locationController.clear();
      });
    }
  }

  void _removeLocation(String location) {
    setState(() {
      availableLocations.remove(location);
    });
  }

  void _save() {
    final settings = GameSettings(
      requireWeapon: requireWeapon,
      requireLocation: requireLocation,
      availableWeapons: availableWeapons,
      availableLocations: availableLocations,
      killVerification: KillVerification(
        hostVerifies: hostVerifies,
        killerVerifies: killerVerifies,
        victimVerifies: victimVerifies,
      ),
    );
    widget.onSave(settings);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Configuración del Juego',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Weapon Settings
                    SwitchListTile(
                      title: const Text('Requerir Arma'),
                      subtitle: const Text('Los asesinatos deben usar un arma'),
                      value: requireWeapon,
                      onChanged: (value) {
                        setState(() {
                          requireWeapon = value;
                          if (!value) {
                            availableWeapons.clear();
                          }
                        });
                      },
                    ),
                    if (requireWeapon) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Armas Disponibles',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _weaponController,
                                decoration: const InputDecoration(
                                  hintText: 'Ej: Pistola, Cuchillo...',
                                  border: OutlineInputBorder(),
                                ),
                                onSubmitted: (_) => _addWeapon(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _addWeapon,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: availableWeapons.map((weapon) {
                            return Chip(
                              label: Text(weapon),
                              onDeleted: () => _removeWeapon(weapon),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    const Divider(height: 32),

                    // Location Settings
                    SwitchListTile(
                      title: const Text('Requerir Lugar'),
                      subtitle: const Text('Los asesinatos deben ocurrir en un lugar específico'),
                      value: requireLocation,
                      onChanged: (value) {
                        setState(() {
                          requireLocation = value;
                          if (!value) {
                            availableLocations.clear();
                          }
                        });
                      },
                    ),
                    if (requireLocation) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Lugares Disponibles',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _locationController,
                                decoration: const InputDecoration(
                                  hintText: 'Ej: Biblioteca, Cocina...',
                                  border: OutlineInputBorder(),
                                ),
                                onSubmitted: (_) => _addLocation(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _addLocation,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: availableLocations.map((location) {
                            return Chip(
                              label: Text(location),
                              onDeleted: () => _removeLocation(location),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    const Divider(height: 32),

                    // Kill Verification Settings
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Verificación de Asesinato',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      title: const Text('Host verifica'),
                      subtitle: const Text('El anfitrión debe confirmar los asesinatos'),
                      value: hostVerifies,
                      onChanged: (value) {
                        setState(() {
                          hostVerifies = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Asesino verifica'),
                      subtitle: const Text('El asesino reporta su eliminación'),
                      value: killerVerifies,
                      onChanged: (value) {
                        setState(() {
                          killerVerifies = value ?? true;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Víctima verifica'),
                      subtitle: const Text('La víctima debe confirmar su eliminación'),
                      value: victimVerifies,
                      onChanged: (value) {
                        setState(() {
                          victimVerifies = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _save,
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
