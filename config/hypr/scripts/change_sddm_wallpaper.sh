#!/bin/bash
# Script to change SDDM wallpaper from JaKooLit wallpaper collection
# Created by Agent Mode

WALLPAPER_DIR="/home/shinlevitra/Pictures/wallpapers"
SDDM_THEME_DIR="/usr/share/sddm/themes/01-breeze-fedora"
THEME_CONF="$SDDM_THEME_DIR/theme.conf"

# Function to display available wallpapers
list_wallpapers() {
    echo "Available wallpapers:"
    echo "===================="
    find "$WALLPAPER_DIR" -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" | sort | nl -w 3 -s ". "
}

# Function to set wallpaper
set_wallpaper() {
    local wallpaper_path="$1"
    local filename=$(basename "$wallpaper_path")
    
    # Check if wallpaper exists
    if [[ ! -f "$wallpaper_path" ]]; then
        echo "Error: Wallpaper file not found: $wallpaper_path"
        exit 1
    fi
    
    echo "Setting SDDM wallpaper to: $filename"
    
    # Create backup if it doesn't exist
    if [[ ! -f "$THEME_CONF.backup" ]]; then
        sudo cp "$THEME_CONF" "$THEME_CONF.backup"
        echo "Created backup: $THEME_CONF.backup"
    fi
    
    # Copy wallpaper to SDDM theme directory
    sudo cp "$wallpaper_path" "$SDDM_THEME_DIR/"
    
    # Update theme configuration
    sudo sed -i "s|background=.*|background=$SDDM_THEME_DIR/$filename|" "$THEME_CONF"
    
    # Restart SDDM
    echo "Restarting SDDM to apply changes..."
    sudo systemctl restart sddm
    
    echo "✅ SDDM wallpaper changed successfully!"
    echo "New wallpaper: $filename"
}

# Main script logic
case "$1" in
    "list"|"ls")
        list_wallpapers
        ;;
    "set")
        if [[ -z "$2" ]]; then
            echo "Usage: $0 set <wallpaper_number_or_path>"
            echo "Use '$0 list' to see available wallpapers"
            exit 1
        fi
        
        if [[ "$2" =~ ^[0-9]+$ ]]; then
            # User provided a number
            wallpaper_path=$(find "$WALLPAPER_DIR" -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" | sort | sed -n "${2}p")
            if [[ -z "$wallpaper_path" ]]; then
                echo "Error: Invalid wallpaper number: $2"
                echo "Use '$0 list' to see available wallpapers"
                exit 1
            fi
        else
            # User provided a path or filename
            if [[ -f "$2" ]]; then
                wallpaper_path="$2"
            elif [[ -f "$WALLPAPER_DIR/$2" ]]; then
                wallpaper_path="$WALLPAPER_DIR/$2"
            else
                echo "Error: Wallpaper not found: $2"
                exit 1
            fi
        fi
        
        set_wallpaper "$wallpaper_path"
        ;;
    "current")
        current_bg=$(grep "background=" "$THEME_CONF" | cut -d'=' -f2)
        echo "Current SDDM wallpaper: $(basename "$current_bg")"
        ;;
    *)
        echo "SDDM Wallpaper Changer"
        echo "======================"
        echo "Usage: $0 <command> [options]"
        echo ""
        echo "Commands:"
        echo "  list, ls          - List all available wallpapers"
        echo "  set <number|path> - Set wallpaper by number or path"
        echo "  current           - Show current SDDM wallpaper"
        echo ""
        echo "Examples:"
        echo "  $0 list                    # List all wallpapers"
        echo "  $0 set 5                   # Set wallpaper number 5"
        echo "  $0 set Fantasy-Lake1.png   # Set specific wallpaper"
        echo "  $0 current                 # Show current wallpaper"
        ;;
esac
