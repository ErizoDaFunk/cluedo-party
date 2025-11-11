import 'package:flutter/material.dart';
import 'core/config/theme.dart';
import 'core/constants/game_constants.dart';

void main() {
  runApp(const CluedoPartyApp());
}

class CluedoPartyApp extends StatelessWidget {
  const CluedoPartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: GameConstants.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Use dark theme by default (mystery vibe)
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GameConstants.appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to ${GameConstants.appTitle}!',
              style: AppTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'A party game organizer',
              style: AppTheme.bodyLarge,
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to game setup
              },
              icon: const Icon(Icons.play_arrow),
              label: Text(GameConstants.startNewGame),
            ),
          ],
        ),
      ),
    );
  }
}
