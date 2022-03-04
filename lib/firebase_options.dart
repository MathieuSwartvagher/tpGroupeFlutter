// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCYcSC7fhpBCYixjwxcdo8Rqs5-4y-_eTU',
    appId: '1:991570838635:web:70d4f03716d850f4de5d2e',
    messagingSenderId: '991570838635',
    projectId: 'tpengroupe',
    authDomain: 'tpengroupe.firebaseapp.com',
    storageBucket: 'tpengroupe.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWdCvRLCW1Cc0DG3zvPTXRCB71V_YGde0',
    appId: '1:991570838635:android:45ec33561a4dd1bfde5d2e',
    messagingSenderId: '991570838635',
    projectId: 'tpengroupe',
    storageBucket: 'tpengroupe.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBSs5MXGg8gllMSKODKSmTXpWDzQBKqQjY',
    appId: '1:991570838635:ios:674590b2256c95fbde5d2e',
    messagingSenderId: '991570838635',
    projectId: 'tpengroupe',
    storageBucket: 'tpengroupe.appspot.com',
    iosClientId: '991570838635-8vbrgrv0coti46g1qbc3uhrsn57tpl85.apps.googleusercontent.com',
    iosBundleId: 'com.tpEnGroupe.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBSs5MXGg8gllMSKODKSmTXpWDzQBKqQjY',
    appId: '1:991570838635:ios:674590b2256c95fbde5d2e',
    messagingSenderId: '991570838635',
    projectId: 'tpengroupe',
    storageBucket: 'tpengroupe.appspot.com',
    iosClientId: '991570838635-8vbrgrv0coti46g1qbc3uhrsn57tpl85.apps.googleusercontent.com',
    iosBundleId: 'com.tpEnGroupe.app',
  );
}