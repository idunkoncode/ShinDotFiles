# ShinLevitra's Universal Dotfiles 🚀

A comprehensive dotfiles configuration for Linux systems featuring Hyprland, Waybar, Rofi, Kitty, and Fish shell. Compatible with multiple Linux distributions including Fedora, Arch, Ubuntu, openSUSE Tumbleweed, and Void Linux.

## 🌟 Features

- **Hyprland**: Modern Wayland compositor with beautiful animations
- **Waybar**: Highly customizable status bar with multiple themes
- **Rofi**: Application launcher and dmenu replacement
- **Kitty**: Fast, modern terminal emulator with extensive theming
- **Fish Shell**: User-friendly shell with Tide prompt theme
- **Starship**: Cross-shell prompt with rich customization
- **Multiple Themes**: Various color schemes and layouts to choose from
- **Universal Installer**: Works across major Linux distributions

## 📦 Supported Distributions

✅ **Officially Supported:**
- Fedora (including Nobara)
- Arch Linux (including Manjaro, EndeavourOS)
- Ubuntu/Debian (including Pop!_OS, Zorin, Elementary)
- openSUSE Tumbleweed
- Void Linux

⚠️ **Partial Support:**
- Other distributions may work but might require manual package installation

## 🚀 Quick Installation

### Automatic Installation

```bash
# Clone the repository
git clone https://github.com/idunkoncode/ShinDotFiles.git
cd ShinDotFiles

# Run the universal installer
./install.sh
```

The installer will:
1. Detect your Linux distribution
2. Install required packages using your system's package manager
3. Backup your existing configurations
4. Install the dotfiles
5. Configure Fish shell with Tide prompt
6. Set Fish as your default shell

### Manual Installation

If you prefer manual installation or the automatic installer doesn't work for your distribution:

1. **Install Required Packages:**
   ```bash
   # Fedora
   sudo dnf install fish starship kitty hyprland waybar rofi swww grim slurp wl-clipboard brightnessctl playerctl pamixer pavucontrol networkmanager-applet polkit-gnome xdg-desktop-portal-hyprland qt5-qtwayland qt6-qtwayland hypridle hyprlock wallust wlogout cava jq curl git stow
   
   # Arch
   sudo pacman -S fish starship kitty hyprland waybar rofi swww grim slurp wl-clipboard brightnessctl playerctl pamixer pavucontrol network-manager-applet polkit-gnome xdg-desktop-portal-hyprland qt5-wayland qt6-wayland hypridle hyprlock wlogout cava jq curl git stow
   
   # Ubuntu/Debian (basic packages, some may need manual installation)
   sudo apt install fish kitty rofi grim slurp wl-clipboard brightnessctl playerctl pavucontrol network-manager-gnome polkit-gnome-authentication-agent-1 jq curl git stow
   ```

2. **Backup Existing Configs:**
   ```bash
   mkdir -p ~/.config_backup
   cp -r ~/.config/{fish,kitty,hypr,waybar,rofi,starship.toml} ~/.config_backup/ 2>/dev/null || true
   ```

3. **Install Dotfiles:**
   ```bash
   cp -r config/* ~/.config/
   ```

4. **Install Fish Plugins:**
   ```bash
   fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
   fish -c "fisher install IlanCosman/tide@v6 jorgebucaran/nvm.fish PatrickF1/fzf.fish"
   ```

5. **Set Fish as Default Shell:**
   ```bash
   sudo chsh -s $(which fish) $USER
   ```

## 🎨 Configuration

### Hyprland
- Main config: `~/.config/hypr/hyprland.conf`
- Monitor setup: `~/.config/hypr/monitors.conf`
- User settings: `~/.config/hypr/UserConfigs/`
- Scripts: `~/.config/hypr/scripts/`

### Waybar
- Multiple layouts available in `~/.config/waybar/configs/`
- Various styles in `~/.config/waybar/style/`
- Switch layouts with the provided scripts

### Kitty
- Extensive theme collection in `~/.config/kitty/kitty-themes/`
- Easy theme switching via scripts

### Rofi
- Multiple themes and configurations
- Integrated with wallpaper effects

## 🛠️ Post-Installation

1. **Restart your session** or run `exec fish` to use the new shell
2. **Configure monitors** in `~/.config/hypr/monitors.conf`
3. **Set wallpapers** in your `~/Pictures/Wallpapers/` directory
4. **Customize themes** using the provided scripts

## ⌨️ Key Bindings (Hyprland)

| Key Combination | Action |
|---|---|
| `SUPER + Return` | Open Kitty terminal |
| `SUPER + D` | Open Rofi launcher |
| `SUPER + Q` | Close window |
| `SUPER + M` | Exit Hyprland |
| `SUPER + V` | Toggle floating |
| `SUPER + J/K/L/H` | Move focus |
| `SUPER + 1-9` | Switch workspaces |
| `SUPER + Shift + 1-9` | Move window to workspace |
| `SUPER + Print` | Screenshot |

*See `~/.config/hypr/UserConfigs/UserKeybinds.conf` for complete list*

## 🎭 Themes

The dotfiles include multiple themes for each component:

- **Waybar**: 30+ different layouts and styles
- **Kitty**: 100+ terminal themes
- **Rofi**: 15+ launcher themes
- **Hyprland**: Various animation and decoration sets

## 🔧 Troubleshooting

### Common Issues

1. **Package not found**: Some distributions might not have all packages in their repositories. Check the distribution-specific notes in the installer.

2. **Permission issues**: Make sure you're not running the installer as root.

3. **Fish plugins not working**: Restart your terminal and run `fisher list` to check installed plugins.

4. **Hyprland not starting**: Check if your graphics drivers support Wayland and ensure all dependencies are installed.

### Distribution-Specific Notes

**Ubuntu/Debian**: Hyprland might need manual installation from PPA or building from source.

**openSUSE Tumbleweed**: Some packages might be in different repositories.

**Void Linux**: Limited package availability, some components might need manual installation.

## 🤝 Contributing

Contributions are welcome! Please feel free to:
- Report bugs
- Suggest new features
- Add support for more distributions
- Improve existing configurations

## 📝 License

This project is open source. Feel free to use, modify, and distribute as you see fit.

## 🙏 Credits

- Hyprland community for the amazing compositor
- All the theme creators whose work is included
- The Fish shell and Tide prompt teams
- Everyone who contributes to the open source ecosystem

---

**Enjoy your new setup!** 🎉

If you encounter any issues, please open an issue on the repository or check the troubleshooting section above.
# Auto-push enabled Sun Jul 20 04:25:41 PM PDT 2025
