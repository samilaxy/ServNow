// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyBzTgx0Zx8epgedX9LblvF4RNNPRkuG3W0',
    appId: '1:401115732263:web:6671bb0cdbd34f818d3102',
    messagingSenderId: '401115732263',
    projectId: 'sernow-7b679',
    authDomain: 'sernow-7b679.firebaseapp.com',
    storageBucket: 'sernow-7b679.appspot.com',
    measurementId: 'G-SMKXK6G9GX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCY4ICEjS5BHc7tDLtuwio3rDEIqlYxRes',
    appId: '1:401115732263:android:d6cdd7da7e92fd758d3102',
    messagingSenderId: '401115732263',
    projectId: 'sernow-7b679',
    storageBucket: 'sernow-7b679.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbilLa9PNP4eCs0pszfhKkQuS1UFk8IXA',
    appId: '1:401115732263:ios:663e7e22c2f2cf1b8d3102',
    messagingSenderId: '401115732263',
    projectId: 'sernow-7b679',
    storageBucket: 'sernow-7b679.appspot.com',
    iosClientId: '401115732263-dauem25dcmric7pflden06cft6jot0a9.apps.googleusercontent.com',
    iosBundleId: 'com.example.servNow',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbilLa9PNP4eCs0pszfhKkQuS1UFk8IXA',
    appId: '1:401115732263:ios:179a7c6f2d08f5d68d3102',
    messagingSenderId: '401115732263',
    projectId: 'sernow-7b679',
    storageBucket: 'sernow-7b679.appspot.com',
    iosClientId: '401115732263-sni5i0agg7nejeinv58t1rv4frivpbno.apps.googleusercontent.com',
    iosBundleId: 'com.example.servNow.RunnerTests',
  );
}
