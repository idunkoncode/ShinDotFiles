#!/bin/bash

# Dotfiles installation script
# This script creates symlinks from your home directory to dotfiles repository

set -e

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo "🔧 Installing dotfiles..."

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -L "$target" ]; then
        echo "✅ Symlink already exists: $target"
        return
    fi
    
    if [ -f "$target" ] || [ -d "$target" ]; then
        echo "📦 Backing up existing: $target"
        mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    echo "🔗 Creating symlink: $target -> $source"
    ln -sf "$source" "$target"
}

# Symlink fish config
create_symlink "$DOTFILES_DIR/config/fish/config.fish" "$CONFIG_DIR/fish/config.fish"

# Symlink starship config
create_symlink "$DOTFILES_DIR/config/starship/starship.toml" "$CONFIG_DIR/starship.toml"

echo "✨ Dotfiles installation complete!"
echo "🔄 You may need to restart your shell or run 'source ~/.config/fish/config.fish'"
