#!/bin/bash

# Universal Dotfiles Install Script
# Compatible with: Fedora, Arch, Ubuntu/Debian, openSUSE Tumbleweed, Void Linux, and more
# Author: ShinLevitra
# Description: Installs and configures dotfiles with required packages across multiple Linux distributions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_VERSION=$VERSION_ID
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        DISTRO=$DISTRIB_ID
        DISTRO_VERSION=$DISTRIB_RELEASE
    else
        log_error "Cannot detect Linux distribution"
        exit 1
    fi
    
    log_info "Detected distribution: $DISTRO $DISTRO_VERSION"
}

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        log_error "Please do not run this script as root"
        exit 1
    fi
}

# Install packages based on distribution
install_packages() {
    log_info "Installing required packages..."
    
    case $DISTRO in
        "fedora"|"nobara")
            # Fedora/Nobara packages
            PACKAGES="fish starship kitty hyprland waybar rofi swww grim slurp wl-clipboard \
                     brightnessctl playerctl pamixer pavucontrol networkmanager-applet \
                     polkit-gnome xdg-desktop-portal-hyprland qt5-qtwayland qt6-qtwayland \
                     hypridle hyprlock wallust wlogout cava jq curl git stow"
            
            sudo dnf install -y $PACKAGES
            
            # Install tide for fish (via fisher)
            if ! command -v fisher &> /dev/null; then
                log_info "Installing fisher for fish..."
                fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
            fi
            ;;
            
        "arch"|"manjaro"|"endeavouros")
            # Arch-based packages
            PACKAGES="fish starship kitty hyprland waybar rofi swww grim slurp wl-clipboard \
                     brightnessctl playerctl pamixer pavucontrol network-manager-applet \
                     polkit-gnome xdg-desktop-portal-hyprland qt5-wayland qt6-wayland \
                     hypridle hyprlock wlogout cava jq curl git stow"
            
            # Check if we have paru, yay, or use pacman
            if command -v paru &> /dev/null; then
                paru -S --noconfirm $PACKAGES wallust
            elif command -v yay &> /dev/null; then
                yay -S --noconfirm $PACKAGES wallust
            else
                sudo pacman -S --noconfirm $PACKAGES
                log_warning "wallust not available in official repos, please install manually"
            fi
            
            # Install tide for fish
            if ! command -v fisher &> /dev/null; then
                log_info "Installing fisher for fish..."
                fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
            fi
            ;;
            
        "ubuntu"|"debian"|"pop"|"zorin"|"elementary")
            # Ubuntu/Debian-based packages
            sudo apt update
            
            # Basic packages available in repos
            BASIC_PACKAGES="fish kitty rofi grim slurp wl-clipboard brightnessctl \
                           playerctl pavucontrol network-manager-gnome \
                           polkit-gnome-authentication-agent-1 jq curl git stow"
            
            sudo apt install -y $BASIC_PACKAGES
            
            # Install starship
            if ! command -v starship &> /dev/null; then
                log_info "Installing starship..."
                curl -sS https://starship.rs/install.sh | sh -s -- -y
            fi
            
            # Install hyprland and related (may need PPA or manual install)
            log_warning "Hyprland and related packages may need manual installation on Ubuntu/Debian"
            log_info "Consider using the official Hyprland installation guide for your version"
            
            # Install tide for fish
            if ! command -v fisher &> /dev/null; then
                log_info "Installing fisher for fish..."
                fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
            fi
            ;;
            
        "opensuse-tumbleweed"|"opensuse")
            # openSUSE Tumbleweed packages
            PACKAGES="fish starship kitty rofi grim slurp wl-clipboard brightnessctl \
                     playerctl pavucontrol NetworkManager-applet polkit-gnome \
                     xdg-desktop-portal-hyprland qt5-qtwayland qt6-qtwayland \
                     wlogout cava jq curl git stow"
            
            sudo zypper install -y $PACKAGES
            
            # Hyprland might be in a different repo or need manual install
            if ! zypper search hyprland &> /dev/null; then
                log_warning "Hyprland may need manual installation on openSUSE"
                log_info "Consider adding the appropriate repository or building from source"
            else
                sudo zypper install -y hyprland waybar swww hypridle hyprlock wallust
            fi
            
            # Install tide for fish
            if ! command -v fisher &> /dev/null; then
                log_info "Installing fisher for fish..."
                fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
            fi
            ;;
            
        "void")
            # Void Linux packages
            PACKAGES="fish starship kitty rofi grim slurp wl-clipboard brightnessctl \
                     playerctl pamixer pavucontrol NetworkManager polkit-gnome \
                     jq curl git stow"
            
            sudo xbps-install -S $PACKAGES
            
            # Some packages might not be available in void repos
            log_warning "Some packages like hyprland, waybar might need manual installation on Void Linux"
            log_info "Check void-packages or consider using flatpak alternatives"
            
            # Install tide for fish
            if ! command -v fisher &> /dev/null; then
                log_info "Installing fisher for fish..."
                fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
            fi
            ;;
            
        *)
            log_error "Unsupported distribution: $DISTRO"
            log_info "Supported distributions: Fedora, Arch, Ubuntu/Debian, openSUSE Tumbleweed, Void Linux"
            log_info "You may need to manually install the required packages"
            exit 1
            ;;
    esac
    
    log_success "Package installation completed"
}

