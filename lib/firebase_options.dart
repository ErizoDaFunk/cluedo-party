// TODO: Este archivo será generado por 'flutterfire configure'
// Por ahora, usaremos valores de placeholder

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAzKI6mDsJiGwyTW3VQ4ATHai71YWA7Vf0',
    appId: '1:897830629016:web:7e27c6882801036dcd6aed',
    messagingSenderId: '897830629016',
    projectId: 'cluedo-party-cfafa',
    authDomain: 'cluedo-party-cfafa.firebaseapp.com',
    storageBucket: 'cluedo-party-cfafa.firebasestorage.app',
    measurementId: 'G-21VH81G5PE',
  );

  // TODO: Reemplazar con tus credenciales de Firebase

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZri_CckDU4YdO7IKnUtg2Kb-4vK4ACB0',
    appId: '1:897830629016:android:82046be09bc40202cd6aed',
    messagingSenderId: '897830629016',
    projectId: 'cluedo-party-cfafa',
    storageBucket: 'cluedo-party-cfafa.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBWM5_gmdzTVHI3GqMOA3K8PS_v9ry7hNs',
    appId: '1:897830629016:ios:c0fc42ea1e04b7fdcd6aed',
    messagingSenderId: '897830629016',
    projectId: 'cluedo-party-cfafa',
    storageBucket: 'cluedo-party-cfafa.firebasestorage.app',
    iosBundleId: 'com.cluedoparty.cluedoParty',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.cluedoParty',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAzKI6mDsJiGwyTW3VQ4ATHai71YWA7Vf0',
    appId: '1:897830629016:web:4f8d63373cddabf4cd6aed',
    messagingSenderId: '897830629016',
    projectId: 'cluedo-party-cfafa',
    authDomain: 'cluedo-party-cfafa.firebaseapp.com',
    storageBucket: 'cluedo-party-cfafa.firebasestorage.app',
    measurementId: 'G-PC1J49NN7L',
  );

}