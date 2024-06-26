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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAQtjexF9FRJW4KU2cRxW9iR0QpM-wE_8s',
    appId: '1:271320377044:web:73e0522d79c9228f2e7d41',
    messagingSenderId: '271320377044',
    projectId: 'gotravel-9fad0',
    authDomain: 'gotravel-9fad0.firebaseapp.com',
    storageBucket: 'gotravel-9fad0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBmS-HyIeL9nqCG6DKowF7ok4g2iifLSLE',
    appId: '1:271320377044:android:c35dff6659296f882e7d41',
    messagingSenderId: '271320377044',
    projectId: 'gotravel-9fad0',
    storageBucket: 'gotravel-9fad0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAUTmjk6d8wsZWXYn1zKpkLcqyvQZARYQI',
    appId: '1:271320377044:ios:ab696fd9e8fcaa9f2e7d41',
    messagingSenderId: '271320377044',
    projectId: 'gotravel-9fad0',
    storageBucket: 'gotravel-9fad0.appspot.com',
    iosBundleId: 'com.example.gotravel',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAUTmjk6d8wsZWXYn1zKpkLcqyvQZARYQI',
    appId: '1:271320377044:ios:ab696fd9e8fcaa9f2e7d41',
    messagingSenderId: '271320377044',
    projectId: 'gotravel-9fad0',
    storageBucket: 'gotravel-9fad0.appspot.com',
    iosBundleId: 'com.example.gotravel',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAQtjexF9FRJW4KU2cRxW9iR0QpM-wE_8s',
    appId: '1:271320377044:web:eb1e9b382d72fbd82e7d41',
    messagingSenderId: '271320377044',
    projectId: 'gotravel-9fad0',
    authDomain: 'gotravel-9fad0.firebaseapp.com',
    storageBucket: 'gotravel-9fad0.appspot.com',
  );
}
