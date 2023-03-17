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
    apiKey: 'AIzaSyCkKb2MxsOU80qXVaAyckUM1seHM8JbMcM',
    appId: '1:80485709896:web:da23820f3d95e187ad007d',
    messagingSenderId: '80485709896',
    projectId: 'team-cooing',
    authDomain: 'team-cooing.firebaseapp.com',
    storageBucket: 'team-cooing.appspot.com',
    measurementId: 'G-7Y03Z1C1QF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXiA3g8ifO87pH03ipVNTWQt1BfdUulZY',
    appId: '1:80485709896:android:da35f148a20d710aad007d',
    messagingSenderId: '80485709896',
    projectId: 'team-cooing',
    storageBucket: 'team-cooing.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBuhi6D-X0RF-XhUJBAS3C50-ZReQpxk-w',
    appId: '1:80485709896:ios:f227b48195eea57ead007d',
    messagingSenderId: '80485709896',
    projectId: 'team-cooing',
    storageBucket: 'team-cooing.appspot.com',
    iosClientId: '80485709896-adalppnfo4cml3om2ocs2mudm1498bob.apps.googleusercontent.com',
    iosBundleId: 'com.example.cooingFront',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBuhi6D-X0RF-XhUJBAS3C50-ZReQpxk-w',
    appId: '1:80485709896:ios:f227b48195eea57ead007d',
    messagingSenderId: '80485709896',
    projectId: 'team-cooing',
    storageBucket: 'team-cooing.appspot.com',
    iosClientId: '80485709896-adalppnfo4cml3om2ocs2mudm1498bob.apps.googleusercontent.com',
    iosBundleId: 'com.example.cooingFront',
  );
}