# Install fisher plugins for fish
install_fish_plugins() {
    log_info "Installing fish plugins..."
    
    # Change to fish shell temporarily and install plugins
    fish -c "
        if not functions -q fisher
            curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
            fisher install jorgebucaran/fisher
        end
        
        fisher install IlanCosman/tide@v6
        fisher install jorgebucaran/nvm.fish
        fisher install PatrickF1/fzf.fish
    "
    
    log_success "Fish plugins installed"
}

# Backup existing configs
backup_configs() {
    log_info "Backing up existing configurations..."
    
    BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    configs_to_backup=("fish" "kitty" "hypr" "waybar" "rofi" "starship.toml")
    
    for config in "${configs_to_backup[@]}"; do
        if [ -e "$HOME/.config/$config" ]; then
            log_info "Backing up $config..."
            cp -r "$HOME/.config/$config" "$BACKUP_DIR/"
        fi
    done
    
    log_success "Backup created at: $BACKUP_DIR"
}

# Install dotfiles using stow
install_dotfiles() {
    log_info "Installing dotfiles..."
    
    # Create necessary directories
    mkdir -p "$HOME/.config"
    
    # Copy configs to proper locations
    for config_dir in config/*/; do
        config_name=$(basename "$config_dir")
        log_info "Installing $config_name configuration..."
        
        # Remove existing config if it exists
        if [ -e "$HOME/.config/$config_name" ]; then
            rm -rf "$HOME/.config/$config_name"
        fi
        
        # Copy new config
        cp -r "$config_dir" "$HOME/.config/"
    done
    
    # Handle starship.toml separately
    if [ -f "config/starship.toml" ]; then
        log_info "Installing starship configuration..."
        cp "config/starship.toml" "$HOME/.config/"
    fi
    
    log_success "Dotfiles installed successfully"
}

# Set fish as default shell
set_fish_shell() {
    if [ "$SHELL" != "$(which fish)" ]; then
        log_info "Setting fish as default shell..."
        
        # Add fish to shells if not already there
        if ! grep -q "$(which fish)" /etc/shells; then
            echo "$(which fish)" | sudo tee -a /etc/shells
        fi
        
        # Change default shell
        sudo chsh -s "$(which fish)" "$USER"
        
        log_success "Fish set as default shell (restart terminal or re-login to take effect)"
    else
        log_info "Fish is already the default shell"
    fi
}

# Configure tide prompt
configure_tide() {
    log_info "Configuring tide prompt..."
    
    fish -c "
        tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Compact --icons='Many icons' --transient=No
    "
    
    log_success "Tide prompt configured"
}

# Post-installation setup
post_install_setup() {
    log_info "Running post-installation setup..."
    
    # Make scripts executable
    find config/hypr/scripts/ -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    find config/hypr/UserScripts/ -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    
    # Create necessary directories
    mkdir -p "$HOME/Pictures/Screenshots"
    mkdir -p "$HOME/Pictures/Wallpapers"
    
    log_success "Post-installation setup completed"
}

# Main installation function
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║                                                        ║"
    echo "║         ShinLevitra's Universal Dotfiles Installer    ║"
    echo "║                                                        ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log_info "Starting dotfiles installation..."
    
    check_root
    detect_distro
    
    echo
    echo -e "${YELLOW}This script will:${NC}"
    echo "  • Install required packages for your distribution"
    echo "  • Backup your existing configurations"
    echo "  • Install dotfiles (Fish, Kitty, Hyprland, Waybar, Rofi)"
    echo "  • Configure fish shell with tide prompt"
    echo "  • Set fish as your default shell"
    echo
    
    read -p "Do you want to continue? [Y/n]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ ! -z $REPLY ]]; then
        log_info "Installation cancelled"
        exit 0
    fi
    
    echo
    log_info "Starting installation process..."
    
    install_packages
    echo
    
    backup_configs
    echo
    
    install_dotfiles
    echo
    
    install_fish_plugins
    echo
    
    set_fish_shell
    echo
    
    configure_tide
    echo
    
    post_install_setup
    echo
    
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║                                                        ║"
    echo "║              Installation Completed!                  ║"
    echo "║                                                        ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log_success "Dotfiles installation completed successfully!"
    echo
    log_info "Next steps:"
    echo "  1. Restart your terminal or run 'exec fish' to use fish shell"
    echo "  2. Log out and back in to ensure all changes take effect"
    echo "  3. Configure your monitor settings in ~/.config/hypr/monitors.conf"
    echo "  4. Customize your waybar and other settings as needed"
    echo
    log_info "Backup of your original configs: $BACKUP_DIR"
    echo
    log_info "Enjoy your new setup! 🎉"
}

# Run main function
main "$@"
