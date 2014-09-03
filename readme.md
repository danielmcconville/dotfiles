Features:

- \bin - everything in bin is added to path, so it will be available to run anywhere
- topic/*.zsh - any files ending in *.zsh get loaded into an environment
- topic/path.zsh - File named path.zsh is loaded first and expected to configure $PATH for that topic
- topic/completion.zsh - File named completion.zsh is loaded last and is expected to setup autocomplete
- topic/*.symlink - any file with the extension *.symlink will be linked to the home directory
- topic/*.brew - any file with the extension *.brew is expected to contain list of apps that need to be installed for that topic via homebrew
- topic/*.cask - any file with the extension *.cask is expected to contain list of apps that need to be installed for that topic via homebrew-cask
- topic/dirlink - if dirlink file is present, then the entire folder will be linked to the home directory, i.e. dirlink in ./vim/ forces it to become ~/.vim/
- topic/configure.sh - file name configure.sh will be run for each topic (when present) and is expected to drive any additional installation and configuration

Thanks goes to:
- Zach Holman for his idea of 'topical' dotfiles
