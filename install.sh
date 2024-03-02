#!/bin/bash

# Download Neovim binary
echo "⬇️ Downloading Neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz

# Remove existing Neovim installation
echo "🧹 Removing existing Neovim installation..."
sudo rm -rf /opt/nvim

# Extract Neovim binary to /opt
echo "📦 Extracting Neovim to /opt..."
sudo tar -C /opt -xzf nvim-linux64.tar.gz

# Add Neovim binary path to PATH
echo "🛠️ Adding Neovim to PATH..."
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
source ~/.bashrc

# Clean up downloaded tar.gz file
echo "🗑️ Cleaning up..."
rm nvim-linux64.tar.gz

echo "✅ Neovim has been successfully installed! You can now start using it."
