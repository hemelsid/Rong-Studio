#!/usr/bin/env bash
# Build a signed Rong Studio APK.
#
#   ./tools/build.sh 1.3 4
#
# 1.3 = version name people see, 4 = version code (must go up by at least 1
# every release, or Android refuses to install it over the old app).
#
# Needs: java 17+, python3, npm (only to fetch apktool the first time).
# Signing key: set RONG_KEYSTORE (default ~/.rong/rong.keystore),
# RONG_KEY_ALIAS (default rong) and RONG_KEY_PASS. Always sign with the SAME
# key, otherwise phones will not update the installed app.
set -euo pipefail

VERSION_NAME="${1:?version name, e.g. 1.3}"
VERSION_CODE="${2:?version code, e.g. 4}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CACHE="$ROOT/.cache"
OUT="$ROOT/build"
KEYSTORE="${RONG_KEYSTORE:-$HOME/.rong/rong.keystore}"
ALIAS="${RONG_KEY_ALIAS:-rong}"
PASS="${RONG_KEY_PASS:?set RONG_KEY_PASS to the keystore password}"

[ -f "$KEYSTORE" ] || { echo "Signing key not found: $KEYSTORE"; exit 1; }
mkdir -p "$CACHE" "$OUT"

# apktool 2.9.3 + apksigner, bundled in this npm package
TOOLS="$CACHE/apktool-node/package/lib"
if [ ! -f "$TOOLS/apktool.jar" ]; then
  echo "Fetching apktool…"
  (cd "$CACHE" && npm pack @postar/apktool-node@0.3.4 >/dev/null && mkdir -p apktool-node \
     && tar xzf postar-apktool-node-0.3.4.tgz -C apktool-node)
fi

# version numbers
sed -i -E "s/android:versionCode=\"[0-9]+\"/android:versionCode=\"$VERSION_CODE\"/; s/android:versionName=\"[^\"]+\"/android:versionName=\"$VERSION_NAME\"/" "$ROOT/android/AndroidManifest.xml"
sed -i -E "s/^  versionCode: .*/  versionCode: $VERSION_CODE/; s/^  versionName: .*/  versionName: $VERSION_NAME/" "$ROOT/android/apktool.yml"

python3 "$ROOT/tools/make_index.py" "$ROOT/web/rong-studio.html" "$ROOT/android/assets/index.html"

rm -rf "$ROOT/android/build"
java -jar "$TOOLS/apktool.jar" b "$ROOT/android" -o "$OUT/unsigned.apk"
python3 "$ROOT/tools/zipalign.py" "$OUT/unsigned.apk" "$OUT/aligned.apk"

APK="$OUT/RongStudio-v$VERSION_NAME.apk"
rm -f "$APK"
java -jar "$TOOLS/apksigner.jar" sign --ks "$KEYSTORE" --ks-key-alias "$ALIAS" \
  --ks-pass "pass:$PASS" --key-pass "pass:$PASS" --min-sdk-version 23 \
  --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true \
  --out "$APK" "$OUT/aligned.apk"
java -jar "$TOOLS/apksigner.jar" verify --min-sdk-version 23 "$APK"
rm -f "$OUT/unsigned.apk" "$OUT/aligned.apk" "$APK.idsig"
echo "Built $APK"
