#!/bin/bash -

###############################################################################
# setup.sh
# This script creates everything needed to get started on a new laptop
# cribbed from: https://github.com/Stratus3D/dotfiles/blob/master/scripts/setup.sh
###############################################################################

# Unoffical Bash "strict mode"
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\t\n' # Stricter IFS settings
ORIGINAL_IFS=$IFS

cd $HOME

DOTFILES_DIR=$HOME/dotfiles
DOTFILE_SCRIPTS_DIR=$DOTFILES_DIR/scripts

###############################################################################
# Setup dotfiles
###############################################################################

if [ ! -d $DOTFILES_DIR ]; then
  if hash git 2>/dev/null; then
    echo "Git is already installed. Cloning repository..."
    git clone ssh://git@github.com/willisplummer/dotfiles.git $DOTFILES_DIR
  else
    echo "Git is not installed. Downloading repository archive..."
    wget https://github.com/willisplummer/dotfiles/archive/master.tar.gz
    tar -zxvf master.tar.gz
    mv dotfiles-master dotfiles
    # TODO: If we have to download the archive, we don't git the .git
    # metadata, which means we can't run `git pull` in dotfiles directory to
    # update the dotfiles. Which means if we run this script again, the else
    # clause below will fail.
  fi
else
  cd $DOTFILES_DIR
  # We could have modifications in the repository, so we stash them
  git stash
  git pull origin master
  git stash pop
fi

# Change to the dotfiles directory either way
cd $DOTFILES_DIR

###############################################################################
# Create commonly used directories
###############################################################################
mkdir -p $HOME/bin # Third-party binaries
mkdir -p $HOME/lib # Third-party software
mkdir -p $HOME/nobackup # All files that shouldn't be backed up the normal way
mkdir -p $HOME/history # Zsh and Bash history files
mkdir -p $HOME/code
mkdir -p $HOME/code/archived # Old projects
mkdir -p $HOME/.psql # psql history directory


###############################################################################
# Install software on laptop
###############################################################################

# Install oh-my-zsh first, as the laptop script doesn't install it
ZSH_DIR="$HOME/.oh-my-zsh"
if [[ -d $ZSH_DIR ]]; then
    # Update Zsh if we already have it installed
    cd $ZSH_DIR
    git pull origin master
    cd -
else
    # Install it if don't have a ~/.oh-my-zsh directory
    curl -L http://install.ohmyz.sh | sh
fi

# install homebrew
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install and configure iterm
brew cask install iterm2
# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/dotfiles/iterm2_profile"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# install nix
curl https://nixos.org/nix/install | sh
