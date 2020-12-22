#!/usr/bin/env bash

# Install Homebrew (if not installed)
echo "Installing Homebrew."

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed` as gsed
brew install gnu-sed

# Install `wget` with IRI support.
brew install wget --with-iri

brew install gmp
brew install grep
brew install node

# Install useful binaries.
brew install neofetch
brew install htop
brew install ripgrep
brew install autojump
brew install git
brew install github/gh/gh
brew install rename
brew install ssh-copy-id
brew install tree
brew install youtube-dl

# Installs Casks
brew tap caskroom/cask

## Apps I use
brew install --cask lastpass
brew install --cask alfred
brew install --cask beamer
brew install --cask dash
brew install --cask dropbox
brew install --cask google-chrome #Chrome
brew install --cask grammarly
brew install --cask iterm2
brew install --cask mongodb-compass
brew install --cask spotify
brew install --cask sublime-merge 
brew install --cask whatsapp
brew install --cask logitech-options

# Remove outdated versions from the cellar.
brew cleanup
