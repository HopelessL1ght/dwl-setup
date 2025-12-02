#!/bin/bash

# ====================================================================
# Arch Linux Wayland Setup Script
#
# This script installs essential development tools, the core components
# for a wlroots-based Wayland environment, and a selection of
# utilities and applications requested by the user.
#
# NOTE: This script uses 'sudo' and '--noconfirm'. Review the package
# list before running it.
# ====================================================================

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting package installation for Arch Linux..."

# Define repository directory path
DWL_DIR="$HOME/dwl-setup"

# --- 1. Install base-devel (Essential Build/Dev Tools) ---
# This group includes tools like make, gcc, pkg-config, etc., which are often
# required for compiling packages from the AUR or building from source.
echo "1/12: Installing 'base-devel' group..."
sudo pacman -S --needed --noconfirm base-devel

# --- 2. Define all remaining packages ---
# Grouped for readability based on the request.
CORE_PACKAGES=(
    # Development / Configuration tools (already partly in base-devel, but explicit for clarity)
    "git"
    "pkgconf" 

    # Wayland Core Components & wlroots Dependencies
    "libinput"
    "wayland"
    "libxkbcommon"
    "wayland-protocols"
    "libxcb"
    "xcb-util-wm"
    "xorg-xwayland"

    # Wayland Utilities (Screenshots, Menu, Bar)
    "grim"      # Screenshot tool
    "slurp"     # Region selection tool
    "swappy"    # Screenshot editor/clipper
    "wofi"      # Application launcher/menu
    "waybar"    # Status bar

    # System Utilities
    "ly"            # Display Manager (for starting the Wayland session)
    "pavucontrol"   # PulseAudio/PipeWire volume control GUI
    "nemo"          # File manager (often used with Wayland/Sway)
    "lxappearance"  # GTK theme configuration
    "networkmanager" # Network management daemon
    "blueman"       # Bluetooth manager (GUI for bluez)

    # Applications
    "prismlauncher" # Re-added as requested
    "steam"
    "discord"
    "obs-studio"    # OBS (usually listed as obs-studio in Arch)
    "vlc"
    "vim"           # Editor
    "alacritty"     # GPU-accelerated terminal emulator
)

# --- 3. Install all remaining packages ---
echo "2/12: Installing remaining packages (${#CORE_PACKAGES[@]} total)..."
# Use 'pacman -S' with '--needed' to only install what is missing.
sudo pacman -S --needed --noconfirm "${CORE_PACKAGES[@]}"

echo "3/12: Package installation complete!"

# --- Start post-installation configuration steps ---
echo ""
echo "--- Starting configuration and dotfile setup ---"
sleep 1 # Pause briefly for visual clarity

# --- 4. Clone dwl-setup repository ---
echo "4/12: Cloning dwl-setup repository into $DWL_DIR..."
git clone https://github.com/HopelessL1ght/dwl-setup.git "$DWL_DIR"

# --- 5. Compile and Install dwl ---
echo "5/12: Compiling and installing the dwl compositor into $HOME/.local/bin..."
if [ -d "$DWL_DIR" ]; then
    (
        cd "$DWL_DIR"
        # Compile and install (assuming the Makefile is configured for user-local installation)
        echo "Running: make clean install"
        sudo make clean install || { echo "WARNING: dwl compilation/installation failed. Check dependencies and the Makefile in $DWL_DIR."; }
    )
else
    echo "WARNING: dwl-setup directory not found. Skipping compilation/installation."
fi

