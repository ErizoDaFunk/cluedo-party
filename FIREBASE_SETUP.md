# Configuración de Firebase para Cluedo Party

## Pasos para configurar Firebase

### 1. Crear proyecto en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Haz clic en "Agregar proyecto" o "Add project"
3. Nombra tu proyecto (ej: "cluedo-party")
4. Sigue los pasos del asistente

### 2. Configurar Firebase en tu proyecto Flutter

Una vez que tengas tu proyecto de Firebase creado, ejecuta el siguiente comando en la raíz de tu proyecto:

```bash
flutterfire configure
```

Este comando te permitirá:
- Seleccionar tu proyecto de Firebase
- Configurar las plataformas (Android, iOS, Web, Windows)
- Generar automáticamente el archivo `firebase_options.dart`

### 3. Habilitar Firestore en Firebase Console

1. En Firebase Console, ve a tu proyecto
2. En el menú lateral, busca "Firestore Database"
3. Haz clic en "Crear base de datos"
4. Selecciona "Modo de producción" o "Modo de prueba" (recomendado para desarrollo)
5. Elige una ubicación para tu base de datos

### 4. Reglas de seguridad de Firestore (Desarrollo)

Para desarrollo, puedes usar estas reglas básicas:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /rooms/{roomId} {
      allow read, write: if true; // ⚠️ Solo para desarrollo
    }
  }
}
```

⚠️ **IMPORTANTE**: Estas reglas permiten acceso completo. Para producción, necesitarás reglas más estrictas.

### 5. (Opcional) Configurar Firebase Cloud Messaging

Para recibir notificaciones push:

1. En Firebase Console, ve a "Cloud Messaging"
2. Configura las credenciales para cada plataforma (Android/iOS/Web)

### 6. Inicializar Firebase en la app

El código ya está preparado. Solo necesitas descomentar la inicialización en `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // ... resto del código
}
```

## Estructura de datos en Firestore

### Colección: `rooms`

```
rooms/
  ├── {roomCode}/              // ej: "ABC123"
      ├── code: string         // "ABC123"
      ├── hostId: string       // ID del jugador anfitrión
      ├── status: string       // "waiting" | "playing" | "finished"
      ├── createdAt: timestamp
      ├── players: map
      │   ├── {playerId1}:
      │   │   ├── id: string
      │   │   ├── name: string
      │   │   ├── isAlive: boolean
      │   │   ├── targetId: string
      │   │   ├── killCount: number
      │   │   └── isHost: boolean
      │   └── {playerId2}: ...
```

## Comandos útiles

```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase
flutterfire configure

# Ver proyectos disponibles
firebase projects:list

# Ver apps configuradas
flutterfire list
```

## Troubleshooting

### Error: "FlutterFire CLI not found"
```bash
dart pub global activate flutterfire_cli
```

### Error: "Firebase not initialized"
Asegúrate de que `Firebase.initializeApp()` se llama antes de usar cualquier servicio de Firebase.

### Error de dependencias
```bash
fvm flutter clean
fvm flutter pub get
```

## Next Steps

Una vez configurado Firebase:

1. ✅ Firebase configurado con `flutterfire configure`
2. ✅ Firestore habilitado en Firebase Console
3. ✅ Firebase inicializado en `main.dart`
4. 🔄 Implementar casos de uso (crear sala, unirse, etc.)
5. 🔄 Conectar UI con BLoC/Cubit
6. 🔄 Testing

---

Para más información: [FlutterFire Documentation](https://firebase.flutter.dev/)
