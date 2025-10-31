// File generated manually from provided Firebase config files.
// ignore_for_file: public_member_api_docs, constant_identifier_names

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not configured.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError('Unsupported platform for Firebase initialization.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEAvChxkxCzlLn7_qPn3q6Eovj_mVqfRY',
    appId: '1:467229590695:android:bba507364a71deb1640782',
    messagingSenderId: '467229590695',
    projectId: 'mytravaly-1d796',
    storageBucket: 'mytravaly-1d796.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-hHqItY0oOaYZvSvvlW8pKFc8KQ8hfzE',
    appId: '1:467229590695:ios:afc0b133bc4ceaf6640782',
    messagingSenderId: '467229590695',
    projectId: 'mytravaly-1d796',
    storageBucket: 'mytravaly-1d796.firebasestorage.app',
    iosBundleId: 'com.mytravaly.app',
  );
}
