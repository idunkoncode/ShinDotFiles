# VS Code Configuration

This directory contains VS Code configuration files and extensions for the dotfiles setup.

## Contents

- `User/settings.json` - VS Code user settings
- `User/snippets/` - Custom code snippets
- `install-extensions.sh` - Script to install all VS Code extensions

## Extensions Included

The `install-extensions.sh` script will install the following extensions:

### Development
- Python support (python, pylance, debugpy)
- C/C++ support (cpptools, cpptools-extension-pack, cmake-tools, lldb)
- Rust support (rust-analyzer, rust-extension-pack)
- HTML/CSS support and formatters
- Tailwind CSS support

### AI/Productivity
- GitHub Copilot & Copilot Chat
- GitLens for Git integration
- Neovim integration

### Utilities
- Code formatters and beautifiers
- Dependency management (dependi)
- TOML support
- Remote development tools

## Usage

The extensions will be automatically installed when running the main dotfiles install script. You can also manually run:

```bash
./install-extensions.sh
```

To update the extension list, modify the `install-extensions.sh` file and add/remove extensions as needed.
