#!/bin/bash

: <<COMMENT
Install Script for my dot-files.

Author: Amittai <amittaijoel@outlook.com>

Update system dotfiles and push to GitHub.

Usage: ./install.sh [--help || destination] [source]
COMMENT
function updatealiases() {
  info="This utility updates dotfiles."
  destination="configs"
  source="$HOME"
  targets="bash_aliases bashrc bash_profile pubring.kbx gitconfig gitignore vimrc tmux.conf zshrc zsh_aliases condarc"

  if (( $# != 0 )) && [[ "$1" == '--help' || "$1" == '-h' || "$1" == '-H' ]]; then
    echo "$info"
    echo "Usage: $0 [--help] [-y]"
    return 3
  fi

  if [[ -n "$1" ]]; then
    source="$1"
    if [[ -n "$2" ]]; then
      destination="$2"
    fi
  fi

  # Cross-copy all files.
  for target in $targets; do
    if [[ -r "$source/.$target" ]]; then
      copy "$target" "$source" "$destination"
    fi
  done

  # push updates (if any) to GitHub
  push

  return 0
}

: <<COMMENT
Function to push files to GitHub.

Usage: push

Assumes it is in the relevant repo.

Generates a commit message based on the current date and time.

Generates a branch named after the current system.
COMMENT
function push() {

  node="$(hostname)"
  now="$(date +"%Y-%m-%d at %H:%M:%S")"
  git switch -C "$node"
  git add -A &&

  if [[ $(git commit -m "$now") ]]; then
    if git push -u "origin" "$node"; then
      echo "Push successful!"
      return 0
    else
      echo -e "Push to GitHub failed.\nPlease check the remote configuration and your internet connection."
      return 1
    fi
  else
    echo -e "Commit failed.\nMost likely no files changed."
    return 2
  fi
}

: <<COMMENT
Copy configs file from $source to a specified directory.

Usage: copy [filename] [destination]

NOTE: Exclude the '.' from the filename.

Example: copy bash_aliases configs

This function always returns 0.
COMMENT
function copy() {
  if (( $# != 3 )); then
    return 1
  fi

  # variables
  filename="$1"
  source="$2"
  destination="$3"

  # process the file.
  if [[ -r "$source/.$filename" ]]; then
    if [[ -r "$destination/$filename" ]]; then
      if [[ $(diff "$source/.$filename" "$destination/$filename") ]]; then
        echo "Copying $filename..."
        cp -f "$source/.$filename" "$destination/$filename"
      else
        echo "$filename is up to date."
      fi
    else
      cp -f "$source/.$filename" "$destination/$filename"
    fi
  fi
  return 0
}

updatealiases "$@"
