
#!/usr/bin/env bash
set -e

# SwayShell installer
# Arch Linux only

cd "$(dirname "$0")"

echo "================================"
echo "          SWAYSHELL"
echo "================================"
echo
echo "WARNING: Existing configurations WILL be overwritten!"
echo
echo "Affected directories:"
echo "  ~/.config/sway"
echo "  ~/.config/waybar"
echo "  ~/.config/alacritty"
echo "  ~/.config/fuzzel"
echo "  ~/.config/swaylock"
echo "  ~/.config/swayshell"
echo
read -rp 'Type YES to continue: ' answer

if [[ "$answer" != "YES" ]]; then
    echo "Installation cancelled."
    exit 1
fi

echo
if ! command -v yay >/dev/null 2>&1 && ! command -v paru >/dev/null 2>&1; then
    echo "ERROR: SwayShell requires yay or paru."
    echo "Install an AUR helper before continuing."
    exit 1
fi
echo "[1/3] Installing official packages..."

sudo pacman -S --needed \
    waybar \
    alacritty \
    fuzzel \
    swaylock \
    swaybg \
    brightnessctl \
    playerctl \
    libpulse

echo
echo "[2/3] Installing AUR packages..."

if command -v yay >/dev/null 2>&1; then
    yay -S --needed swayfx snypr-bin
elif command -v paru >/dev/null 2>&1; then
    paru -S --needed swayfx snypr-bin
else
    echo "ERROR: Install yay or paru first."
    exit 1
fi

echo
echo "[3/3] Installing configurations..."

mkdir -p "$HOME/.config"

backup="$HOME/.config/swayshell-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup"

for dir in sway waybar alacritty fuzzel swaylock swayshell; do
    if [ -d "$HOME/.config/$dir" ]; then
        cp -r "$HOME/.config/$dir" "$backup/"
    fi
done

for dir in sway waybar alacritty fuzzel swaylock; do
    rm -rf "$HOME/.config/$dir"
done

cp -r configs/sway "$HOME/.config/"
cp -r configs/waybar "$HOME/.config/"
cp -r configs/alacritty "$HOME/.config/"
cp -r configs/fuzzel "$HOME/.config/"
cp -r configs/swaylock "$HOME/.config/"

mkdir -p "$HOME/.config/swayshell"

cp assets/wallpaper.jpg "$HOME/.config/swayshell/wallpaper.jpg"

sed -i "s|@SWAYSHELL_WALLPAPER@|$HOME/.config/swayshell/wallpaper.jpg|g" \
    "$HOME/.config/swaylock/config"

echo
echo "================================"
echo "       SWAYSHELL INSTALLED!"
echo "================================"
echo "Log out and select SwayFX."
