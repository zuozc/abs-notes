#!/bin/bash

# 
# Author: Loyal Zuo
# Email: zzczuo@gmail.com
#
# Determines if an argument passed to it is an integer or a string. The function will return TRUE (0) if passed an integer, and FALSE (1) if passed a string.
#
# Usage: int_or_not.sh arg 
#

is_integer () {

  if [[ $1 == "0" || $1 == "-0" || $1 == "+0" ]]; then 
    return 0
  fi

  value="$1"
  tmp="$1"
  [[ $(echo $value | egrep "^[-+]{2,}") ]] && return 1
  if [[ $(echo $value | egrep "^[-+]{1}") ]]; then
    value=${value#\-}
    value=${value#\+}
  fi

  # no characters except digit
  [[ $(echo $value | egrep "[^0-9]") ]] && echo "$value: contains none-digit character except only one leading - or +." && return 1
  # can't start with zero
  [[ $(echo $value | egrep "^0+") ]] && echo "$value: start with zero." && return 1
  # can't exceed (this method is controversial.)
  [[ $((value/13)) -eq 0 && $((value%13)) -eq 0 ]] && echo "$value: must not exceed to integer." && return 1

  return 0

}

is_integer "$1"

[[ $? -eq 0 ]] && echo "$1: Integer." || echo "$1: String."
