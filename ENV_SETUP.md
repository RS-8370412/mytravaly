# Environment Setup

This app uses environment variables for configuration. Sensitive data like API tokens are stored in a `.env` file that is **not** committed to version control.

## Quick Start

1. **Create your `.env` file:**
   ```bash
   # Windows
   copy .env.example .env
   
   # Mac/Linux
   cp .env.example .env
   ```

2. **Configure your values:**
   Open `.env` and replace the placeholder values with your actual credentials.

3. **Required Variables:**
   - `MYTRAVALY_API_BASE_URL` - API base URL
   - `MYTRAVALY_AUTH_TOKEN` - Your authentication token

4. **Optional Variables:**
   - `APP_NAME` - Application name
   - `APP_BRAND_COLOR` - Brand color hex code (without `#`)

## Firebase Configuration

Firebase configuration is generated automatically via FlutterFire CLI. The `firebase_options.dart` file should not be manually edited.

### Setup Firebase

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

This will generate platform-specific Firebase config files:
- **Android**: `android/app/google-services.json`
- **iOS**: `ios/Runner/GoogleService-Info.plist`
- **Code**: `lib/firebase_options.dart`

## Security Notes

✅ **Do:**
- Keep `.env` in `.gitignore`
- Use `.env.example` as a template
- Use different credentials for dev/staging/production

❌ **Don't:**
- Commit `.env` to version control
- Hardcode sensitive values in source code
- Share `.env` files publicly

## Troubleshooting

**".env file not found"**
- Ensure you've created `.env` from `.env.example`

**"Null check operator used on null"**
- Verify all required variables are set in `.env`

**Firebase not working**
- Run `flutterfire configure` to regenerate config files
- Ensure Firebase project is configured for all platforms (Android/iOS/Web)

## Resources

- [flutter_dotenv Documentation](https://pub.dev/packages/flutter_dotenv)
- [Firebase Setup Guide](https://firebase.flutter.dev/docs/overview)
