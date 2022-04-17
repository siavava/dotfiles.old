#!/bin/bash
# custom bash aliases and functions
# Author: siavava <amittaijoel@outlook.com>

#######################
##### GPG Support #####
#######################
___tty=$(tty)
export GPG_TTY="$___tty"
#######################

#######################
#### Handy aliases ####
#######################

# check fonder/file sizes.
alias sizes='du -hs'

# override git with enhanced `hub` utility.
alias git='hub'
eval "$(hub alias -s)"

# override disactivation of backslash escapes
alias echo='echo -e'

# friendly `ls`
alias ls='ls -F --color=auto'
alias lt='ls --human-readable --size -1 -S --classify'
alias LT='lt'
alias l='lt'
# safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias \?='echo "\e[0;31m$(pwd)\e[0m"' # $'\e[0;31m$PWD\e[0m'

# convenience aliases
alias mkdir='mkdir -p'
alias which='type -all'
alias du='du -kh'
alias df='df -kTh'
alias storage='df -kTh'

# pretty printing
alias print='a2ps --landscape -2'
alias print1='a2ps --portrait  -1'
alias printwide='a2ps --landscape --columns=1 --chars-per-line=132'

# not an exact substitute, 
# but works for most; see also 'lam'
alias abut=paste

# convert ps to pdf
alias distill='ps2pdf14 -dSubsetFonts=true -dEmbedAllFonts=true'


# view mounted drives
alias mnt='mount | grep -E ^/dev | column -t'

# search command history.
alias search='history | grep'

# python aliases
alias py='python'
alias py3='python3'

# more manageable peek at history
alias history='history | less'


#######################################
########## Useful functions ###########
#######################################

