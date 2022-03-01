#!/bin/bash
# custom bash aliases and functions
# Author: siavava <amittaijoel@outlook.com>

##### GPG Support ####
#######################
___tty=$(tty)
export GPG_TTY="$___tty"
#######################

# to check size / sizes of folders and files.
alias sizes='du -hs'

alias git='hub'
eval "$(hub alias -s)"

# override disactivation of backslash escapes
alias echo='echo -e'

# friendly `ls`
alias ls='ls -F --color=auto'
alias lt='ls --human-readable --size -1 -S --classify'


# view mounted drives
alias mnt='mount | grep -E ^/dev | column -t'

# search command history.
alias search='history | grep'

# python aliases
alias py='python'
alias py3='python3'

######## END OPENGL CUSTOMIZATION #########

# to check weather in a given place 
# -- (manually modified to work with my location)
function weather() {

  # if no argument, print for current location.
  if [[ $# -eq 0 ]]; then
    printf "\nNo location specified.\nShowing updates for your current location.\n\n"
    curl -s "http://v2.wttr.in"

  # if help flag, print usage info.
  elif [[ "$1" == "--help" ]]; then
    echo "Usage: weather { [--help] [location1] [location2] ... }"
    echo "Running without any args shows current location."

  # else print weather for each location entered.
  else
    for location in "$@"; do
      curl -s "http://v2.wttr.in/$location"
    done
  fi
}

# override cd to highlight current directory.
function cd() {
  builtin cd "$@" || return
  printf "\n\033[0;32m%s\033[0m\n" "$(pwd)"
}

function what() {
	RED="\u001b[31m"
	RESET="\u001b[0m"
	echo -e "$RED \nYou really fucked up lmao.\nBut at least you did something?\nNo?\nOkay then.\n$RESET"
	return 0
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

  elif ! [[ -r "$HOME/.bash_aliases" ]]; then
    echo "$HOME/.bash_aliases file not found. Stop."
    return 4
  else
    now=$(date +"%Y-%m-%d at %H:%M:%S")
    git checkout "main" &&
    cp "$HOME/.bash_aliases" "./configs/.bash_aliases" &&
    git add -A &&

    if [[ $(git commit -m "$now") ]]; then
    
      git push "origin" "main" && 
      echo "Push successful!"; return 0 ||
      echo -e "Push to GitHub failed.\nPlease check the remote configuration and your internet connection."
      return 1

    else
      echo "Commit failed. Make sure the \"main\" branch exists."
      return 2
    fi
  fi

  echo -e "An error occured.\nPlease make sure the \".bash_aliases\" file\nand 
  you're running this command from the \".bash\" folder in the repo."
  return 1
}

# function git() {
#   if [[ "$1" =~ "checkout" ]]; then
#     /usr/bin/git checkout "$2" || {
#       /usr/bin/git branch "$2" && /usr/bin/git checkout "$2"
#     }
#   else
#     /usr/bin/git "$@"
#   fi
# }


# function matrix() {
#   local ___str='{a[$3]=0;for (x in a){o=a[x];a[x]=a[x]+1;printf "\033[%s;%sH\033[2;32m%s",o,x,$4;printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,$4;if (a[x] >= $1){a[x]=0;} }}'
#   {
#     while :; do
#       echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(printf "\U$(($RANDOM % 500))") | gawk ___str
#       sleep 0.05
#     done
#    } 
# }

function matrix() {
  while :;do echo $LINES $COLUMNS $(( RANDOM % COLUMNS)) $(printf "\U$((RANDOM % 500))");sleep 0.05;done|gawk '{a[$3]=0;for (x in a){o=a[x];a[x]=a[x]+1;printf "\033[%s;%sH\033[2;32m%s",o,x,$4;printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,$4;if (a[x] >= $1){a[x]=0;} }}'
}

function name () {
  echo "$1" # arguments are accessible through $1, $2,...
}














#############################################################################
################################ TESTS ZONE #################################
#############################################################################

function test_iterate() {
  # test iterate function.
  for i in "$@"; do
    echo "$i"
  done
}


function move() {
  info="move: utility to move a file or folder (as appropriate) to a new location."
  usage="move [--help] [file] [new location]"

  echo "Attempting to move \"$1\" to \"$2\""

  if [[ $# -eq 0 || "$1" =~ "--help" ]]; then
    printf "1\n\n\n"
    if (( $# == 0 )); then echo "Error: Please provide source and target file locations."; fi
    echo "$info"
    echo "$usage"
    echo "$example"
  # elif ! (( $# )); then
  #   echo "Error: please name a file to move and the target location."
  #   echo "$info"
  #   echo "$usage"
  elif ! [[ -d "$1" || -f "$1" ]]; then
    printf "2\n\n\n"
    echo "Error: target file is nonexistent."
    echo "$info"
    echo "$usage"
  else
    declare -n fullname; fullname="$2"
    
    # if [[ "$2" =~ "$1" ]]; then
    #   fullname="$2"
    # else
    #   fullname="$2/$(basename $1)"
    # fi

    if  [[ -d "$1" ]]; then
      printf "3\n\n\n"
      echo "moving directory $1 to $fullname."
      mv -r "$1" "$2"
    elif [[ -d "$1" ]]; then
      printf "4\n\n\n"
      echo "moving file $1 to $fullname"
      mv "$1" "$fullname"
    fi
  fi
}

alias LT=lt
# safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# convenience aliases
alias ls='ls -F'
alias mkdir='mkdir -p'
alias which='type -all'
alias du='du -kh'
alias df='df -kTh'

# pretty printing
alias print='a2ps --landscape -2'
alias print1='a2ps --portrait  -1'
alias printwide='a2ps --landscape --columns=1 --chars-per-line=132'

# not an exact substitute, but works for most; see also 'lam'
alias abut=paste

# convert ps to pdf
alias distill='ps2pdf14 -dSubsetFonts=true -dEmbedAllFonts=true'
