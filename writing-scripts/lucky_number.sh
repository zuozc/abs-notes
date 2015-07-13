#!/bin/bash 

#
# Author: Loyal Zuo
# Email: zzczuo@gmail.com
#
# Check if a number is a lucky number. A lucky number is one whose individual digits add up to 7, in successive additions.
# For example, 62431 is a lucky number (6 + 2 + 4 + 3 + 1 = 16, 1 + 6 = 7). 
#
# Usage: lucky_number.sh num
#

ERR_NO_ARGS=85
ERR_NOT_NUM=87

[[ $# -eq 0 ]] && echo "$#: too few arguments" && exit $ERR_NO_ARGS

[[ $(echo $1 | egrep "[^0-9]") ]] && echo "$1: illegal arguments" && exit $ERR_NOT_NUM

num=$1

while [[ ${#num} -ne 1 ]]; do
  #echo $num
  sum=0
  for (( i = 0; i < ${#num}; i ++ )); do
    d=${num:i:1}
    ((sum += d))
  done
  #[[ $sum -eq 7 ]] && echo "$1: lucky number!"
  num=$sum
done

[[ $num -eq 7 ]] && echo "$1: lucky number!" || echo "$1: not lucky number."

exit 0
