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
    apiKey: 'AIzaSyAyCZqO6B1kOXhRXbYrkNdS77gRkOdzs8c',
    appId: '1:106395754985:web:965d43fee05ec1a622ab78',
    messagingSenderId: '106395754985',
    projectId: 'productivity-app-f3674',
    authDomain: 'productivity-app-f3674.firebaseapp.com',
    storageBucket: 'productivity-app-f3674.appspot.com',
    measurementId: 'G-D3S30R5PSF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCyxW7V9g5gBtykbwvjESAQhgl0nVCUnxE',
    appId: '1:106395754985:android:aee6d833bf59a3ad22ab78',
    messagingSenderId: '106395754985',
    projectId: 'productivity-app-f3674',
    storageBucket: 'productivity-app-f3674.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmnNlkhJrGoII1fP28kCsnWRD7n4slSd8',
    appId: '1:106395754985:ios:4f515ffd401db29d22ab78',
    messagingSenderId: '106395754985',
    projectId: 'productivity-app-f3674',
    storageBucket: 'productivity-app-f3674.appspot.com',
    iosClientId: '106395754985-49gshn2jbmcvg5g979rra2oqnqp6h3nt.apps.googleusercontent.com',
    iosBundleId: 'com.example.productivityApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCmnNlkhJrGoII1fP28kCsnWRD7n4slSd8',
    appId: '1:106395754985:ios:4f515ffd401db29d22ab78',
    messagingSenderId: '106395754985',
    projectId: 'productivity-app-f3674',
    storageBucket: 'productivity-app-f3674.appspot.com',
    iosClientId: '106395754985-49gshn2jbmcvg5g979rra2oqnqp6h3nt.apps.googleusercontent.com',
    iosBundleId: 'com.example.productivityApp',
  );
}
