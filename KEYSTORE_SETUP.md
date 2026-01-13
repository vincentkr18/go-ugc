# Android Keystore Setup Commands

## Generate Keystore
```bash
cd android
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
# Enter password: android123 (use same for store and key password)
# Fill in details: CN=Go UGC, OU=Development, O=Go UGC, L=City, ST=State, C=US
```

## Get SHA-1 Fingerprint (for Google OAuth)
```bash
keytool -list -v -keystore upload-keystore.jks -alias upload -storepass android123 -keypass android123
# Copy the SHA1 fingerprint from output
```

## Get Application ID
```powershell
Select-String -Path "app\build.gradle" -Pattern "applicationId" | Select-Object -First 1
# Extract the application ID from the output
```

## Get Base64 Keystore (for CI/CD)
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$PWD\upload-keystore.jks")) | clip
# Base64 string copied to clipboard
```

## GitHub Secrets to Configure
Navigate to: **Settings → Secrets and variables → Actions → New repository secret**

1. **ANDROID_KEYSTORE_BASE64** = Paste base64 from clipboard
2. **ANDROID_KEYSTORE_PASSWORD** = `android123`
3. **ANDROID_KEY_PASSWORD** = `android123`
4. **ANDROID_KEY_ALIAS** = `upload`

## Keystore Details
- **File**: `android/upload-keystore.jks`
- **Alias**: `upload`
- **Password**: `android123`
- **SHA-1**: `72:8A:57:E1:97:31:89:82:DF:22:97:68:82:4D:38:4E:1F:C8:44:9F`
