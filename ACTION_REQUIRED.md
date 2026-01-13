# 🚀 Quick Setup Guide - Just 2 Steps!

## ⚠️ IMPORTANT: This repo is configured for easy cloning!

All configurable values are in **ONE file**: `lib/config/env_config.dart`

A setup script will automatically update all platform-specific files for you.

---

## ✨ Setup Steps

### Step 1️⃣: Update Configuration (REQUIRED)

Open: `lib/config/env_config.dart`

Replace these values with your actual credentials:

```dart
// 1️⃣ SUPABASE CONFIGURATION
static const String supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
static const String supabaseAnonKey = 'YOUR_ANON_KEY';

// 2️⃣ GOOGLE OAUTH CLIENT IDs  
static const String googleWebClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
static const String googleIosClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com';
static const String googleAndroidClientId = 'YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com';

// 3️⃣ APP IDENTIFIERS
static const String androidPackageName = 'com.example.yourapp';
static const String iosBundleId = 'com.example.yourapp';
```

**Where to find:**
- Supabase Dashboard → Settings → API → URL and anon/public key
- Google Cloud Console → Credentials → Your OAuth 2.0 Client IDs

---

### Step 2️⃣: Run Setup Script (REQUIRED)

After editing `env_config.dart`, run this command to auto-update all platform files:

```bash
dart run tool/setup_config.dart
```

This automatically updates:
- ✅ `ios/Runner/Info.plist` - Reversed iOS Client ID
- ✅ `android/app/src/main/AndroidManifest.xml` - Supabase URL
- ✅ `android/app/build.gradle` - Package name
- ✅ `ios/Runner.xcodeproj/project.pbxproj` - Bundle ID

**No manual editing of platform files needed!**

---

## 🔧 Additional Setup (First Time Only)

### Configure Google Cloud Console

1. ✅ **Web OAuth client** with redirect URI:
   - `https://[your-project].supabase.co/auth/v1/callback`

2. ✅ **iOS OAuth client** with:
   - Bundle ID matching your `iosBundleId` in config

3. ✅ **Android OAuth client** with:
   - Package name matching your `androidPackageName` in config
   - SHA-1 fingerprint (see below)

4. ✅ **OAuth consent screen** configured

### Get Android SHA-1 Fingerprint

```bash
cd android
./gradlew signingReport
```

Copy the SHA-1 and add it to your Android OAuth client in Google Cloud Console.

---

### Configure Supabase

In Supabase Dashboard:

1. ✅ Authentication → Providers → **Google is ENABLED**
2. ✅ **Google Client ID** (Web) is set
3. ✅ **Google Client Secret** (Web) is set
4. ✅ **Authorized Client IDs** includes your Web Client ID

---

## ✅ Ready to Run!

Once the setup script completes successfully:

```bash
flutter run
```

Or specify a device:

```bash
# Run on iOS
flutter run -d iphone

# Run on Android  
flutter run -d emulator
```

---

## 📋 Quick Test Checklist

After launch:

1. [ ] App shows login screen (not config error)
2. [ ] Click "Sign in with Google"
3. [ ] Google account picker appears
4. [ ] Select account
5. [ ] Home screen appears with your info
6. [ ] Profile picture loads
7. [ ] Click sign out
8. [ ] Returns to login screen

---

## 🐛 Troubleshooting

**"Configuration Error"**
→ Update `lib/config/env_config.dart` with real values

**"Failed to update Info.plist"**
→ Check that `ios/Runner/Info.plist` exists and has CFBundleURLSchemes section

**"Developer Error" (iOS/Android)**
→ Run `dart run tool/setup_config.dart` again to ensure all files are updated

**"Invalid Grant"**
→ Verify Web Client ID is correct in both Supabase dashboard and `env_config.dart`

**"Account picker doesn't show"**
→ Already implemented - we force sign out before sign in

---

## 📁 What Changed?

### Before (Manual Setup - Multiple Files to Edit):
- ❌ `lib/config/env_config.dart` - Credentials
- ❌ `ios/Runner/Info.plist` - Reversed iOS Client ID (manual calculation)
- ❌ `android/app/src/main/AndroidManifest.xml` - Supabase URL
- ❌ `android/app/build.gradle` - Package name
- ❌ `ios/Runner.xcodeproj/project.pbxproj` - Bundle ID

### After (Automated Setup - ONE File):
- ✅ `lib/config/env_config.dart` - **ALL configuration in one place**
- ✅ `dart run tool/setup_config.dart` - **Automatically updates everything**

---

## 🎯 For Each New Project Clone

1. Clone this repo
2. Edit `lib/config/env_config.dart` (update credentials and identifiers)
3. Run `dart run tool/setup_config.dart`
4. Run `flutter run`

That's it! 🚀

---

**Need detailed help?** See [GOOGLE_AUTH_SETUP.md](GOOGLE_AUTH_SETUP.md)
