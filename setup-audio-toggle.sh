#!/bin/bash
# Creates the CAPS audio toggle app on a new Mac.
# Prerequisites: Audio MIDI Setup must already have devices named
#   "CAPS Multi-Output" and default speakers configured.

set -e

DEVICE_A="${1:-CAPS Multi-Output}"
DEVICE_B="${2:-MacBook Air Speakers}"
APP_DEST="$HOME/Applications/CAPS音频切换.app"

echo "=== CAPS 音频切换 Setup ==="

# 1. Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. switchaudio-osx
if ! command -v SwitchAudioSource &>/dev/null; then
    echo "Installing switchaudio-osx..."
    brew install switchaudio-osx
fi

SWITCH=$(command -v SwitchAudioSource)

# 3. Build AppleScript app
echo "Building app..."
mkdir -p "$HOME/Applications"

TMPSCRIPT=$(mktemp /tmp/caps-toggle-XXXX.applescript)
cat > "$TMPSCRIPT" <<APPLESCRIPT
set currentDevice to do shell script "$SWITCH -c"
if currentDevice is "$DEVICE_A" then
    do shell script "$SWITCH -s '$DEVICE_B'"
    display notification "已切换到 $DEVICE_B（普通模式）" with title "CAPS 音频切换"
else
    do shell script "$SWITCH -s '$DEVICE_A'"
    display notification "已切换到 $DEVICE_A（字幕模式）" with title "CAPS 音频切换"
end if
APPLESCRIPT

osacompile -o "$APP_DEST" "$TMPSCRIPT"
rm "$TMPSCRIPT"

echo "Done! App saved to: $APP_DEST"
echo "Drag it to the Dock from Finder → Home → Applications."
