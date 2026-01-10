# Flutter Login App

A beautiful, modern Flutter mobile application with smooth animations and transitions, featuring a login page, dashboard with animated image gallery, and profile screen.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 📱 Features

- **Fake Login Page** - Beautiful gradient login screen with form validation
- **Dashboard** - Welcome message with animated scrollable image gallery
- **Profile Screen** - User profile with statistics and settings
- **Smooth Animations** - Page transitions, fade-ins, and scale animations
- **Hero Animations** - Shared element transitions between screens
- **Responsive Design** - Works on both Android and iOS devices
- **Material Design 3** - Modern UI following latest design guidelines

## 🎨 Screenshots

### Login Screen
- Gradient purple background
- Animated form fields
- Loading indicator on submit
- Smooth fade-in animation

### Dashboard
- Personalized welcome message
- Scrollable image gallery
- Staggered animation on scroll
- Beautiful image cards with overlays

### Profile Screen
- Hero animated avatar
- Statistics cards
- Profile options menu
- Smooth transitions

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode (for development)
- USB cable for device testing

### Installation

1. **Extract the project files**
   ```bash
   unzip flutter_login_app.zip
   cd flutter_login_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Check for issues**
   ```bash
   flutter doctor
   ```

4. **Run the app**
   ```bash
   # On connected device
   flutter run
   
   # Or in release mode for better performance
   flutter run --release
   ```

## 📱 Testing on Real Devices

### Android Device
1. Enable Developer Options and USB Debugging
2. Connect device via USB
3. Run `flutter devices` to verify connection
4. Run `flutter run` to install and launch

### iOS Device
1. Connect iPhone/iPad via USB
2. Trust your computer on the device
3. Configure signing in Xcode
4. Run `flutter run` to install and launch

**For detailed testing instructions, see [TESTING.md](TESTING.md)**

## 🏗️ Project Structure

```
flutter_login_app/
├── lib/
│   ├── main.dart                 # App entry point
│   └── screens/
│       ├── login_screen.dart     # Login page with animations
│       ├── dashboard_screen.dart # Dashboard with image gallery
│       └── profile_screen.dart   # User profile page
├── android/                      # Android-specific files
├── ios/                          # iOS-specific files
├── assets/                       # Images and resources
├── pubspec.yaml                  # Dependencies and metadata
├── README.md                     # This file
├── TESTING.md                    # Testing guide
└── DEPLOYMENT.md                 # Deployment guide
```

## 🎯 App Flow

1. **Launch** → Login Screen (animated entrance)
2. **Login** → Dashboard Screen (slide transition)
3. **Profile Icon** → Profile Screen (hero animation)
4. **Back/Logout** → Returns to Login Screen

## 🔑 Key Features Implementation

### Animations

- **Fade Animations**: Smooth opacity transitions for screen elements
- **Slide Animations**: Directional slides for page transitions
- **Scale Animations**: Growing/shrinking effects for images
- **Hero Animations**: Shared element transitions between screens
- **Staggered Animations**: Sequential animations for list items

### Navigation

- Custom page route builders for smooth transitions
- Hero animations for seamless element transitions
- Proper navigation stack management

### UI Components

- Gradient backgrounds
- Card layouts with shadows
- Custom buttons with loading states
- Form validation
- Scrollable lists with animations
- Network image loading with placeholders

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  shared_preferences: ^2.2.2      # Local storage
  cached_network_image: ^3.3.1    # Image caching
```

## 🛠️ Customization

### Change Color Scheme

Edit `lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF6C63FF), // Change this color
  brightness: Brightness.light,
),
```

### Modify Images

Replace image URLs in `lib/screens/dashboard_screen.dart`:
```dart
final List<String> imageUrls = [
  'your-image-url-1',
  'your-image-url-2',
  // Add more images
];
```

### Update App Name

**Android:** `android/app/src/main/AndroidManifest.xml`
```xml
android:label="Your App Name"
```

**iOS:** `ios/Runner/Info.plist`
```xml
<key>CFBundleDisplayName</key>
<string>Your App Name</string>
```

## 📝 Building for Production

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS IPA
```bash
flutter build ios --release
flutter build ipa --release
```
Output: `build/ios/ipa/*.ipa`

**For detailed deployment instructions, see [DEPLOYMENT.md](DEPLOYMENT.md)**

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Analyze Code
```bash
flutter analyze
```

### Format Code
```bash
flutter format .
```

## 🐛 Common Issues

### Device Not Detected
- Check USB cable connection
- Enable USB debugging (Android)
- Trust computer (iOS)
- Try different USB port

### Build Failed
```bash
flutter clean
flutter pub get
flutter run
```

### Images Not Loading
- Check internet connection
- Verify image URLs are accessible
- Check device permissions

### Slow Performance
- Run in release mode: `flutter run --release`
- Clear app cache
- Restart device

## 📚 Learning Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Animations](https://docs.flutter.dev/development/ui/animations)
- [Material Design 3](https://m3.material.io)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Unsplash for beautiful placeholder images
- Material Design for design guidelines

## 📧 Support

For support and questions:
- Open an issue on GitHub
- Check the [TESTING.md](TESTING.md) for testing help
- Check the [DEPLOYMENT.md](DEPLOYMENT.md) for deployment help

## 🔮 Future Enhancements

- [ ] Add real authentication backend
- [ ] Implement user registration
- [ ] Add password reset functionality
- [ ] Integrate real-time database
- [ ] Add social media login
- [ ] Implement push notifications
- [ ] Add dark mode support
- [ ] Create user settings page
- [ ] Add image upload functionality
- [ ] Implement search feature

---

Made with ❤️ using Flutter
