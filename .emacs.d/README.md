# Emacs Configuration

This is a modern Emacs configuration with sensible defaults and useful packages for development.

## Features

### Basic Settings
- Clean UI (no toolbar, menu bar, or scroll bar)
- Line numbers and column numbers enabled
- Parentheses highlighting
- Auto-pairing of brackets and quotes
- No backup files or auto-save

### Packages Included
- **doom-themes**: Beautiful color schemes
- **doom-modeline**: Modern and informative mode line
- **ivy/counsel/swiper**: Powerful completion framework
- **which-key**: Shows available keybindings
- **magit**: Excellent Git integration
- **projectile**: Project management
- **company**: Auto-completion
- **flycheck**: Syntax checking
- **lsp-mode**: Language Server Protocol support
- **neotree**: File tree browser
- **org-bullets**: Better org-mode bullets
- **vterm**: Terminal emulator

### Key Bindings
- `C-x g`: Open Magit status
- `C-c t`: Toggle Neotree file browser
- `C-c p`: Projectile command map
- `C-c l`: LSP command map
- `C-c r`: Revert buffer
- `C-c c`: Comment/uncomment region
- `C-c R`: Reload configuration
- `C-s`: Swiper search
- `M-x`: Counsel M-x

## Installation

1. Copy this `.emacs.d` directory to your home directory:
   ```bash
   cp -r .emacs.d ~/
   ```

2. Start Emacs - packages will be automatically downloaded and installed on first run.

3. Install fonts for icons (run this in Emacs):
   ```
   M-x all-the-icons-install-fonts
   ```

## Customization

- Font: Currently set to "Fira Code" at height 110. Adjust in the font settings section.
- Theme: Using doom-one theme. Change in the theme section.
- LSP languages: Add more language modes to the lsp-mode hook as needed.

## Requirements

- Emacs 26.1 or later
- Internet connection for initial package installation
