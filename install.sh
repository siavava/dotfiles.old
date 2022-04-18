#!/bin/bash

: <<COMMENT
Install Script for my dot-files.

Author: Amittai <amittaijoel@outlook.com>

Update system dotfiles and push to GitHub.

Usage: ./install.sh [--help || mode ] [source] [destination]
COMMENT

# !! -- > add extra targets here
targets=\
'
bash_aliases
bashrc
bash_profile
pubring.kbx
gitconfig
gitignore
vimrc
tmux.conf
zshrc
zsh_aliases
condarc
gpg.key
'

: <<COMMENT
This function copies files from current repo to system (user) home directory.



COMMENT
function ins() {
  # Check if destination is specified
  if [[ -z "$1" ]]; then
    echo "No destination specified. Using default: $HOME"
    local destinationdir="$HOME"
  else
    local destinationdir="$1"
  fi

  if [[ -z "$2" ]]; then
    echo "No source specified. Using default: $(pwd)/configs"
    sourcedir="$(pwd)/configs"
  else
    sourcedir="$2"
  fi

  echo "Installing dotfiles from $sourcedir to $destinationdir..."

  # Cross-copy all files.
  for target in $targets; do
    if [[ -r "$sourcedir/$target" ]]; then
      echo "Copying $target..."
      copy "2" "$target" "$sourcedir" "$destinationdir"
    else
      echo "$sourcedir/$target not found..."
    fi
  done

}

function exp() {
  info="This utility updates dotfiles."
  local destinationdir="configs"
  local sourcedir="$HOME"

  if [[ -n "$1" ]]; then
    sourcedir="$1"
    if [[ -n "$2" ]]; then
      destinationdir="$2"
    fi
  fi

  # Cross-copy all files.
  for target in $targets; do
    if [[ -r "$sourcedir/.$target" ]]; then
      copy "1" "$target" "$sourcedir" "$destinationdir"
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
  exitcode="0"

  if [[ $(git commit -m "$now") ]]; then
    if git push -u "origin" "$node"; then
      echo "Push successful!"
    else
      echo -e "Push to GitHub failed.\nPlease check the remote configuration and your internet connection."
      exitcode="1"
    fi
  else
    echo -e "Commit failed.\nMost likely no files changed."
    exitcode="2"
  fi

  # git checkout main
  return $exitcode
}

: <<COMMENT
Copy configs file from sourcedir to a specified directory.

Usage: copy [mode] [filename] [destination]

NOTE: Exclude the '.' from the filename.

Example: copy bash_aliases configs

This function always returns 0.
COMMENT
function copy() {
  if (( $# != 4 )); then
    echo "Invalid number of arguments: $#"
    return 1
  fi

  # variables
  declare -i mode=$1

  # filename
  filename="$2"

  # source directory
  sourcedir="$3"

  # destination directory
  destination="$4"

  # echo "mode: $mode, filename: $filename, sourcedir: $sourcedir, destination: $destination"

  case $mode in
    1)
      # dotfiles --> repo
      # process the file.
      if [[ -r "$sourcedir/.$filename" ]]; then
        if [[ -r "$destination/$filename" ]]; then
          if [[ $(diff "$sourcedir/.$filename" "$destination/$filename") ]]; then
            echo "Copying $filename..."
            cp -f "$sourcedir/.$filename" "$destination/$filename"
          else
            echo "$filename is up to date."
          fi
        else
          cp -f "$sourcedir/.$filename" "$destination/$filename"
        fi
      fi
      ;;
    2)
      # repo --> dotfiles
      # process the file.
      if [[ -r "$sourcedir/$filename" ]]; then
        if [[ -r "$destination/.$filename" ]]; then
          if [[ $(diff "$sourcedir/$filename" "$destination/.$filename") ]]; then
            echo "Copying $filename..."
            cp -f "$sourcedir/$filename" "$destination/.$filename"
          else
            echo "$filename is up to date."
          fi
        else
          cp -f "$sourcedir/$filename" "$destination/.$filename"
        fi
      else
        echo "$sourcedir/$filename not found."
      fi
      ;;
    *) 
      # invalid mode
      echo "Invalid mode."
      return 1
      ;;
  esac
  return 0
}


if (( $# )) && [[ "$1" == '--help' || "$1" == '-h' || "$1" == '-H' ]]; then
  echo "$info"
  echo "Usage: $0 [--help] [-y]"
  return 3
fi
  
mode="1"

if (( $# )); then
  mode="$1"
  shift
fi

case $mode in
  1)
    exp "$@"
    ;;
  2)
    ins "$@"
    ;;
  *)
    echo "Invalid mode."
    exit 1
    ;;
esac

exit 0
