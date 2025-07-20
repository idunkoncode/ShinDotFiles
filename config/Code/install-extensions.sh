#!/bin/bash

# VS Code Extensions Installation Script
# This script installs all VS Code extensions for the dotfiles setup

extensions=(
    "aeschli.vscode-css-formatter"
    "asvetliakov.vscode-neovim"
    "bradlc.vscode-tailwindcss"
    "clinyong.vscode-css-modules"
    "eamodio.gitlens"
    "ecmel.vscode-html-css"
    "fill-labs.dependi"
    "franneck94.c-cpp-runner"
    "george-alisson.html-preview-vscode"
    "github.copilot"
    "github.copilot-chat"
    "hars.cppsnippets"
    "joy-yu.css-snippets"
    "michelemelluso.code-beautifier"
    "mohd-akram.vscode-html-format"
    "ms-python.debugpy"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-vscode.cmake-tools"
    "ms-vscode.cpptools"
    "ms-vscode.cpptools-extension-pack"
    "ms-vscode.cpptools-themes"
    "ms-vscode.remote-explorer"
    "ms-vscode.remote-server"
    "notsecret32.rust-extension-pack-vscode"
    "rust-lang.rust-analyzer"
    "sidthesloth.html5-boilerplate"
    "solnurkarim.html-to-css-autocompletion"
    "tamasfe.even-better-toml"
    "vadimcn.vscode-lldb"
    "zignd.html-css-class-completion"
)

echo "Installing VS Code extensions..."

for extension in "${extensions[@]}"; do
    echo "Installing $extension..."
    code --install-extension "$extension"
done

echo "All VS Code extensions installed successfully!"
