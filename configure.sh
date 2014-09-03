# Unset = expansion, which is causing '= not found' error on string comparisons
unsetopt EQUALS

DOTFILES_ROOT="`pwd`"

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

link_files () {
  if [ -f $2 ] || [ -d $2 ]
  then
    unlink $2
  fi
  ln -s $1 $2
  success "linked $1 to $2"
}

add_to_path () {
  export PATH=$1:$PATH
  success "added $1 to PATH"
}

symlink_files () {
  info "Symlinking files\n"

	overwrite_all=false
	backup_all=false
	skip_all=false

	for source in `find $DOTFILES_ROOT -maxdepth 2 -name \*.symlink`
	do
		dest="$HOME/.`basename \"${source%.*}\"`"

		if [ -f $dest ] || [ -d $dest ]
		then
			overwrite=false
			backup=false
			skip=false

			if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
			then
				user "File already exists: `basename $source`, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
				read action

				case "$action" in
					o )
						overwrite=true;;
					O )
						overwrite_all=true;;
					b )
						backup=true;;
					B )
						backup_all=true;;
					s )
						skip=true;;
					S )
						skip_all=true;;
					* )
						;;
				esac
			fi

			if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]
			then
				rm -rf $dest
				success "removed $dest"
			fi

			if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]
			then
				mv $dest $dest\.backup
				success "moved $dest to $dest.backup"
			fi

			if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]
			then
				link_files $source $dest
			else
				success "skipped $source"
			fi
		else
			link_files $source $dest
		fi
	done
}

symlink_folders () {
  info "Symlinking folders\n"

  for source in `find $DOTFILES_ROOT -maxdepth 2 -name \dirlink`
  do
    source_path=${source%/*}
    folder_name=${source_path##/*/}
    dest="$HOME/.$folder_name"

    if [ ! -d "$dest" ]; then
      link_files $source_path $dest
    fi
  done
}

run_topic_configure () {
  info "Running per-topic configurations...\n"

  # load every completion after autocomplete loads
  for file in `find $DOTFILES_ROOT -maxdepth 2 -name \configure.sh`
  do
    if [ ! "$file" == "$DOTFILES_ROOT/configure.sh" ]
    then
      info "Processing configuration from $file\n"
      source  $file
    fi
  done
}

install_homebrew_packages_from_file () {
  while read line;
  do
    if [ $(brew list | grep -E "^$line$") == $line ]
    then
      info "$line is already installed. Skipping.\n"
    else 
      brew install $line
    fi
  done < $1
}

install_homebrew_cask_packages_from_file () {
  brew tap caskroom/cask
  brew install brew-cask
  while read line;
  do
    if [ $(brew list | grep -E "^$line$") == $line ]
    then
      info "$line is already installed. Skipping.\n"
    else 
      brew cask install $line
    fi
  done < $1
}

install_homebrew_packages () {
  # Update brew definitions
  info "Updating Homebrew formulas. Stay calm...\n"
  brew update
  # Go through all topics and install brew packages for each one
  for source in `find $DOTFILES_ROOT -maxdepth 2 -name \*.brew`
  do
    install_homebrew_packages_from_file $source
  done
  for source in `find $DOTFILES_ROOT -maxdepth 2 -name \*.cask`
  do
    install_homebrew_cask_packages_from_file $source
  done
  # Upgrade existing packages 
  info "Upgrading installed packages...\n"
  brew upgrade
  # Linking apps
  info "Linking Homebrew apps...\n"
  brew linkapps
}

# -----------------------------------------------------------------------

# Add bin to the path
dest="$HOME/.bin"
if [ ! -d "$dest" ]; then
 link_files "$DOTFILES_ROOT/bin/" $dest
 add_to_path $dest
fi

# Symlink folders
symlink_folders

# Symlink files
symlink_files

# Install topic packages via Homebrew 
install_homebrew_packages

# Run topic configure scripts
run_topic_configure


