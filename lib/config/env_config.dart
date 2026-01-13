/// ═══════════════════════════════════════════════════════════════════════════
/// 🎯 SINGLE SOURCE OF TRUTH - Configure Your App Here
/// ═══════════════════════════════════════════════════════════════════════════
/// 
/// ⚠️ IMPORTANT: This is the ONLY file you need to edit when cloning this repo!
/// 
/// After editing this file, run: dart run tool/setup_config.dart
/// This will automatically update all platform-specific files.
/// 
/// ═══════════════════════════════════════════════════════════════════════════

class EnvConfig {
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // 1️⃣ SUPABASE CONFIGURATION
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // Find these at: Supabase Dashboard → Settings → API
  
  static const String supabaseUrl = 'https://waiavurchyemodltjrzn.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndhaWF2dXJjaHllbW9kbHRqcnpuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc2ODgwODIsImV4cCI6MjA4MzI2NDA4Mn0.dfB4vIPy7eRZSJ49-lVUpzrI9eU2lre8w01PqTBUy-U';

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // 2️⃣ GOOGLE OAUTH CLIENT IDs
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // Find these at: Google Cloud Console → Credentials
  
  // Web Client ID (used for both iOS and Android)
  static const String googleWebClientId = '537364653418-svii5a1ojkmjnrnpi06ncmsauh7f28so.apps.googleusercontent.com';
  
  // iOS Client ID
  static const String googleIosClientId = '537364653418-rv2hspk5hnllq2lj7dv5iv8raaa6nij2.apps.googleusercontent.com';
  
  // Android Client ID (for reference only - Android uses SHA-1 auto-detection)
  static const String googleAndroidClientId = '537364653418-f8e2rfntkkqd44unsbp8dsi3mt1mftej.apps.googleusercontent.com';

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // 3️⃣ APP IDENTIFIERS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // These must match your OAuth client bundle ID / package name
  
  static const String androidPackageName = 'com.gougc.admaker';
  static const String iosBundleId = 'com.gougc.admaker';
  
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // 🔧 COMPUTED VALUES (DO NOT EDIT)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  /// Automatically computed reversed iOS Client ID for Info.plist
  static String get reversedIosClientId {
    final parts = googleIosClientId.split('.');
    return parts.reversed.join('.');
  }
  
  /// Extract Supabase project ID from URL
  static String get supabaseProjectId {
    final uri = Uri.parse(supabaseUrl);
    return uri.host.split('.').first;
  }

  // Validation
  static bool get isConfigured {
    return supabaseUrl.contains('supabase.co') &&
        !supabaseUrl.contains('yourproject') &&
        !supabaseAnonKey.contains('your_supabase');
  }

  static String get configurationError {
    if (!isConfigured) {
      return 'Please configure your Supabase credentials in lib/config/env_config.dart';
    }
    return '';
  }
}
