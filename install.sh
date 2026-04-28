#!/bin/bash

# ==============================================================================
# Custom Minimal Hyprland Environment Setup Script for Fedora
# ==============================================================================

echo "Updating system..."
sudo dnf upgrade -y

# 1. Add RPM Fusion Repositories
echo "Adding RPM Fusion (Free and Non-Free)..."
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# 2. Enable Copr Repositories
echo "Enabling third-party Copr repositories..."
sudo dnf copr enable -y lionheartp/Hyprland
sudo dnf copr enable -y scottames/ghostty
sudo dnf copr enable -y lihaohong/yazi

# 3. Install Core Packages & Dependencies
echo "Installing core packages..."
sudo dnf install -y \
    hyprland \
    ghostty \
    neovim \
    hyprpaper \
    waybar \
    wlogout \
    rofi-wayland \
    hyprpolkitagent \
    yazi \
    tar \
    unzip \
    7zip \
    inotify-tools \
    ImageMagick \
    flameshot \
    ibm-plex-sans-fonts \
    zsh \
    zsh-syntax-highlighting \
    git \
    curl \
    wget \
    util-linux-user \
    slurp \
    grim \
    wl-clipboard \
    btop \
    fzf

# 4. Install Brave Browser (Nightly)
echo "Installing Brave Nightly..."
curl -fsS https://dl.brave.com/install.sh | CHANNEL=nightly sudo sh

# 5. Install Meslo LG Nerd Font
echo "Installing Meslo LG Nerd Font..."
mkdir -p "$HOME/.local/share/fonts/Meslo"
wget -qO /tmp/Meslo.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
unzip -q /tmp/Meslo.zip -d "$HOME/.local/share/fonts/Meslo/"
rm /tmp/Meslo.zip
fc-cache -fv

# 6. Zsh & Oh My Zsh Setup
echo "Setting up Zsh and Oh My Zsh..."

# Change default shell to Zsh for the current user
sudo chsh -s $(which zsh) $USER

# Install Oh My Zsh (The --unattended flag is required so it doesn't pause the script)
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 7. Zsh Themes and Plugins
echo "Installing Powerlevel10k and Zsh plugins..."

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Install Zsh Autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Apply theme and plugins to .zshrc
echo "Configuring .zshrc..."

# Change default theme to powerlevel10k
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' "$HOME/.zshrc"

# Add autosuggestions to the plugins list
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions)/g' "$HOME/.zshrc"

# Add syntax highlighting source to the end of .zshrc
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

echo "=============================================================================="
echo "Installation Complete!"
echo "Please reboot your system for all changes to take effect."
echo "=============================================================================="
