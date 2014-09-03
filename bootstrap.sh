# The purpose of this script is to install initial tools required for the further dotfiles configuration
#
# Currently, this means:
# 1. Install Homebrew
# 2. Install zsh
# 3. Change default shell to zsh

set -e

info () {
  printf "  [ \033[00;34m..\033[0m ] $1"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

add_usr_local_bin_to_path () {
	if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
		info "Adding /usr/local/bin to PATH\n"
		PATH="/usr/local/bin:$PATH"
	fi
}

install_homebrew () {
	if test ! $(which brew)
	then
		info "Installing Homebrew...\n"
		ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
	else
		info "Homebrew is already installed. Moving on.\n"
	fi
}

install_git () {
	if (brew list | grep -w git); then
		info "Git is already installed. Moving on.\n"
	else
		info "Installing git...\n"
		brew install git
	fi
}

install_zsh () {
	if (brew list | grep -w zsh); then 
		info "Zsh is already installed. Moving on.\n"
	else
		info "Installing zsh...\n"
		brew install zsh
	fi
}

make_zsh_default () {
	if [ "$ZSH_NAME" ]; 
	then
		info "Already running zsh. Moving on.\n"
	else
		info "Switching to zsh...\n"
		chsh -s $(which zsh)
	fi
}

add_usr_local_bin_to_path
install_homebrew
install_git
install_zsh
make_zsh_default