# Function to check the weather in the command line.
# Usage: weather [locations...]
# If not location is specified, the current location is used.
function weather() {

  # if no argument, print for current location.
  if [[ $# -eq 0 ]]; then
    printf "\nNo location specified.\nShowing updates for your current location.\n\n"
    curl -s "http://v2.wttr.in"

  # if help flag, print usage info.
  elif [[ "$1" == "--help" ]]; then
    echo "Usage: weather { [--help] [location1] [location2] ... }"
    echo "Running without any args shows current location."
    return 1

  # else print weather for each location entered.
  else
    for location in "$@"; do
      curl -s "http://v2.wttr.in/$location"
    done
  fi
  return $?
}

# Functions to print more information
# about directory operations.

# 1. override cd to highlight current directory.
function cd() { 
  builtin cd "$@" > /dev/null && echo "\e[0;31m$(pwd)\e[0m"
}
# 2. override pushd to highlight current directory.
function pushd() {
  builtin pushd "$@" > /dev/null && echo "\e[0;31m$(pwd)\e[0m"
}
# 3. override popd to highlight current directory.
function popd() {
  builtin popd "$@" > /dev/null && echo "\e[0;31m$(pwd)\e[0m"
}

# count the number of files in a directory.
function countfiles() {

  info='The countfiles utility counts the number of files in a directory.'
  usage='Usage: countfiles [--help || -A || --all] [directory]'

  # if no args, count files only in current directory & subdirectories.
  if (( $# == 0 )); then
    find . -type f | wc -l

  # if help flag, print usage
  elif [[ "$1" == '--help' ]]; then
    echo "$info"
    echo "$usage"
    return 0
  
  elif [[ "$1" == '-A' || "$1" == '--all' ]]; then

  # if `-A` flag, count all files AND directories in *current directory OR specified subdirectories*.
    if (( $# == 1 )); then
      find . | wc -l
    else
      echo "Counting files in ${*:2}" 
      find "${@:2}" | wc -l
    fi
  else

  # else, count files only in specified directories.
    find "$@" -type f | wc -l
  fi
}

# What does this do?
# No one knows, which is the point.
function what() {
	RED="\u001b[31m"
	RESET="\u001b[0m"
	echo -e "$RED \nYou really fucked up lmao.\nBut at least you did something?\nNo?\nOkay then.\n$RESET"
	return 0
}


# Optical Image Recognition on the terminal.
function ocr() {

  # help and usage info.
  info="This is an OCR itility for character recognition from images."
  usage="Usage: ocr [--help] [image URL] [words sequence]\n
  (Note: URL must be specified, and word sequence must be in quotes if multiple words.)"

  # routine
  if [[ $# -eq 0 || "$1" =~ "--help" || $# -gt 2 ]]; then
    echo "$info"
    echo "$usage"
  elif [[ $# -eq 1 ]]; then
    curl -s "$1" -o - | tesseract stdin stdout
  else
    curl -s "$1" -o - | tesseract stdin stdout | grep "$2"
  fi

  # exit status
  return "$?"
}


function submit() {
  # submit a CS50 assignment.
  info="utility to submit a CS50 assignment"
  usage="submit [lab number]"
  example="submit submit1"

# no args or help flag -- print usage text.
  if [[ $# -eq 0 || "$1" =~ "--help" ]]; then
    echo "$info"
    echo "Usage: $usage"
    echo "Example: $example"
    return 0

# if DIR is not a git repository, print error message and return.
  elif ! [[ -d ".git" ]]; then
    echo "Please run inside a git repository."
    echo "Error: submit failed."
    return 1
  fi


  git branch "submit$1" || { 
    echo "Error creating \"submit$1\" branch."
    return 1
  }

  git checkout "submit$1" || {
    echo "Error checking out \"submit$1\" branch."
    return 1
  }

  git merge "main" "submit$1" || {
    echo "Error merging \"main\" branch into \"submit$1\" branch."
    return 1
  }
  git push "origin" "submit$1" || { 
    echo "Error pushing branch to remote. Please check your internet connection and your access to the repo."
    return 1
  }
  
  git checkout "main"
  echo "submit$1 successfully pushed to GitHub!"

  return 0
}

# update bash_aliases file and push to GitHub.
function updatealiases() {
  currFolder=$(basename "$PWD")
  info="utility to update aliases"

  if [[ "$currFolder" != "bash" ]]; then
    echo "Please run this utility from the \"bash\" folder."
    return 3
  fi

  if [[ -r "$HOME/.bash_aliases" ]]; then
    echo "Copying bash_aliases..."
    cp "$HOME/.bash_aliases" "./configs/bash_aliases"
  fi

  if [[ -r "$HOME/.bashrc" ]]; then
    echo "Copying bashrc..."
    cp "$HOME/.bashrc" "./configs/bashrc"
  fi

  if [[ -r "$HOME/.bash_profile" ]]; then
    echo "Copying bash_profile..."
    cp "$HOME/.bash_profile" "./configs/bash_profile"
  fi

  if [[ -r $HOME/.gnupg/pubring.kbx ]]; then
    echo "Copying pubring.kbx..."
    cp "$HOME/.gnupg/pubring.kbx" "./configs/pubring.kbx"
  fi

  if [[ -r "$HOME/.gitconfig" ]]; then
    echo "Copying gitconfig..."
    cp "$HOME/.gitconfig" "./configs/gitconfig"
  fi

  if [[ -r "$HOME/.gitignore" ]]; then
    echo "Copying gitignore..."
    cp "$HOME/.gitignore" "./configs/gitignore"
  fi

  if [[ -r "$HOME/.vimrc" ]]; then
    echo "Copying vimrc..."
    cp "$HOME/.vimrc" "./configs/vimrc"
  fi

  if [[ -r "$HOME/.tmux.conf" ]]; then
    echo "Copying tmux.conf..."
    cp "$HOME/.tmux.conf" "./configs/tmux.conf"
  fi

  if [[ -r "$HOME/.zshrc" ]]; then
    echo "Copying zshrc..."
    cp "$HOME/.zshrc" "./configs/zshrc"
  fi

  if [[ -r "$HOME/.zsh_aliases" ]]; then
    echo "Copying zsh_aliases..."
    cp "$HOME/.zsh_aliases" "./configs/zsh_aliases"
  fi

  now=$(date +"%Y-%m-%d at %H:%M:%S")
  git checkout "main" &&
  git add -A &&

  if [[ $(git commit -m "$now") ]]; then
  
    git push "origin" "main" && 
    echo "Push successful!"; return 0 ||
    echo -e "Push to GitHub failed.\nPlease check the remote configuration and your internet connection."
    return 1

  else
    echo -e "Commit failed.\n
             Most likely no files changed."
    return 2
  fi

  return 0
}

# A simple shifter function that
# iterates through the arguments it gets.
# Usage: shifter [--help] [args...]
function shifter() {
  usage="Usage: shifter [--help] [args...]"

  if [[ $# -eq 0 || "$1" == "--help" ]]; then
    echo "$usage"
  
  else
    # test iterate function.
    declare -i index=1
    while (( $# )); do
      echo "$(( index++ )): $1"
      shift;
    done
  fi
  return 0
}

# See all ASCII color codes.
function colors() {
  usage="\tUsage: colors [--help] [--all] [color]\n\t[color] must be between 0 and 255."
  if [[ $# -eq 0 || $1 == --help ]]; then
    echo "${usage}"
    return 0
  elif [[ $1 == '--all' || $1 == '-a' ]]; then
    for code in {0..255}; do
      echo -e "\e[38;5;${code}m"'\\e[38;5;'"$code"m"\e[0m"
    done
    return 0
  elif (( $1 < 0 )) || (( $1 > 255 )); then
    echo "Error: invalid color code."
    echo "${usage}"
    return 1
  else
    declare -i code=$1
    echo -e "\e[38;5;${code}m"'\\e[38;5;'"$code"m"\e[0m"
  fi
  return 0  
}
