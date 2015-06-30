#!/bin/bash

# author: Loyal Zuo
# zzczuo@gmail.com
#
# max.sh: Find maximum of two integers.
#

EM_NOT_NUM="illegal number."

find_max () {  # returns larger one of two numbers.

  if [ "$1" -eq "$2" ]; then
    echo "$1 equals to $2."
  else
    if [ "$1" -gt "$2" ]; then
      echo "$1 is greater than $2."
    else
      echo "$1 is less than $2."
    fi
  fi

}


is_number () {  # check if the given argument is a number.

  re="(^[-+]|^ +[1-9][0-9]*)|[1-9][0-9]*"
  if [[ $(echo "$1" | egrep -w "$re") ]]; then 
    return 0
  else
    return 1
  fi

}

read -p "Please input two numbers (num1 num2): " var1 var2 

echo "$var1 $var2"

is_number $var1

[[ $? -eq 1 ]] && echo "$var1: $EM_NOT_NUM" && exit 1

is_number $var2

[[ $? -eq 1 ]] && echo "$var2: $EM_NOT_NUM" && exit 1


find_max $var1 $var2

exit 0
