#!/bin/bash

set -e

REPO="OWNER/REPO"        # ← change this
KEYSTORE_NAME="upload-keystore.jks"
ALIAS="upload"
PASSWORD="android123"

echo "📦 Creating keystore..."

cd android

keytool -genkey -v \
  -keystore $KEYSTORE_NAME \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias $ALIAS \
  -storepass $PASSWORD \
  -keypass $PASSWORD \
  -dname "CN=Go UGC, OU=Development, O=Go UGC, L=City, ST=State, C=US"

echo "✅ Keystore created"

echo ""
echo "🔑 SHA-1 Fingerprint:"
SHA1=$(keytool -list -v \
  -keystore $KEYSTORE_NAME \
  -alias $ALIAS \
  -storepass $PASSWORD \
  -keypass $PASSWORD | grep SHA1 | awk '{print $2}')

echo "$SHA1"

echo ""
echo "🔐 Encoding keystore to Base64..."

BASE64=$(base64 $KEYSTORE_NAME | tr -d '\n')

echo "✅ Base64 created"

echo ""
echo "☁️ Uploading secrets to GitHub..."

echo "$BASE64" | gh secret set ANDROID_KEYSTORE_BASE64 --repo $REPO
gh secret set ANDROID_KEYSTORE_PASSWORD --body "$PASSWORD" --repo $REPO
gh secret set ANDROID_KEY_PASSWORD --body "$PASSWORD" --repo $REPO
gh secret set ANDROID_KEY_ALIAS --body "$ALIAS" --repo $REPO

echo ""
echo "🎉 DONE!"

echo "Repository: $REPO"
echo "SHA-1: $SHA1"

#chmod +x setup_android_keystore.sh
#./setup_android_keystore.sh