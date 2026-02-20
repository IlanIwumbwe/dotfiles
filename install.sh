#!/usr/bin/env bash
set -e

# depending on system, get package manager and install dependencies
if [[ "$(uname)" == "Darwin" ]]; then
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install stow zsh neovim tmux fzf ripgrep
  brew bundle  # if you have a Brewfile

elif [[ "$(uname)" == "Linux" ]]; then
  if command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y stow zsh neovim tmux fzf ripgrep
  elif command -v pacman &>/dev/null; then
    sudo pacman -Sy stow zsh neovim tmux fzf ripgrep
  fi
fi

# get dotfiles
git clone https://github.com/IlanIwumbwe/dotfiles.git ~/dotfiles

# stow dotfiles to create symlinks 
~/dotfiles
stow */

echo "Done! Restart your shell.

