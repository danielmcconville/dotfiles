cp -R -n ./osx/services/* ~/Library/Services/

# Symlink PopClip settings
unlink  ~/Library/Application\ Support/PopClip
ln -s ~/Dropbox/Apps/PopClip ~/Library/Application\ Support/PopClip

# Install LaunchRocket (https://github.com/jimbojsb/launchrocketo)
# Homebrew services control panel
brew tap jimbojsb/launchrocket
brew cask install launchrocket
