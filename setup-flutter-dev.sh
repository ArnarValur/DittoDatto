#!/usr/bin/env bash
# PlutoII Flutter Dev Setup — DittoDatto
# Run: chmod +x setup-flutter-dev.sh && ./setup-flutter-dev.sh
set -euo pipefail

echo "🔧 Step 1/4: System packages (JDK 21, Linux desktop toolchain, mesa-utils)"
sudo apt install -y openjdk-21-jdk clang cmake ninja-build mesa-utils

echo ""
echo "🔧 Step 2/4: Android cmdline-tools"
ANDROID_HOME="$HOME/Android/Sdk"
CMDLINE_TOOLS_DIR="$ANDROID_HOME/cmdline-tools"
if [ ! -d "$CMDLINE_TOOLS_DIR/latest" ]; then
    echo "  Downloading cmdline-tools..."
    TMPDIR=$(mktemp -d)
    curl -fsSL "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" -o "$TMPDIR/cmdline-tools.zip"
    unzip -q "$TMPDIR/cmdline-tools.zip" -d "$TMPDIR"
    mkdir -p "$CMDLINE_TOOLS_DIR"
    mv "$TMPDIR/cmdline-tools" "$CMDLINE_TOOLS_DIR/latest"
    rm -rf "$TMPDIR"
    echo "  ✅ cmdline-tools installed"
else
    echo "  ✅ cmdline-tools already present"
fi

echo ""
echo "🔧 Step 3/4: Wiring PATH in ~/.zshrc"
MARKER="# ─── Flutter & Android (DittoDatto dev) ───"
if grep -qF "$MARKER" "$HOME/.zshrc"; then
    echo "  ✅ PATH block already present in .zshrc"
else
    cat >> "$HOME/.zshrc" << 'EOF'

# ─── Flutter & Android (DittoDatto dev) ───
export ANDROID_HOME="$HOME/Android/Sdk"
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export PATH="$HOME/Flutter/flutter/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$JAVA_HOME/bin:$PATH"
EOF
    echo "  ✅ PATH block added to .zshrc"
fi

echo ""
echo "🔧 Step 4/4: Accepting Android licenses"
export ANDROID_HOME="$HOME/Android/Sdk"
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export PATH="$HOME/Flutter/flutter/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$JAVA_HOME/bin:$PATH"
yes | flutter doctor --android-licenses 2>/dev/null || true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Done. Open a new terminal, then run:"
echo ""
echo "   flutter doctor -v"
echo ""
echo "Expected: Flutter ✓, Android toolchain ✓, Linux toolchain ✓"
echo "Chrome will still show ✗ — optional for now."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
