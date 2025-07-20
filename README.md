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
├── setup.sh                  # Automated system setup script
├── install.sh                # Basic installation script
├── sync.sh                   # Automatic sync script
└── README.md                 # This file
```

## 🚀 Installation

### Quick Setup (Automated)

1. Clone this repository:
   ```bash
   git clone git@github.com:idunkoncode/ShinDotFiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the automated setup script (installs packages + configures everything):
   ```bash
   ./setup.sh
   ```

3. Install automatic syncing (optional but recommended):
   ```bash
   ./sync.sh --install
   ```

### Manual Setup

1. Clone this repository:
   ```bash
   git clone git@github.com:idunkoncode/ShinDotFiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Install packages manually, then run:
   ```bash
   ./install.sh
   ```

3. Restart your shell:
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

## 🤖 Automation Scripts

### `setup.sh` - Automated System Setup

Completely automates the installation of all required packages and dotfiles setup:

```bash
./setup.sh    # Full system setup with package installation
```

**What it does:**
- Updates system packages
- Installs Hyprland, Fish, Neovim, Kitty, Waybar, Rofi
- Installs Rust, .NET, Node.js development tools
- Configures Fish as default shell
- Installs JetBrains Mono Nerd Font
- Creates all dotfiles symlinks
- Sets up SSH configuration

### `sync.sh` - Automatic Dotfiles Sync

Keeps your dotfiles repository in sync with your current configurations:

```bash
./sync.sh --sync       # Run one sync cycle
./sync.sh --install    # Install automatic sync every 15 minutes
./sync.sh --uninstall  # Remove automatic sync
./sync.sh --daemon     # Run continuously
./sync.sh --help       # Show all options
```

**Features:**
- Automatically detects changes in your config files
- Syncs current configs back to the dotfiles repository
- Commits and pushes changes to GitHub
- Handles merge conflicts automatically
- Runs every 15 minutes when installed as cron job
- Comprehensive logging to `~/dotfiles/sync.log`

## 🔐 SSH Setup

The fish config automatically:
- Starts SSH agent if not running
- Loads your `~/.ssh/Fedora` private key
- Keeps SSH authentication persistent across sessions

## 📝 Notes

- The install script creates backups of existing config files before symlinking
- SSH keys are expected to be in `~/.ssh/Fedora` and `~/.ssh/Fedora.pub`
- Uses fish shell with starship prompt
