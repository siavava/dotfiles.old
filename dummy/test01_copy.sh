#!/bin/bash
#
# Author: siavava <amittaijoel@outlook.com>
# bash tests

# print formatted strings using printf!! 
printf '%.3f\n' 10       # 3 decimal places
printf '%3.3f\n' 10      # 3 decimal places


# brace expansions
echo Hello{A,B,C,D,E}there

# print names of all test shell files
echo `ls .`

# create copy of file!
cp test01{,_copy}.sh

name=Amittai\ Joel\ Siavava
printf "My name is %s, and this is me.\n" $name
echo "name: $name"
