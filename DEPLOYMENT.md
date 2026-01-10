# Deployment Guide - Flutter Login App

This guide covers deploying your Flutter app to production for both Android (Google Play Store) and iOS (Apple App Store).

## Table of Contents
1. [Pre-Deployment Checklist](#pre-deployment-checklist)
2. [Android Deployment](#android-deployment)
3. [iOS Deployment](#ios-deployment)
4. [Post-Deployment](#post-deployment)

---

## Pre-Deployment Checklist

Before deploying, ensure you have:

- [ ] Tested the app thoroughly on real devices
- [ ] Fixed all bugs and crashes
- [ ] Optimized app performance
- [ ] Prepared app icons and splash screens
- [ ] Written app description and screenshots
- [ ] Set up proper version numbering
- [ ] Created privacy policy (if required)
- [ ] Prepared promotional materials

---

## Android Deployment

### Step 1: Create a Keystore

A keystore is required to sign your Android app. Create one using:

```bash
keytool -genkey -v -keystore ~/flutter-login-app-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias flutter-login-app
```

You'll be asked for:
- Keystore password (remember this!)
- Key password (remember this!)
- Your name, organization, etc.

**Important:** Keep this keystore file safe and never commit it to version control!

### Step 2: Configure Signing in Android

Create a file `android/key.properties`:

```properties
storePassword=<your-keystore-password>
keyPassword=<your-key-password>
keyAlias=flutter-login-app
storeFile=<path-to-your-keystore>/flutter-login-app-key.jks
```

Update `android/app/build.gradle`:

```gradle
// Add before android { block
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing code ...

    // Add signing configuration
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            // Enable code shrinking, obfuscation, and optimization
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### Step 3: Configure App Information

Update `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        applicationId "com.yourcompany.flutter_login_app"  // Change this
        minSdk 21
        targetSdk 34  // Latest Android version
        versionCode 1  // Increment for each release
        versionName "1.0.0"  // User-visible version
    }
}
```

### Step 4: Update AndroidManifest.xml

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.yourcompany.flutter_login_app">
    
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <application
        android:label="Your App Name"
        android:icon="@mipmap/ic_launcher">
        <!-- ... rest of manifest ... -->
    </application>
</manifest>
```

### Step 5: Build Release APK/AAB

**For App Bundle (Recommended for Play Store):**
```bash
flutter build appbundle --release
```

Output location: `build/app/outputs/bundle/release/app-release.aab`

**For APK (For direct distribution):**
```bash
flutter build apk --release
```

Output location: `build/app/outputs/flutter-apk/app-release.apk`

### Step 6: Google Play Store Submission

1. **Create Google Play Console Account**
   - Go to [Google Play Console](https://play.google.com/console)
   - Pay one-time $25 registration fee
   - Complete account setup

2. **Create New App**
   - Click "Create app"
   - Fill in app details:
     - App name
     - Default language
     - App or game
     - Free or paid

3. **Complete Store Listing**
   - App name (up to 50 characters)
   - Short description (up to 80 characters)
   - Full description (up to 4000 characters)
   - Screenshots (minimum 2, up to 8)
     - Phone: 16:9 or 9:16, minimum 320px
     - Tablet (if applicable)
   - App icon: 512x512 PNG
   - Feature graphic: 1024x500 PNG
   - App category
   - Contact information

4. **Content Rating**
   - Complete questionnaire
   - Get rating (Everyone, Teen, Mature, etc.)

5. **App Content**
   - Privacy policy URL (required for most apps)
   - Ads declaration
   - Target audience
   - Data safety information

6. **Release Setup**
   - Choose countries/regions
   - Create production release
   - Upload app bundle (.aab file)
   - Add release notes
   - Review and rollout

7. **Review Process**
   - Submit for review
   - Wait for approval (usually 1-3 days)
   - Address any issues if rejected

### Android Deployment Checklist

- [ ] Keystore created and secured
- [ ] App signed with release keystore
- [ ] Version code and name updated
- [ ] Application ID is unique
- [ ] All permissions declared
- [ ] App tested in release mode
- [ ] Store listing completed
- [ ] Screenshots prepared (2-8)
- [ ] App icon and feature graphic created
- [ ] Privacy policy published
- [ ] Content rating obtained
- [ ] App bundle built successfully
- [ ] Release notes written

---

## iOS Deployment

### Step 1: Apple Developer Account

1. **Enroll in Apple Developer Program**
   - Go to [Apple Developer](https://developer.apple.com)
   - Enroll ($99/year)
   - Complete verification (may take 24-48 hours)

### Step 2: Configure App in Xcode

Open the iOS project:
```bash
cd flutter_login_app
open ios/Runner.xcworkspace
```

In Xcode:

1. **Select Runner** in project navigator
2. **General Tab:**
   - Display Name: "Your App Name"
   - Bundle Identifier: "com.yourcompany.flutterloginapp"
   - Version: 1.0.0
   - Build: 1

3. **Signing & Capabilities:**
   - Team: Select your Apple Developer team
   - Check "Automatically manage signing"

### Step 3: Update Info.plist

Edit `ios/Runner/Info.plist`:

```xml
<key>CFBundleDisplayName</key>
<string>Your App Name</string>
<key>CFBundleName</key>
<string>Your App Name</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
```

### Step 4: Prepare App Icons

You need app icons in various sizes. Use a tool like [App Icon Generator](https://appicon.co/):

1. Create a 1024x1024 PNG icon
2. Generate all required sizes
3. Replace icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Step 5: Build Release Archive

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Build iOS release
flutter build ios --release
```

Or in Xcode:
1. Select **Any iOS Device** as destination
2. Product > Archive
3. Wait for archive to complete

### Step 6: App Store Connect Setup

1. **Go to [App Store Connect](https://appstoreconnect.apple.com)**

2. **Create New App**
   - Click "My Apps" > "+" > "New App"
   - Platforms: iOS
   - Name: Your app name
   - Primary Language: English
   - Bundle ID: Select your bundle ID
   - SKU: Unique identifier (e.g., com.yourcompany.flutterloginapp)

3. **App Information**
   - Privacy Policy URL (required)
   - Category (Primary and Secondary)
   - Content Rights
   - Age Rating

4. **Pricing and Availability**
   - Price: Free or Paid
   - Availability: Countries/regions
   - App Store distribution

### Step 7: Prepare Metadata

1. **Screenshots** (Required for all supported devices)
   - iPhone 6.7" (1290 x 2796) - 3-10 images
   - iPhone 6.5" (1284 x 2778) - 3-10 images
   - iPhone 5.5" (1242 x 2208) - 3-10 images
   - iPad Pro 12.9" (2048 x 2732) - 3-10 images

2. **App Preview** (Optional but recommended)
   - 30-second video preview

3. **Description**
   - App name (max 30 characters)
   - Subtitle (max 30 characters)
   - Promotional text (max 170 characters)
   - Description (max 4000 characters)
   - Keywords (max 100 characters, comma-separated)
   - Support URL
   - Marketing URL (optional)

### Step 8: Upload Build

**Using Xcode:**
1. After archiving, Xcode Organizer opens
2. Select your archive
3. Click "Distribute App"
4. Select "App Store Connect"
5. Click "Upload"
6. Wait for processing (15-60 minutes)

**Using Command Line:**
```bash
# Build and archive
flutter build ipa --release

# Upload using Xcode
open build/ios/archive/Runner.xcarchive
```

### Step 9: Submit for Review

1. Return to App Store Connect
2. Go to your app > "App Store" tab
3. Click "+ Version" if needed
4. Select your uploaded build
5. Complete all required fields
6. Answer App Review questions:
   - Demo account (if app requires login)
   - Contact information
   - Notes for reviewer
7. Submit for review

### Step 10: Review Process

- **In Review:** Usually 1-3 days
- **Possible outcomes:**
  - Approved: App goes live automatically or on your scheduled date
  - Rejected: Address issues and resubmit
  - Metadata Rejected: Fix metadata and resubmit

### iOS Deployment Checklist

- [ ] Apple Developer account active
- [ ] Bundle identifier configured
- [ ] App icons in all required sizes
- [ ] App signed with distribution certificate
- [ ] Version and build numbers set
- [ ] Info.plist updated
- [ ] App tested in release mode
- [ ] App archived successfully
- [ ] App Store Connect app created
- [ ] All metadata completed
- [ ] Screenshots prepared (3-10 per size)
- [ ] Privacy policy published
- [ ] Age rating completed
- [ ] Build uploaded and processed
- [ ] Demo account provided (if needed)
- [ ] Submitted for review

---

## Post-Deployment

### Monitoring

**Android (Google Play Console):**
- Monitor crash reports
- Check user reviews and ratings
- View download statistics
- Track user retention

**iOS (App Store Connect):**
- Monitor crash reports in Xcode Organizer
- Check App Analytics
- Respond to user reviews
- Track downloads and revenue

### Updates

When releasing updates:

**Android:**
1. Increment `versionCode` in build.gradle
2. Update `versionName` if needed
3. Build new app bundle
4. Create new release in Play Console
5. Add release notes
6. Submit for review

**iOS:**
1. Increment Build number
2. Update Version if needed
3. Build and archive new version
4. Upload to App Store Connect
5. Create new version
6. Add "What's New" notes
7. Submit for review

### Version Numbering

Follow semantic versioning (MAJOR.MINOR.PATCH):
- MAJOR: Incompatible changes
- MINOR: New features, backwards compatible
- PATCH: Bug fixes

Example: 1.0.0 → 1.0.1 → 1.1.0 → 2.0.0

### Best Practices

1. **Test Thoroughly**
   - Test on multiple devices
   - Test all features
   - Test in release mode
   - Beta test with real users

2. **Prepare Marketing**
   - Create app website
   - Prepare press kit
   - Plan launch strategy
   - Set up analytics

3. **User Support**
   - Set up support email
   - Create FAQ
   - Monitor reviews
   - Respond to user feedback

4. **Regular Updates**
   - Fix bugs promptly
   - Add new features
   - Keep dependencies updated
   - Maintain compatibility

---

## Useful Commands

### Check Version
```bash
flutter --version
```

### Build Release (Android)
```bash
flutter build apk --release
flutter build appbundle --release
```

### Build Release (iOS)
```bash
flutter build ios --release
flutter build ipa --release
```

### Analyze Code
```bash
flutter analyze
```

### Run Tests
```bash
flutter test
```

### Clean Build
```bash
flutter clean
flutter pub get
```

---

## Resources

- [Flutter Deployment Docs](https://docs.flutter.dev/deployment)
- [Google Play Console](https://play.google.com/console)
- [Apple Developer Portal](https://developer.apple.com)
- [App Store Connect](https://appstoreconnect.apple.com)
- [Material Design Guidelines](https://material.io/design)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

## Support

For issues or questions:
- Flutter Documentation: https://docs.flutter.dev
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
- Flutter Community: https://flutter.dev/community
