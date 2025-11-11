import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../game_engine/presentation/pages/assignment_reveal_page.dart';
import '../../domain/entities/player.dart';
import '../bloc/game_setup_bloc.dart';
import '../bloc/game_setup_event.dart';
import '../bloc/game_setup_state.dart';
import '../widgets/add_player_dialog.dart';
import '../widgets/steps/game_rules_step.dart';
import '../widgets/steps/locations_setup_step.dart';
import '../widgets/steps/player_setup_step.dart';
import '../widgets/steps/summary_step.dart';
import '../widgets/steps/weapons_setup_step.dart';

class GameSetupPage extends StatefulWidget {
  const GameSetupPage({super.key});

  @override
  State<GameSetupPage> createState() => _GameSetupPageState();
}

class _GameSetupPageState extends State<GameSetupPage> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Configurar Partida'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _showResetDialog(context);
            },
            tooltip: 'Reiniciar configuración',
          ),
        ],
      ),
      body: BlocConsumer<GameSetupBloc, GameSetupState>(
        listener: (context, state) {
          if (state is GameSetupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          } else if (state is GameSetupSuccess) {
            // Show success message but DON'T interfere with UI updates
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.successColor,
                duration: const Duration(milliseconds: 800),
              ),
            );
          } else if (state is GameSetupStarted) {
            // Navigate to assignment reveal page
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AssignmentRevealPage(
                  game: state.game,
                  players: state.players,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GameSetupLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extract data from BOTH GameSetupLoaded AND GameSetupSuccess
          final List<Player> players = _extractPlayers(state);
          final bool requireWeapon = _extractRequireWeapon(state);
          final bool requireLocation = _extractRequireLocation(state);
          final List<String>? customWeapons = _extractCustomWeapons(state);
          final List<String>? customLocations = _extractCustomLocations(state);
          final bool canStart = _extractCanStart(state);

          final List<Step> steps = _buildSteps(
            players: players,
            requireWeapon: requireWeapon,
            requireLocation: requireLocation,
            customWeapons: customWeapons,
            customLocations: customLocations,
            canStart: canStart,
          );

          // Ensure currentStep is within bounds when steps change
          if (_currentStep >= steps.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _currentStep = steps.length - 1;
                });
              }
            });
          }

          return Stepper(
            key: ValueKey('stepper_${steps.length}'), // Force rebuild when steps change
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < steps.length - 1) {
                if (_canProceedFromStep(_currentStep, players, canStart)) {
                  setState(() {
                    _currentStep++;
                  });
                }
              } else {
                if (canStart) {
                  context.read<GameSetupBloc>().add(const StartGameEvent());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Completa todos los pasos requeridos'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep--;
                });
              } else {
                Navigator.of(context).pop();
              }
            },
            onStepTapped: (step) {
              setState(() {
                _currentStep = step;
              });
            },
            controlsBuilder: (context, details) {
              final isLastStep = details.stepIndex == steps.length - 1;
              final isFirstStep = details.stepIndex == 0;

              return Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          isLastStep ? 'Iniciar Juego' : 'Siguiente',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: Text(
                        isFirstStep ? 'Cancelar' : 'Atrás',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            },
            steps: steps,
          );
        },
      ),
      floatingActionButton: _currentStep == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                final playerName = await showDialog<String>(
                  context: context,
                  builder: (context) => const AddPlayerDialog(),
                );

                if (playerName != null && playerName.isNotEmpty) {
                  if (context.mounted) {
                    context
                        .read<GameSetupBloc>()
                        .add(AddPlayerEvent(playerName));
                  }
                }
              },
              icon: const Icon(Icons.person_add),
              label: Text(GameConstants.addPlayer),
            )
          : null,
    );
  }

  // Helper methods to extract data from different states
  List<Player> _extractPlayers(GameSetupState state) {
    if (state is GameSetupLoaded) return state.players;
    if (state is GameSetupSuccess) return state.players;
    return <Player>[];
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

  List<String>? _extractCustomWeapons(GameSetupState state) {
    if (state is GameSetupLoaded) return state.customWeapons;
    if (state is GameSetupSuccess) return state.config?.customWeapons;
    return null;
  }

  List<String>? _extractCustomLocations(GameSetupState state) {
    if (state is GameSetupLoaded) return state.customLocations;
    if (state is GameSetupSuccess) return state.config?.customLocations;
    return null;
  }

  bool _extractCanStart(GameSetupState state) {
    if (state is GameSetupLoaded) return state.canStart;
    if (state is GameSetupSuccess) return state.canStart;
    return false;
  }

  List<Step> _buildSteps({
    required List<Player> players,
    required bool requireWeapon,
    required bool requireLocation,
    required List<String>? customWeapons,
    required List<String>? customLocations,
    required bool canStart,
  }) {
    final steps = <Step>[
      Step(
        title: const Text('Jugadores'),
        subtitle: Text('${players.length} jugadores'),
        content: PlayerSetupStep(players: players),
        isActive: _currentStep >= 0,
        state: players.length >= GameConstants.minPlayers
            ? StepState.complete
            : StepState.indexed,
      ),
      Step(
        title: const Text('Reglas'),
        subtitle: Text(
            '${requireWeapon ? "Armas" : ""}${requireWeapon && requireLocation ? " y " : ""}${requireLocation ? "Lugares" : ""}'),
        content: const GameRulesStep(),
        isActive: _currentStep >= 1,
        state: StepState.indexed,
      ),
    ];

    if (requireWeapon) {
      steps.add(
        Step(
          title: const Text('Armas'),
          subtitle: Text(
              '${customWeapons?.length ?? GameConstants.defaultWeapons.length} armas'),
          content: WeaponsSetupStep(customWeapons: customWeapons),
          isActive: _currentStep >= 2,
          state: StepState.indexed,
        ),
      );
    }

    if (requireLocation) {
      steps.add(
        Step(
          title: const Text('Lugares'),
          subtitle: Text(
              '${customLocations?.length ?? GameConstants.defaultLocations.length} lugares'),
          content: LocationsSetupStep(customLocations: customLocations),
          isActive: _currentStep >= (requireWeapon ? 3 : 2),
          state: StepState.indexed,
        ),
      );
    }

    steps.add(
      Step(
        title: const Text('Resumen'),
        subtitle: const Text('Revisar configuración'),
        content: SummaryStep(
          players: players,
          requireWeapon: requireWeapon,
          requireLocation: requireLocation,
          customWeapons: customWeapons,
          customLocations: customLocations,
        ),
        isActive: _currentStep >= steps.length,
        state: canStart ? StepState.complete : StepState.indexed,
      ),
    );

    return steps;
  }

  bool _canProceedFromStep(int step, List<Player> players, bool canStart) {
    if (step == 0) {
      if (players.length < GameConstants.minPlayers) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Necesitas al menos ${GameConstants.minPlayers} jugadores',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return false;
      }
    }
    return true;
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reiniciar configuración'),
        content: const Text(
          '¿Estás seguro de que quieres borrar toda la configuración?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<GameSetupBloc>().add(const ResetGameSetup());
              setState(() {
                _currentStep = 0;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }
}
