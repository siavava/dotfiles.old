#!/bin/bash
#
# Author: siavava <amittaijoel@outlook.com>

function hello() {
  declare -i _count; _count=$1
  declare -i _total; _total=$((_count+1))
  
  while [ "$_count" -gt 0 ]; do
    declare -i step; step=$_total-$_count
    local _name=$2
    echo "hello $_name, round $step"
    ((_count--))
  done 

  printf "\n\n\n"

  # if [ $_count -gt 0 ]; then
  #   _name=$2
  #   echo "hello $_name, round $_count"
  #   hello $_count-1 "${@:2}"
  # fi
}

hello 5 "Amittai"

# infinite loop

function infinite_loop() {
  while true; do
    echo "Infinite loop... press <CTRL+C> to exit."
    sleep 1
  done
}

# function call
# infinite_loop

# read from a file!!
function print_file() {
  local file=$1

  while read -r line; do
    echo "$line"
  done < "$file"
}

echo "$0"
basename "$0"

function print_self() {
  print_file "$(basename "$0")"
}

print_self



function namerefs() {
  declare -n nr
  local i=1
  for nr in v1 v2 v3; do
    nr=$((i++)) && printf "."
    echo "set nr = ${nr}"
  done
  echo ""

  printf "v1: %.3f, v2: %d, v3: %d\n" "$v1" "$v2" "$v3"

}

namerefs
