// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBA59yaV8H5Hq9PStr_tk1XMaR0xpILRng',
    appId: '1:798859396444:web:019d64f7e485defa6bed99',
    messagingSenderId: '798859396444',
    projectId: 'exam-maker-using-ai',
    authDomain: 'exam-maker-using-ai.firebaseapp.com',
    storageBucket: 'exam-maker-using-ai.appspot.com',
    measurementId: 'G-3939FY6YJX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBgHGlmhrJ0WcRdFhDtVO5zwYg7iIzle4k',
    appId: '1:798859396444:android:7e1e60e28bafb20e6bed99',
    messagingSenderId: '798859396444',
    projectId: 'exam-maker-using-ai',
    storageBucket: 'exam-maker-using-ai.appspot.com',
  );
}