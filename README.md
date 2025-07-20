# My Dotfiles

Personal configuration files for my Fedora Linux setup.

## 📂 Structure

```
dotfiles/
├── config/
│   ├── fish/
│   │   └── config.fish       # Fish shell configuration
│   ├── starship/
│   │   └── starship.toml     # Starship prompt configuration
│   ├── hypr/                 # Hyprland window manager config
│   ├── waybar/               # Waybar status bar config
│   ├── rofi/                 # Rofi launcher config
│   ├── kitty/                # Kitty terminal emulator config
│   ├── nvim/                 # Neovim text editor config
│   └── cargo/                # Rust Cargo configuration
├── install.sh                # Installation script
└── README.md                 # This file
```

## 🚀 Installation

1. Clone this repository to your home directory:
   ```bash
   git clone <repository-url> ~/dotfiles
   ```

2. Run the installation script:
   ```bash
   cd ~/dotfiles
   ./install.sh
   ```

3. Restart your shell or source the config:
   ```fish
   source ~/.config/fish/config.fish
   ```

## ⚙️ Features

- **Fish Shell**: Custom configuration with:
  - Random movie quotes on startup
  - Starship prompt integration
  - eza aliases for better file listing
  - Automatic SSH agent setup
  - Cargo bin path configuration
  
- **Starship**: Custom prompt configuration

- **Hyprland**: Wayland compositor configuration
  - Window management rules
  - Keybindings and workspace setup
  - Display and input configuration

- **Waybar**: Status bar configuration
  - System monitoring widgets
  - Custom styling and colors
  - Workspace and window information

- **Rofi**: Application launcher configuration
  - Custom themes and styling
  - Enhanced search functionality

- **Kitty**: Terminal emulator configuration
  - Custom themes and color schemes
  - Font and rendering settings
  - Key bindings and behavior

- **Neovim**: Text editor configuration
  - Plugin management and configuration
  - Custom key bindings
  - Language server setup

- **Rust/Cargo**: Rust toolchain configuration
  - Cargo settings and aliases
  - Build and dependency management

## 🔐 SSH Setup

The fish config automatically:
- Starts SSH agent if not running
- Loads your `~/.ssh/Fedora` private key
- Keeps SSH authentication persistent across sessions

## 📝 Notes

- The install script creates backups of existing config files before symlinking
- SSH keys are expected to be in `~/.ssh/Fedora` and `~/.ssh/Fedora.pub`
- Uses fish shell with starship prompt
