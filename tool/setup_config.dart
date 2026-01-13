#!/usr/bin/env dart
/// ═══════════════════════════════════════════════════════════════════════════
/// 🔧 Configuration Setup Script
/// ═══════════════════════════════════════════════════════════════════════════
/// 
/// This script reads configuration from lib/config/env_config.dart
/// and automatically updates all platform-specific files.
/// 
/// Usage: dart run tool/setup_config.dart
/// 
/// ═══════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:path/path.dart' as path;

// Import the configuration
import '../lib/config/env_config.dart';

void main() async {
  print('');
  print('═══════════════════════════════════════════════════════════════════════');
  print('🔧 Setting up configuration from lib/config/env_config.dart');
  print('═══════════════════════════════════════════════════════════════════════');
  print('');

  // Get project root directory
  final scriptDir = path.dirname(Platform.script.toFilePath());
  final projectRoot = path.normalize(path.join(scriptDir, '..'));

  try {
    // Update iOS Info.plist
    await updateIosInfoPlist(projectRoot);
    
    // Update Android Manifest
    await updateAndroidManifest(projectRoot);
    
    // Update Android build.gradle
    await updateAndroidBuildGradle(projectRoot);
    
    // Update iOS project.pbxproj
    await updateIosProjectFile(projectRoot);
    
    print('');
    print('✅ Configuration complete!');
    print('');
    print('📋 Updated files:');
    print('  • ios/Runner/Info.plist');
    print('  • android/app/src/main/AndroidManifest.xml');
    print('  • android/app/build.gradle');
    print('  • ios/Runner.xcodeproj/project.pbxproj');
    print('');
    print('🚀 You can now run: flutter run');
    print('');
  } catch (e) {
    print('');
    print('❌ Error: $e');
    print('');
    exit(1);
  }
}

Future<void> updateIosInfoPlist(String projectRoot) async {
  final infoPlistPath = path.join(projectRoot, 'ios', 'Runner', 'Info.plist');
  final file = File(infoPlistPath);
  
  if (!await file.exists()) {
    throw Exception('Info.plist not found at: $infoPlistPath');
  }
  
  print('📝 Updating iOS Info.plist...');
  
  var content = await file.readAsString();
  
  // Replace the reversed iOS Client ID
  final reversedId = EnvConfig.reversedIosClientId;
  
  // Pattern to match the URL scheme string
  final pattern = RegExp(
    r'(<key>CFBundleURLSchemes</key>\s*<array>\s*<dict>.*?<array>\s*<string>)([^<]+)(</string>)',
    dotAll: true,
  );
  
  if (content.contains(pattern)) {
    content = content.replaceFirstMapped(pattern, (match) {
      return '${match.group(1)}$reversedId${match.group(3)}';
    });
    print('  ✓ Set reversed iOS Client ID: $reversedId');
  } else {
    // Try simpler pattern
    final simplePattern = RegExp(
      r'(<key>CFBundleURLSchemes</key>.*?<string>)[^<]+(</string>)',
      dotAll: true,
    );
    
    if (content.contains(simplePattern)) {
      content = content.replaceFirstMapped(simplePattern, (match) {
        return '${match.group(1)}$reversedId${match.group(2)}';
      });
      print('  ✓ Set reversed iOS Client ID: $reversedId');
    } else {
      print('  ⚠️  Could not find CFBundleURLSchemes pattern - may need manual update');
    }
  }
  
  await file.writeAsString(content);
}

Future<void> updateAndroidManifest(String projectRoot) async {
  final manifestPath = path.join(
    projectRoot,
    'android',
    'app',
    'src',
    'main',
    'AndroidManifest.xml',
  );
  final file = File(manifestPath);
  
  if (!await file.exists()) {
    throw Exception('AndroidManifest.xml not found at: $manifestPath');
  }
  
  print('📝 Updating Android Manifest...');
  
  var content = await file.readAsString();
  
  // Replace the Supabase host
  final supabaseHost = Uri.parse(EnvConfig.supabaseUrl).host;
  
  final pattern = RegExp(
    r'(android:host=")[^"]+(").*?android:scheme="https"',
    dotAll: true,
  );
  
  if (content.contains(pattern)) {
    content = content.replaceFirstMapped(pattern, (match) {
      return '${match.group(1)}$supabaseHost${match.group(2)}" />\n            </intent-filter>';
    });
    print('  ✓ Set Supabase host: $supabaseHost');
  } else {
    // Try alternative pattern
    final altPattern = RegExp(r'(android:host=")[^"]+(")', multiLine: true);
    
    if (content.contains(altPattern)) {
      content = content.replaceFirst(altPattern, '\$1$supabaseHost\$2');
      print('  ✓ Set Supabase host: $supabaseHost');
    } else {
      print('  ⚠️  Could not find android:host pattern - may need manual update');
    }
  }
  
  await file.writeAsString(content);
}

Future<void> updateAndroidBuildGradle(String projectRoot) async {
  final buildGradlePath = path.join(
    projectRoot,
    'android',
    'app',
    'build.gradle',
  );
  final file = File(buildGradlePath);
  
  if (!await file.exists()) {
    throw Exception('build.gradle not found at: $buildGradlePath');
  }
  
  print('📝 Updating Android build.gradle...');
  
  var content = await file.readAsString();
  
  // Replace namespace
  final namespacePattern = RegExp(r'(namespace\s*=\s*")[^"]+(")', multiLine: true);
  
  if (content.contains(namespacePattern)) {
    content = content.replaceFirst(
      namespacePattern,
      '\$1${EnvConfig.androidPackageName}\$2',
    );
    print('  ✓ Set namespace: ${EnvConfig.androidPackageName}');
  }
  
  // Replace applicationId
  final appIdPattern = RegExp(r'(applicationId\s*=\s*")[^"]+(")', multiLine: true);
  
  if (content.contains(appIdPattern)) {
    content = content.replaceFirst(
      appIdPattern,
      '\$1${EnvConfig.androidPackageName}\$2',
    );
    print('  ✓ Set applicationId: ${EnvConfig.androidPackageName}');
  }
  
  await file.writeAsString(content);
}

Future<void> updateIosProjectFile(String projectRoot) async {
  final projectPath = path.join(
    projectRoot,
    'ios',
    'Runner.xcodeproj',
    'project.pbxproj',
  );
  final file = File(projectPath);
  
  if (!await file.exists()) {
    throw Exception('project.pbxproj not found at: $projectPath');
  }
  
  print('📝 Updating iOS project.pbxproj...');
  
  var content = await file.readAsString();
  
  // Replace all instances of PRODUCT_BUNDLE_IDENTIFIER
  final bundleIdPattern = RegExp(
    r'(PRODUCT_BUNDLE_IDENTIFIER\s*=\s*)[^;]+;',
    multiLine: true,
  );
  
  int replacements = 0;
  content = content.replaceAllMapped(bundleIdPattern, (match) {
    replacements++;
    return '${match.group(1)}${EnvConfig.iosBundleId};';
  });
  
  if (replacements > 0) {
    print('  ✓ Set bundle identifier: ${EnvConfig.iosBundleId} ($replacements occurrences)');
  } else {
    print('  ⚠️  Could not find PRODUCT_BUNDLE_IDENTIFIER pattern - may need manual update');
  }
  
  await file.writeAsString(content);
}
