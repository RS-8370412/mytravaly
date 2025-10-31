# Environment Variables Setup Guide

## Overview

This app uses environment variables for configuration. Sensitive data like API tokens are stored in a `.env` file that is **NOT** committed to version control.

## Setup Instructions

### 1. Create `.env` File

Copy the example file and fill in your values:

```bash
# On Windows PowerShell
copy .env.example .env

# On Mac/Linux
cp .env.example .env
```

### 2. Configure Your Values

Open `.env` in a text editor and add your actual values:

```env
# MyTravaly API Configuration
MYTRAVALY_API_BASE_URL=https://api.mytravaly.com/public/v1/
MYTRAVALY_AUTH_TOKEN=your_actual_auth_token_here

# Visitor Token (Optional - Leave empty if not needed)
MYTRAVALY_VISITOR_TOKEN=

# App Configuration
APP_NAME=MyTravaly
APP_BRAND_COLOR=FFFF6F61
```

### 3. Current Values (For Testing)

**IMPORTANT**: These are example values. Replace with your own in production!

```env
MYTRAVALY_API_BASE_URL=https://api.mytravaly.com/public/v1/
MYTRAVALY_AUTH_TOKEN=71523fdd8d26f585315b4233e39d9263
```

## Firebase Configuration

**Note**: Firebase configuration is stored in `firebase_options.dart` and generated automatically by FlutterFire. This file **should NOT** be moved to `.env` because:

1. It's required at compile time
2. FlutterFire CLI automatically generates it
3. Firebase credentials are platform-specific (Android, iOS, Web)
4. The file is generated from the official Firebase config files

### Current Firebase Setup

✅ **Android**: `android/app/google-services.json`  
✅ **iOS**: `ios/Runner/GoogleService-Info.plist`  
✅ **Code**: `lib/firebase_options.dart`

### If You Need to Reconfigure Firebase

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

This will automatically regenerate `firebase_options.dart` with your Firebase project settings.

## Security Best Practices

### ✅ DO:
- Keep `.env` in `.gitignore` (already done)
- Use `.env.example` as a template
- Store only non-sensitive defaults in `.env.example`
- Use different `.env` files for different environments
- Rotate API tokens regularly

### ❌ DON'T:
- Commit `.env` to version control
- Hardcode sensitive values in source code
- Share `.env` files in screenshots or documentation
- Use production tokens in development

## Environment Variables Reference

### MyTravaly API

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `MYTRAVALY_API_BASE_URL` | API base URL | Yes | `https://api.mytravaly.com/public/v1/` |
| `MYTRAVALY_AUTH_TOKEN` | Authentication token | Yes | None |
| `MYTRAVALY_VISITOR_TOKEN` | Visitor token (optional) | No | Empty |

### App Config

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `APP_NAME` | Application name | No | `MyTravaly` |
| `APP_BRAND_COLOR` | Brand color hex code | No | `FFFF6F61` |

## Code Usage

The app automatically loads `.env` in `main.dart`:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: '.env');
  
  // Rest of initialization...
}
```

Access values in your code:

```dart
import '../config/constants.dart';

// Get API base URL
final baseUrl = AppConfig.apiBaseUrl;

// Get auth token
final token = AppConfig.apiToken;

// Get visitor token (async)
final visitorToken = await AppConfig.getVisitorToken();
```

## Troubleshooting

### Error: ".env file not found"
**Solution**: Make sure you've created `.env` from `.env.example`:
```bash
copy .env.example .env
```

### Error: "Null check operator used on null"
**Solution**: Check that all required environment variables are set in `.env`

### Firebase not working on Web
**Solution**: 
1. Ensure Firebase is configured for web in Firebase Console
2. Run `flutterfire configure` to regenerate config
3. Check that web domain is authorized in Firebase settings

### API calls failing
**Solution**:
1. Verify `MYTRAVALY_AUTH_TOKEN` is correct
2. Check network connectivity
3. Review error messages in console

## File Structure

```
mytravaly/
├── .env                    # Your actual values (gitignored)
├── .env.example            # Template file (committed)
├── .gitignore              # Ensures .env is not committed
├── lib/
│   ├── config/
│   │   └── constants.dart  # Reads from .env
│   └── main.dart           # Loads .env on startup
└── firebase_options.dart   # Firebase config (generated)
```

## Production Deployment

For production, ensure:
1. Create a production `.env` with production credentials
2. Use CI/CD secrets for automated deployments
3. Never hardcode production values
4. Use different Firebase projects for dev/staging/prod
5. Enable Firebase app check for security

## Additional Resources

- [flutter_dotenv Documentation](https://pub.dev/packages/flutter_dotenv)
- [Firebase Setup Guide](https://firebase.flutter.dev/docs/overview)
- [Environment Variables Best Practices](https://12factor.net/config)

