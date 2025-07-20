#!/bin/bash

# Automated Dotfiles Setup Script for Fedora Linux
# This script installs all required packages and sets up the complete environment

set -e

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

# Check if running on Fedora
check_system() {
    if [[ ! -f /etc/fedora-release ]]; then
        error "This script is designed for Fedora Linux. Please adapt for your distribution."
    fi
    log "Detected Fedora Linux - proceeding with setup"
}

# Update system packages
update_system() {
    log "Updating system packages..."
    sudo dnf update -y || warning "System update failed, continuing anyway"
    success "System packages updated"
}

# Install essential packages
install_packages() {
    log "Installing essential packages..."
    
    # Core development tools
    local packages=(
        "git"
        "curl"
        "wget"
        "fish"
        "neovim"
        "kitty"
        "starship"
        "eza"
        "rofi"
        "waybar"
        "wl-clipboard"
        "xclip"
        "openssh-clients"
        "dnf-plugins-core"
    )
    
    # Hyprland and Wayland packages
    local hyprland_packages=(
        "hyprland"
        "hyprpaper"
        "hypridle"
        "hyprlock"
        "xdg-desktop-portal-hyprland"
        "xdg-desktop-portal-gtk"
    )
    
    # Development tools
    local dev_packages=(
        "rust"
        "cargo"
        "nodejs"
        "npm"
        "python3"
        "python3-pip"
        "gcc"
        "g++"
        "make"
        "cmake"
    )
    
    # Install packages in batches
    log "Installing core packages..."
    sudo dnf install -y "${packages[@]}" || warning "Some core packages failed to install"
    
    log "Installing Hyprland and Wayland packages..."
    sudo dnf install -y "${hyprland_packages[@]}" || warning "Some Hyprland packages failed to install"
    
    log "Installing development tools..."
    sudo dnf install -y "${dev_packages[@]}" || warning "Some development packages failed to install"
    
    success "Package installation completed"
}

# Install .NET SDK
install_dotnet() {
    log "Installing .NET SDK..."
    
    # Add Microsoft repository
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo wget -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/$(rpm -E %fedora)/prod.repo
    
    # Install .NET SDK
    sudo dnf install -y dotnet-sdk-8.0 || warning ".NET SDK installation failed"
    success ".NET SDK installed"
}

# Install Rust and Cargo tools
setup_rust() {
    log "Setting up Rust environment..."
    
    # Install rustup if not already installed
    if ! command -v rustup &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source ~/.cargo/env
    fi
    
    # Update Rust
    rustup update stable
    rustup default stable
    
    # Install useful Rust tools
    cargo install --quiet --locked \
        bat \
        fd-find \
        ripgrep \
        tokei \
        du-dust \
        bottom \
        gitui || warning "Some Rust tools failed to install"
    
    success "Rust environment configured"
}

# Configure Fish shell
setup_fish() {
    log "Setting up Fish shell..."
    
    # Set Fish as default shell
    if [[ "$SHELL" != *"fish"* ]]; then
        log "Setting Fish as default shell..."
        echo "$(which fish)" | sudo tee -a /etc/shells
        chsh -s "$(which fish)" || warning "Failed to set Fish as default shell"
    fi
    
    success "Fish shell configured"
}