# --- 6. Install utility binaries from repository ---
BIN_DIR="$HOME/.local/bin"
echo "6/12: Copying utility executables from dwl-setup/bin to $BIN_DIR and setting executable permissions..."
# Create the target directory if it doesn't exist
mkdir -p "$BIN_DIR"
# Copy all contents from the bin folder of the cloned repository (the '.' copies content, not the 'bin' folder itself)
# This assumes the bin directory exists in the repository.
cp -r "$DWL_DIR/bin/." "$BIN_DIR/"
# Ensure all copied files are executable
chmod +x "$BIN_DIR"/* 2>/dev/null || true
echo "  -> Binary files copied and made executable."

# --- 7. Copy repository bashrc to user config ---
REPO_BASHRC="$DWL_DIR/bashrc"
USER_BASHRC="$HOME/.bashrc"
echo "7/12: Copying $REPO_BASHRC to $USER_BASHRC..."
if [ -f "$REPO_BASHRC" ]; then
    cp "$REPO_BASHRC" "$USER_BASHRC"
    echo "  -> Successfully copied the repository's bashrc, overwriting the existing file."
else
    echo "WARNING: $REPO_BASHRC not found in the cloned repository. Skipping bashrc copy."
fi

# --- 8. Copy Alacritty configuration files ---
ALACRITTY_SRC="$DWL_DIR/alacritty"
ALACRITTY_DST="$HOME/.config/alacritty"
echo "8/12: Copying Alacritty config from $ALACRITTY_SRC to $ALACRITTY_DST..."
if [ -d "$ALACRITTY_SRC" ]; then
    mkdir -p "$ALACRITTY_DST"
    cp -r "$ALACRITTY_SRC/." "$ALACRITTY_DST/"
    echo "  -> Successfully copied Alacritty configuration."
else
    echo "WARNING: $ALACRITTY_SRC not found in the cloned repository. Skipping Alacritty config copy."
fi

# --- 9. Copy Waybar configuration files ---
WAYBAR_SRC="$DWL_DIR/waybar"
WAYBAR_DST="$HOME/.config/waybar"
echo "9/12: Copying Waybar config from $WAYBAR_SRC to $WAYBAR_DST..."
if [ -d "$WAYBAR_SRC" ]; then
    mkdir -p "$WAYBAR_DST"
    cp -r "$WAYBAR_SRC/." "$WAYBAR_DST/"
    echo "  -> Successfully copied Waybar configuration."
else
    echo "WARNING: $WAYBAR_SRC not found in the cloned repository. Skipping Waybar config copy."
fi

# --- 10. Copy Wofi (Application Launcher) configuration files ---
# NOTE: The installed package is 'wofi' (Wayland), not 'rofi' (X11). 
# Assuming the configuration directory in the repository is 'wofi'.
WOFI_SRC="$DWL_DIR/wofi"
WOFI_DST="$HOME/.config/wofi"
echo "10/12: Copying Wofi (Launcher) config from $WOFI_SRC to $WOFI_DST..."
if [ -d "$WOFI_SRC" ]; then
    mkdir -p "$WOFI_DST"
    cp -r "$WOFI_SRC/." "$WOFI_DST/"
    echo "  -> Successfully copied Wofi configuration."
else
    echo "WARNING: $WOFI_SRC not found in the cloned repository. Skipping Wofi config copy."
fi

# --- 11. Add ~/.local/bin to PATH in shell configs ---
echo "11/12: Ensuring $HOME/.local/bin is in the PATH..."
PATH_EXPORT='export PATH="$HOME/.local/bin:$PATH"'
BASHRC="$HOME/.bashrc"
PROFILE="$HOME/.profile"

# Check and update .bashrc (This ensures the PATH is set even if the copied bashrc didn't include it)
if [ -f "$BASHRC" ] && ! grep -qF "$PATH_EXPORT" "$BASHRC" 2>/dev/null; then
    echo "" >> "$BASHRC"
    echo "# Add user local bin to PATH for executables installed in $HOME/.local/bin" >> "$BASHRC"
    echo "$PATH_EXPORT" >> "$BASHRC"
    echo "  -> Added PATH export to $BASHRC"
elif [ -f "$BASHRC" ]; then
    echo "  -> $BASHRC already contains the PATH modification. Skipping."
fi

# Check and update .profile
if [ -f "$PROFILE" ] && ! grep -qF "$PATH_EXPORT" "$PROFILE" 2>/dev/null; then
    echo "" >> "$PROFILE"
    echo "# Add user local bin to PATH for executables installed in $HOME/.local/bin" >> "$PROFILE"
    echo "$PATH_EXPORT" >> "$PROFILE"
    echo "  -> Added PATH export to $PROFILE"
elif [ -f "$PROFILE" ]; then
    echo "  -> $PROFILE already contains the PATH modification. Skipping."
fi


# --- 12. Create the user directory for wallpapers ---
echo "12/12: Creating the user directory for wallpapers: ~/Pictures/wallpapers"
# The -p flag ensures parent directories (like Pictures) are created if they don't exist.
mkdir -p "$HOME/Pictures/wallpapers"

echo "--------------------------------------------------------"
echo "Next Steps:"
echo "1. IMPORTANT: The PATH variable was added to ~/.bashrc and ~/.profile. You must run 'source ~/.bashrc' (or open a new terminal) for it to take effect in your current session."
echo "2. The dwl compositor and its utilities are now installed in $HOME/.local/bin. You may still need to copy other configuration files (dotfiles) from $HOME/dwl-setup/ to your home directory."
echo "3. Enable essential system services (if not already):"
echo "   sudo systemctl enable NetworkManager"
echo "   sudo systemctl start NetworkManager"
echo "   sudo systemctl enable ly    # Enable the ly Display Manager"
echo "   sudo systemctl start ly     # Start ly immediately"
echo "   sudo systemctl enable bluetooth (if needed)"
echo "4. Log out and select your new Wayland session, or reboot to see the ly login screen."
echo "--------------------------------------------------------"