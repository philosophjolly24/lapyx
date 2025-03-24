#!/bin/sh
# Clone Flutter if not already available
rm -rf flutter
git clone https://github.com/flutter/flutter.git

# Update PATH for this shell session
export PATH="$PATH:$(pwd)/flutter/bin"

# Optionally, check Flutter version to verify PATH is set correctly
flutter --version

# Run Flutter commands
flutter doctor
flutter clean
flutter config --enable-web
flutter build web --release --dart-define=FLUTTER_WEB_USE_WASM=true