# Install additional fonts
install_fonts() {
    log "Installing additional fonts..."
    
    # Create fonts directory
    mkdir -p ~/.local/share/fonts
    
    # Install Nerd Fonts (JetBrains Mono)
    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    local font_dir="/tmp/jetbrains-font"
    
    mkdir -p "$font_dir"
    wget -O "$font_dir/JetBrainsMono.zip" "$font_url" || warning "Font download failed"
    
    if [[ -f "$font_dir/JetBrainsMono.zip" ]]; then
        unzip -q "$font_dir/JetBrainsMono.zip" -d "$font_dir"
        cp "$font_dir"/*.ttf ~/.local/share/fonts/ 2>/dev/null || true
        fc-cache -fv ~/.local/share/fonts
        rm -rf "$font_dir"
        success "JetBrains Mono Nerd Font installed"
    fi
}

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ -L "$target" ]]; then
        log "Symlink already exists: $target"
        return
    fi
    
    if [[ -f "$target" ]] || [[ -d "$target" ]]; then
        local backup="$target.backup.$(date +%Y%m%d_%H%M%S)"
        log "Backing up existing: $target -> $backup"
        mv "$target" "$backup"
    fi
    
    mkdir -p "$(dirname "$target")"
    log "Creating symlink: $target -> $source"
    ln -sf "$source" "$target"
}

# Setup dotfiles symlinks
setup_dotfiles() {
    log "Setting up dotfiles symlinks..."
    
    # Create config directory if it doesn't exist
    mkdir -p "$CONFIG_DIR"
    
    # Fish configuration
    if [[ -f "$DOTFILES_DIR/config/fish/config.fish" ]]; then
        create_symlink "$DOTFILES_DIR/config/fish/config.fish" "$CONFIG_DIR/fish/config.fish"
    fi
    
    # Starship configuration
    if [[ -f "$DOTFILES_DIR/config/starship/starship.toml" ]]; then
        create_symlink "$DOTFILES_DIR/config/starship/starship.toml" "$CONFIG_DIR/starship.toml"
    fi
    
    # Hyprland configuration
    if [[ -d "$DOTFILES_DIR/config/hypr" ]]; then
        create_symlink "$DOTFILES_DIR/config/hypr" "$CONFIG_DIR/hypr"
    fi
    
    # Waybar configuration
    if [[ -d "$DOTFILES_DIR/config/waybar" ]]; then
        create_symlink "$DOTFILES_DIR/config/waybar" "$CONFIG_DIR/waybar"
    fi
    
    # Rofi configuration
    if [[ -d "$DOTFILES_DIR/config/rofi" ]]; then
        create_symlink "$DOTFILES_DIR/config/rofi" "$CONFIG_DIR/rofi"
    fi
    
    # Kitty configuration
    if [[ -d "$DOTFILES_DIR/config/kitty" ]]; then
        create_symlink "$DOTFILES_DIR/config/kitty" "$CONFIG_DIR/kitty"
    fi
    
    # Neovim configuration
    if [[ -d "$DOTFILES_DIR/config/nvim" ]]; then
        create_symlink "$DOTFILES_DIR/config/nvim" "$CONFIG_DIR/nvim"
    fi
    
    # Cargo configuration
    if [[ -d "$DOTFILES_DIR/config/cargo" ]]; then
        create_symlink "$DOTFILES_DIR/config/cargo" "$HOME/.cargo"
    fi
    
    success "Dotfiles symlinks created"
}

# Setup SSH
setup_ssh() {
    log "Setting up SSH configuration..."
    
    if [[ ! -d ~/.ssh ]]; then
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
    fi
    
    if [[ ! -f ~/.ssh/config ]]; then
        cat > ~/.ssh/config << 'EOF'
Host *
    AddKeysToAgent yes
    IdentitiesOnly yes

Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/Fedora
EOF
        chmod 600 ~/.ssh/config
        success "SSH config created"
    fi
}

# Main execution
main() {
    log "🚀 Starting automated dotfiles setup for Fedora Linux"
    echo
    
    # Check if we're in the dotfiles directory
    if [[ ! -f "$DOTFILES_DIR/setup.sh" ]]; then
        error "Please run this script from the dotfiles directory: cd ~/dotfiles && ./setup.sh"
    fi
    
    # System checks
    check_system
    
    # Ask for confirmation
    echo -e "${YELLOW}This script will:${NC}"
    echo "  • Update system packages"
    echo "  • Install development tools (Rust, .NET, Node.js)"
    echo "  • Install and configure Hyprland environment"
    echo "  • Set up Fish shell with custom configuration"
    echo "  • Install fonts and additional tools"
    echo "  • Create symlinks for all dotfiles"
    echo
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Setup cancelled by user"
        exit 0
    fi
    
    # Execute setup steps
    update_system
    install_packages
    install_dotnet
    setup_rust
    setup_fish
    install_fonts
    setup_dotfiles
    setup_ssh
    
    echo
    success "🎉 Dotfiles setup completed successfully!"
    echo
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Restart your terminal or run: source ~/.config/fish/config.fish"
    echo "  2. If using Hyprland, log out and select Hyprland from your display manager"
    echo "  3. Set up your SSH keys for GitHub if not already done"
    echo "  4. Consider running the auto-sync script: ./sync.sh --install"
    echo
    log "Setup completed! Enjoy your new environment! 🚀"
}

# Run main function
main "$@"
