#!/bin/bash

#
# Author: Loyal Zuo
# Email: zzczuo@gmail.com
#
# One type of lottery involves picking five different numbers, in the range of 1 - 50. Write a script that generates five pseudorandom numbers in this range, with no duplicates. The script will give the option of echoing the numbers to stdout or saving them to a file, along with the date and time the particular number set was generated.
#
# Usage: lottery_numbers.sh -f=file|-s
# -f output to given file
# -s standard output
#

numbers=()
HAS_S=1 # has -s
HAS_F=1 # has -f
FILE=
DEFAULT_FILE=lottery_numbers

# check is any number has been chosen.
is_picked () {
  
  num=$1

  for (( i = 0; i < ${#numbers[@]}; i ++ )); do
    
    [[ $num -eq ${numbers[$i]} ]] && return 1    

  done

  return 0

}

process_args () {

  for value in "$@"; do
  
    case $value in
      -f=*) FILE=${value#*=}
        HAS_F=0
        shift
      ;;
      -s) HAS_S=0
        shift
      ;;
      -f) HAS_F=0
        shift
      ;;
      *) shift 
      ;;
    esac

  done

}

process_args "$@"

# echo "-f $HAS_F, -s $HAS_S"

[[ $HAS_F -eq 0 ]] && FILE=${FILE:-$DEFAULT_FILE}

for (( i = 0; i < 5; i ++ )); do
  
  tmp=$(($RANDOM % 50 + 1))

  is_picked $tmp

  [[ $? -eq 0 ]] && numbers[$i]=$tmp || ((i --))
  
done

result="`date +%Y-%m-%d` `date +%H:%M:%S`, ${numbers[@]}"
[[ $HAS_S -eq 0 || $HAS_F -eq 1 ]] && echo "$result"
[[ $HAS_F -eq 0 ]] && echo "$result" > $FILE
