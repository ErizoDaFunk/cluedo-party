/// Game constants and default values
class GameConstants {
  // Prevent instantiation
  GameConstants._();

  // Game Rules
  static const int minPlayers = 3;
  static const int maxPlayers = 20;
  static const int recommendedMinPlayers = 5;
  static const int recommendedMaxPlayers = 12;

  // Default Weapons (Spanish - Cluedo classic)
  static const List<String> defaultWeapons = [
    'Candelabro',
    'Cuchillo',
    'Pistola',
    'Cuerda',
    'Llave inglesa',
    'Tubo de plomo',
    'Veneno',
    'Hacha',
    'Tijeras',
    'Bate de béisbol',
  ];

  // Default Locations (Spanish - Classic mansion rooms + extras)
  static const List<String> defaultLocations = [
    'Salón',
    'Cocina',
    'Comedor',
    'Biblioteca',
    'Estudio',
    'Sala de billar',
    'Invernadero',
    'Sala de baile',
    'Vestíbulo',
    'Terraza',
    'Sótano',
    'Ático',
    'Jardín',
    'Garaje',
    'Piscina',
  ];

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Storage Keys
  static const String currentGameKey = 'current_game';
  static const String customWeaponsKey = 'custom_weapons';
  static const String customLocationsKey = 'custom_locations';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';

  // Error Messages (Spanish)
  static const String errorGeneric = 'Ha ocurrido un error';
  static const String errorNotEnoughPlayers = 'Se necesitan al menos 3 jugadores';
  static const String errorTooManyPlayers = 'Máximo 20 jugadores permitidos';
  static const String errorDuplicatePlayer = 'Ya existe un jugador con ese nombre';
  static const String errorEmptyPlayerName = 'El nombre no puede estar vacío';
  static const String errorNoActiveGame = 'No hay ningún juego activo';
  static const String errorGameAlreadyStarted = 'El juego ya ha comenzado';

  // Success Messages (Spanish)
  static const String successPlayerAdded = 'Jugador añadido correctamente';
  static const String successPlayerRemoved = 'Jugador eliminado';
  static const String successGameStarted = 'Juego iniciado correctamente';
  static const String successGameReset = 'Juego reiniciado';

  // UI Labels (Spanish)
  static const String appTitle = 'Cluedo Party';
  static const String startNewGame = 'Iniciar Nuevo Juego';
  static const String addPlayer = 'Añadir Jugador';
  static const String playerName = 'Nombre del jugador';
  static const String cancel = 'Cancelar';
  static const String accept = 'Aceptar';
  static const String delete = 'Eliminar';
  static const String confirm = 'Confirmar';
  static const String startGame = 'Comenzar Juego';
  static const String showAssignment = 'Ver Mi Misión';
  static const String gotIt = '¡Entendido!';
  static const String newGame = 'Nueva Partida';
  static const String continueGame = 'Continuar Partida';

  // Assignment Display (Spanish)
  static const String youMustKill = 'Debes matar a';
  static const String withWeapon = 'Con';
  static const String atLocation = 'En';
  static const String warning = '¡Atención!';
  static const String warningMessage = 'Una vez revelada tu misión, no podrás volver atrás';

  // Game Setup (Spanish)
  static const String players = 'Jugadores';
  static const String addPlayerHint = 'Toca el botón + para añadir jugadores';
  static const String minPlayersHint = 'Añade al menos 3 jugadores para comenzar';
  static const String readyToStart = '¡Listo para comenzar!';
}

