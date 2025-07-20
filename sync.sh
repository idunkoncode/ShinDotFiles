#!/bin/bash

# Automated Dotfiles Sync Script
# This script checks for changes in the dotfiles repository and pushes them to GitHub every 15 minutes

set -e

DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="git@github.com:idunkoncode/ShinDotFiles.git"
SYNC_INTERVAL=900 # 15 minutes

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

# Function to sync current configs to dotfiles repo
sync_configs() {
    log "Syncing current configurations to dotfiles repository..."
    
    # Fish configuration
    if [[ -f "$HOME/.config/fish/config.fish" ]]; then
        cp "$HOME/.config/fish/config.fish" "$DOTFILES_DIR/config/fish/config.fish"
    fi
    
    # Starship configuration
    if [[ -f "$HOME/.config/starship.toml" ]]; then
        cp "$HOME/.config/starship.toml" "$DOTFILES_DIR/config/starship/starship.toml"
    fi
    
    # Hyprland configuration
    if [[ -d "$HOME/.config/hypr" ]]; then
        rsync -av --exclude='.git' "$HOME/.config/hypr/" "$DOTFILES_DIR/config/hypr/" 2>/dev/null || true
    fi
    
    # Waybar configuration  
    if [[ -d "$HOME/.config/waybar" ]]; then
        rsync -av --exclude='.git' "$HOME/.config/waybar/" "$DOTFILES_DIR/config/waybar/" 2>/dev/null || true
    fi
    
    # Rofi configuration
    if [[ -d "$HOME/.config/rofi" ]]; then
        rsync -av --exclude='.git' "$HOME/.config/rofi/" "$DOTFILES_DIR/config/rofi/" 2>/dev/null || true
    fi
    
    # Kitty configuration
    if [[ -d "$HOME/.config/kitty" ]]; then
        rsync -av --exclude='.git' "$HOME/.config/kitty/" "$DOTFILES_DIR/config/kitty/" 2>/dev/null || true
    fi
    
    # Neovim configuration
    if [[ -d "$HOME/.config/nvim" ]]; then
        rsync -av --exclude='.git' "$HOME/.config/nvim/" "$DOTFILES_DIR/config/nvim/" 2>/dev/null || true
    fi
    
    # Cargo configuration
    if [[ -d "$HOME/.cargo" ]] && [[ -d "$DOTFILES_DIR/config/cargo" ]]; then
        # Only sync config files, not the entire cargo directory
        [[ -f "$HOME/.cargo/config.toml" ]] && cp "$HOME/.cargo/config.toml" "$DOTFILES_DIR/config/cargo/config.toml" 2>/dev/null || true
        [[ -f "$HOME/.cargo/env" ]] && cp "$HOME/.cargo/env" "$DOTFILES_DIR/config/cargo/env" 2>/dev/null || true
        [[ -f "$HOME/.cargo/env.fish" ]] && cp "$HOME/.cargo/env.fish" "$DOTFILES_DIR/config/cargo/env.fish" 2>/dev/null || true
    fi
}

# Function to check for changes and commit them
sync_changes() {
    cd "$DOTFILES_DIR"
    
    # First sync the current configs
    sync_configs
    
    # Check if there are any changes to commit
    if [[ -n $(git status --porcelain) ]]; then
        log "Changes detected in dotfiles. Committing and pushing to GitHub..."
        git add .
        
        # Create a descriptive commit message
        local changed_files=$(git status --porcelain | wc -l)
        local commit_msg="Auto-sync: Updated $changed_files files on $(date +'%Y-%m-%d %H:%M:%S')"
        
        git commit -m "$commit_msg"
        
        # Attempt to push, handle potential conflicts
        if ! git push origin master 2>/dev/null; then
            warning "Push failed, attempting to pull and merge..."
            git pull --rebase origin master
            git push origin master
        fi
        
        success "Changes pushed to GitHub ($changed_files files updated)"
    else
        log "No changes detected in dotfiles"
    fi
}

# Install the cron job
install_cron() {
    log "Installing cron job for automatic sync every 15 minutes..."
    
    # Remove existing dotfiles sync cron jobs
    crontab -l 2>/dev/null | grep -v "dotfiles/sync.sh" | crontab -
    
    # Add new cron job
    (crontab -l 2>/dev/null; echo "*/15 * * * * cd $HOME/dotfiles && ./sync.sh --sync >> $HOME/dotfiles/sync.log 2>&1") | crontab -
    
    success "Cron job installed - dotfiles will auto-sync every 15 minutes"
    log "View logs with: tail -f ~/dotfiles/sync.log"
}

# Remove the cron job
uninstall_cron() {
    log "Removing dotfiles sync cron job..."
    crontab -l 2>/dev/null | grep -v "dotfiles/sync.sh" | crontab -
    success "Cron job removed"
}

# Show help
show_help() {
    cat << EOF
Dotfiles Sync Script

Usage: $0 [OPTION]

OPTIONS:
  --sync       Run one sync cycle and exit
  --install    Install cron job for automatic sync every 15 minutes
  --uninstall  Remove the cron job
  --daemon     Run in daemon mode (continuous sync)
  --help       Show this help message

EXAMPLES:
  $0 --sync          # Sync once and exit
  $0 --install       # Install automatic sync
  $0 --daemon        # Run continuously

LOG FILE:
  ~/dotfiles/sync.log

EOF
}

# Main execution
main() {
    case "$1" in
        --sync)
            log "🔄 Running one-time sync..."
            sync_changes
            exit 0
            ;;
        --install)
            install_cron
            exit 0
            ;;
        --uninstall)
            uninstall_cron
            exit 0
            ;;
        --daemon)
            log "🚀 Starting dotfiles sync daemon (every 15 minutes)"
            while true; do
                sync_changes
                sleep $SYNC_INTERVAL
            done
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        "")
            # Default behavior - run once
            log "🔄 Running one-time sync (use --help for options)..."
            sync_changes
            ;;
        *)
            error "Unknown option: $1. Use --help for available options."
            ;;
    esac
}

# Run main function
main "$@"
