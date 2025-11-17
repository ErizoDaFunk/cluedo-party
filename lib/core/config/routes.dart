import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/game_setup/presentation/bloc/game_setup_bloc.dart';
import '../../features/game_setup/presentation/bloc/game_setup_event.dart';
import '../../features/game_setup/presentation/pages/game_setup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/multiplayer/presentation/bloc/room_bloc.dart';
import '../../features/multiplayer/presentation/pages/multiplayer_setup_page.dart';
import '../di/injection.dart';
import 'route_names.dart';

/// App routes configuration
class AppRoutes {
  AppRoutes._();

  static const String initialRoute = RouteNames.home;

  static Map<String, WidgetBuilder> routes = {
    RouteNames.home: (context) => const HomePage(),
    RouteNames.gameSetup: (context) => BlocProvider(
          create: (_) => getIt<GameSetupBloc>()..add(const LoadGameSetup()),
          child: const GameSetupPage(),
        ),
    RouteNames.multiplayerSetup: (context) => BlocProvider(
          create: (_) => getIt<RoomBloc>(),
          child: const MultiplayerSetupPage(),
        ),
    // Future routes:
    // RouteNames.gameActive: (context) => const GameActivePage(),
    // RouteNames.assignmentReveal: (context) => const AssignmentRevealPage(),
  };
}
