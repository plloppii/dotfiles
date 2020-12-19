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
brew cask install lastpass
brew cask install alfred
brew cask install beamer
brew cask install dash
brew cask install dropbox
brew cask install google-chrome #Chrome
brew cask install grammarly
brew cask install iterm2
brew cask install mongodb-compass
brew cask install spotify
brew cask install sublime-merge 
brew cask install whatsapp
brew cask install logitech-options

# Remove outdated versions from the cellar.
brew cleanup
