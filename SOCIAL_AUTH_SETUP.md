# Social Authentication Setup Guide

This guide explains how to configure Google, Apple, and Facebook authentication for the Wizard app.

## Prerequisites

- Google Cloud Console account
- Apple Developer Account (for Apple Sign-In)
- Facebook Developer Account

## Google OAuth Setup

### 1. Google Cloud Console Configuration

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Google+ API and Google Sign-In API
4. Go to "Credentials" → "Create Credentials" → "OAuth 2.0 Client IDs"
5. Configure OAuth consent screen:
   - Add your app name and logo
   - Add authorized domains
   - Add test users if in testing mode

### 2. Create OAuth 2.0 Credentials

1. **Application type**: Web application
2. **Name**: Wizard API
3. **Authorized redirect URIs**:
   - `http://localhost:8080/auth/google/callback` (for development)
   - `https://yourdomain.com/auth/google/callback` (for production)

4. **Application type**: Android
5. **Name**: Wizard Mobile
6. **Package name**: `com.wizard.app` (update in `mobile/android/app/build.gradle`)
7. **SHA-1 certificate fingerprint**: Get from your keystore

### 3. Environment Variables

Add to `api/.env`:
```
GOOGLE_CLIENT_ID=your_web_client_id_here
GOOGLE_CLIENT_SECRET=your_web_client_secret_here
```

## Apple Sign-In Setup

### 1. Apple Developer Account Setup

1. Go to [Apple Developer Portal](https://developer.apple.com/)
2. Navigate to "Certificates, Identifiers & Profiles"
3. Create a new App ID with "Sign In with Apple" capability enabled

### 2. Create Service ID

1. Go to "Identifiers" → "Services IDs"
2. Create new Service ID:
   - **Description**: Wizard App
   - **Identifier**: `com.wizard.app.signin`
   - **Primary App ID**: Select your app ID
3. Configure Sign In with Apple:
   - **Primary App ID**: Your app ID
   - **Domains and Subdomains**: `yourdomain.com`
   - **Return URLs**: `https://yourdomain.com/auth/apple/callback`

### 3. Create Sign In with Apple Key

1. Go to "Keys" → "Create a key"
2. **Key Name**: Wizard Sign In Key
3. **Enable**: Sign In with Apple
4. **Configure**: Select your Primary App ID
5. Download the `.p8` file and note the Key ID

### 4. Environment Variables

Add to `api/.env`:
```
APPLE_CLIENT_ID=com.wizard.app.signin
APPLE_TEAM_ID=your_team_id_here
APPLE_KEY_ID=your_key_id_here
APPLE_PRIVATE_KEY_PATH=path/to/AuthKey_XXXXXXXXXX.p8
```

## Facebook Login Setup

### 1. Facebook App Creation

1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create a new app:
   - **App Name**: Wizard
   - **App Contact Email**: your-email@example.com
   - **App Purpose**: Consumer

### 2. Add Facebook Login Product

1. In your app dashboard, click "Add Product"
2. Find "Facebook Login" and click "Set Up"
3. Choose "Web" platform
4. Configure Facebook Login:
   - **Valid OAuth Redirect URIs**: 
     - `http://localhost:8080/auth/facebook/callback`
     - `https://yourdomain.com/auth/facebook/callback`

### 3. App Settings

1. Go to "Settings" → "Basic"
2. Add your domain to "App Domains"
3. Add platform (Android/iOS) with package name and class name

### 4. Environment Variables

Add to `api/.env`:
```
FACEBOOK_APP_ID=your_app_id_here
FACEBOOK_APP_SECRET=your_app_secret_here
```

## Mobile App Configuration

### iOS Configuration

1. **Info.plist** (`mobile/ios/Runner/Info.plist`):
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>google</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
    <dict>
        <key>CFBundleURLName</key>
        <string>facebook</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fbYOUR_APP_ID</string>
        </array>
    </dict>
</array>
```

2. **Runner.entitlements** (`mobile/ios/Runner/Runner.entitlements`):
```xml
<key>com.apple.developer.applesignin</key>
<array>
    <string>Default</string>
</array>
```

### Android Configuration

1. **build.gradle** (`mobile/android/app/build.gradle`):
```gradle
android {
    defaultConfig {
        manifestPlaceholders = [
            'appAuthRedirectScheme': 'com.wizard.app'
        ]
    }
}
```

2. **strings.xml** (`mobile/android/app/src/main/res/values/strings.xml`):
```xml
<string name="default_web_client_id">YOUR_WEB_CLIENT_ID</string>
```

3. **google-services.json**: Download from Google Cloud Console and place in `mobile/android/app/`

## Testing

### 1. Backend Testing

Test the API endpoints:
```bash
# Google OAuth
curl -X POST http://localhost:8080/api/auth/google \
  -H "Content-Type: application/json" \
  -d '{"idToken": "your_google_id_token"}'

# Apple Sign-In
curl -X POST http://localhost:8080/api/auth/apple \
  -H "Content-Type: application/json" \
  -d '{"idToken": "your_apple_id_token"}'

# Facebook Login
curl -X POST http://localhost:8080/api/auth/facebook \
  -H "Content-Type: application/json" \
  -d '{"accessToken": "your_facebook_access_token"}'
```

### 2. Mobile Testing

1. **Google Sign-In**: Test on physical device (simulator may not work)
2. **Apple Sign-In**: Test on physical iOS device
3. **Facebook Login**: Test on both platforms

### 3. Common Issues

**Google Sign-In Issues:**
- Ensure SHA-1 fingerprint is correct
- Check package name matches exactly
- Verify OAuth consent screen is configured

**Apple Sign-In Issues:**
- Test only on physical iOS devices
- Ensure Service ID is properly configured
- Check that the .p8 key file is accessible

**Facebook Login Issues:**
- Verify app is not in development mode restrictions
- Check redirect URIs are exactly correct
- Ensure Facebook app is approved for production

## Security Notes

1. **Never commit** `.p8` files or client secrets to version control
2. **Use environment variables** for all sensitive configuration
3. **Rotate keys regularly** for production apps
4. **Implement proper error handling** for failed authentications
5. **Validate tokens** on the backend before creating user sessions

## Production Deployment

1. Update all redirect URIs to production domains
2. Configure proper CORS settings
3. Set up monitoring for authentication failures
4. Implement rate limiting on auth endpoints
5. Use HTTPS for all authentication flows

## Support

For issues with social authentication:
1. Check the respective platform documentation
2. Verify all configuration steps were completed
3. Test with minimal example apps first
4. Check server logs for detailed error messages
