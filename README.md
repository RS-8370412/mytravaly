# MyTravaly Flutter App

Simple Flutter app with:
- Home page with search
- Search Results page (wired to MyTravaly public API)
- Firebase Authentication (Email/Password + Google Sign‑In)

## Prerequisites
- Flutter SDK (3.8+)
- Dart SDK (bundled with Flutter)
- Android Studio / Xcode for device emulators
- Firebase project (for auth): enable Email/Password and Google sign‑in

Check Flutter setup:
```bash
flutter doctor
```

## Firebase Setup
The app uses `firebase_core`, `firebase_auth`, and `google_sign_in`.

1) Add Firebase to the project (Android, iOS, web) via Firebase Console.
2) Place the config files:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
   - Web: add `firebaseConfig` to `web/index.html` if using web + run `flutterfire configure` if preferred.
3) Ensure `main.dart` initializes Firebase before run:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

## Install Dependencies
```bash
flutter pub get
```

## Run the App
- Android emulator / device:
```bash
flutter run -d android
```

- iOS simulator (on macOS):
```bash
flutter run -d ios
```

- Web:
```bash
flutter run -d chrome
```

## Assets
The app references:
- `assets/logo.png`
- `assets/signin_signup_logo.png`
- `assets/google-logo-icon.png`

Ensure they exist and are declared in `pubspec.yaml`.

## Troubleshooting
- If Firebase auth fails on web, verify OAuth client IDs and authorized domains in Firebase Console.
- If API calls fail, confirm `authtoken` and set a valid `visitorToken` if required.
- On iOS, run `cd ios && pod install` if CocoaPods dependencies need updating.

## License
This project is provided as-is for demonstration purposes.
# MyTravaly Flutter App

Simple Flutter app with:
- Home page with search
- Search Results page (wired to MyTravaly public API)
- Firebase Authentication (Email/Password + Google Sign‑In)

## Prerequisites
- Flutter SDK (3.8+)
- Dart SDK (bundled with Flutter)
- Android Studio / Xcode for device emulators
- Firebase project (for auth): enable Email/Password and Google sign‑in

Check Flutter setup:
```bash
flutter doctor
```

## Firebase Setup
The app uses `firebase_core`, `firebase_auth`, and `google_sign_in`.

1) Add Firebase to the project (Android, iOS, web) via Firebase Console.
2) Place the config files:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
   - Web: add `firebaseConfig` to `web/index.html` if using web + run `flutterfire configure` if preferred.
3) Ensure `main.dart` initializes Firebase before run:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

## Install Dependencies
```bash
flutter pub get
```

## Run the App
- Android emulator / device:
```bash
flutter run -d android
```

- iOS simulator (on macOS):
```bash
flutter run -d ios
```

- Web:
```bash
flutter run -d chrome
```

## Assets
The app references:
- `assets/logo.png`
- `assets/signin_signup_logo.png`
- `assets/google-logo-icon.png`

Ensure they exist and are declared in `pubspec.yaml`.

## Troubleshooting
- If Firebase auth fails on web, verify OAuth client IDs and authorized domains in Firebase Console.
- If API calls fail, confirm `authtoken` and set a valid `visitorToken` if required.
- On iOS, run `cd ios && pod install` if CocoaPods dependencies need updating.

## License
This project is provided as-is for demonstration purposes.
