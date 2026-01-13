#!/bin/bash
set -e

# ========= CONFIG =========
PROJECT_ID="supabase-auth-$(date +%s)"
PROJECT_NAME="Supabase Auth Project"
REGION="us"

SUPABASE_URL="https://YOUR_PROJECT.supabase.co"
REDIRECT_PATH="/auth/v1/callback"

WEB_REDIRECT="$SUPABASE_URL$REDIRECT_PATH"
ANDROID_PACKAGE="com.example.app"
IOS_BUNDLE="com.example.app"

# ==========================

echo "🚀 Creating Google Cloud project..."

gcloud projects create $PROJECT_ID --name="$PROJECT_NAME"
gcloud config set project $PROJECT_ID

echo "💳 Linking billing account (required)"
BILLING_ID=$(gcloud billing accounts list --format="value(name)" | head -n 1)
gcloud billing projects link $PROJECT_ID --billing-account=$BILLING_ID

echo "🔌 Enabling APIs..."
gcloud services enable \
  iam.googleapis.com \
  cloudresourcemanager.googleapis.com \
  oauth2.googleapis.com

echo "🧾 Creating OAuth consent screen..."

cat > consent.json <<EOF
{
  "applicationTitle": "Supabase Auth",
  "supportEmail": "support@example.com",
  "authorizedDomains": [],
  "scopes": ["https://www.googleapis.com/auth/userinfo.email","https://www.googleapis.com/auth/userinfo.profile"],
  "testUsers": []
}
EOF

gcloud alpha iap oauth-brands create \
  --application_title="Supabase Auth" \
  --support_email="support@example.com"

BRAND_ID=$(gcloud alpha iap oauth-brands list --format="value(name)")

echo "🌐 Creating WEB OAuth client..."

WEB_CLIENT=$(gcloud alpha iap oauth-clients create \
  --brand=$BRAND_ID \
  --display_name="Supabase Web Client" \
  --format=json)

WEB_CLIENT_ID=$(echo $WEB_CLIENT | jq -r '.name')
WEB_SECRET=$(echo $WEB_CLIENT | jq -r '.secret')

echo "🤖 Creating ANDROID OAuth client..."

ANDROID_CLIENT=$(gcloud alpha iap oauth-clients create \
  --brand=$BRAND_ID \
  --display_name="Supabase Android Client" \
  --format=json)

ANDROID_CLIENT_ID=$(echo $ANDROID_CLIENT | jq -r '.name')

echo "🍎 Creating IOS OAuth client..."

IOS_CLIENT=$(gcloud alpha iap oauth-clients create \
  --brand=$BRAND_ID \
  --display_name="Supabase iOS Client" \
  --format=json)

IOS_CLIENT_ID=$(echo $IOS_CLIENT | jq -r '.name')

echo ""
echo "================ RESULTS ================"
echo "Project ID: $PROJECT_ID"
echo ""
echo "WEB CLIENT ID:     $WEB_CLIENT_ID"
echo "WEB CLIENT SECRET: $WEB_SECRET"
echo ""
echo "ANDROID CLIENT ID: $ANDROID_CLIENT_ID"
echo ""
echo "IOS CLIENT ID:     $IOS_CLIENT_ID"
echo ""
echo "Supabase Redirect URL:"
echo "$WEB_REDIRECT"
echo "========================================"

rm consent.json
