#!/bin/bash
# custom bash aliases and functions
# Author: siavava <amittaijoel@outlook.com>

# to check size / sizes of folders and files.
alias sizes='du -hs'

# override disactivation of backslash escapes
alias echo='echo -e'

# friendly `ls`
alias lt='ls --human-readable --size -1 -S --classify'

# view mounted drives
alias mnt='mount | grep -E ^/dev | column -t'

# search command history.
alias search='history|grep'

# to check weather in a given place 
# -- (manually modified to work with my location)

function weather() {

  # if no argument, print for Nairobi.
  if [[ $# -eq 0 ]]; then
    printf "\nNo location specified... Showing updates for Nairobi.\n\n"
    curl -s "http://v2.wttr.in/Nairobi"

  # else print weather for each location entered.
  else
    while (( $# )); do
      curl -s "http://v2.wttr.in/$1" 
      shift
    done
  fi
}

# override cd to highlight current directory.
function cd() {
  builtin cd "$@" || return
  printf "\n\033[0;32m%s\033[0m\n" "$(pwd)"
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
  
  elif [[ "$1" == '-A' || "$1" == '--all' ]]; then

  # if `-A` flag, count all files AND directories in *current directory OR specified subdirectories*.
    if (( $# == 1 )); then
      find . | wc -l
    else
      echo "${@:2}" 
      find "${@:2}" | wc -l
    fi
  else

  # else, count files only in specified directories.
    find "$@" -type f | wc -l
  fi
}

# run ocr on an image file from the internet.
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

# view command history in manageable sequences.
function history() {
  builtin history "$@" | less
}


function submit() {
  # submit a CS50 assignment.
  info="utility to submit a CS50 assignment"
  usage="submit [branch name]"
  example="submit submit1"

# no args or help flag -- print usage text.
  if [[ $# -eq 0 || "$1" =~ "--help" ]]; then
    echo "$info"
    echo "Usage: $usage"
    echo "Example: $example"

# if DIR is not a git repository, print error message and set flag.
  elif ! [[ -d ".git" ]]; then
    echo "Please run inside a git repository."
    echo "Error: submit failed."
    return 1
  else
    git branch "submit$1" &&
    git checkout "submit$1" &&
    git merge "main" "submit$1" &&
    git push "origin" "submit$1" &&
    git checkout "main" &&
    echo "submit$1 successfully pushed to GitHub!"
  fi

  if ! (( $? )); then
    echo "Error: submit failed."
    return 1
  fi

  return 0
}

# update bash_aliases file and push to GitHub.
function updatealiases() {
  currFolder=$(basename "$PWD")
  info="utility to update aliases"

  if [[ "$currFolder" != "bash" ]]; then
    echo "Please run this utility from the \"bash\" folder."
  else
    now=$(date +"%Y-%m-%d at %H:%M:%S")
    git checkout "main"
    cp "$HOME/.bash_aliases" "./configs/.bash_aliases" &&
    git add -A &&
    if [[ $(git commit -m "$now") && $(git push origin main) ]]; then
      echo -e "Update complete!\nCommit \"$now\" pushed to GitHub."
      return 0
    else
      echo "The files are already up to date."
      return 2
    fi
  fi

  echo -e "An error occured.\nPlease make sure the \".bash_aliases\" file\nand you're running this command from the \".bash\" folder in the repo."
  return 1
}


