#!/bin/bash

#
# Author: Loyal Zuo
# Email: zzczuo@gmail.com
#
# ASCII to integer and vice versa.
#

legal_int () {
  [[ $(echo "$1" | egrep "[^0-9]") ]] && echo "$1: not an integer." && return 1
  #echo "all digits"
  [[ ${#1} -gt 1 && $(echo "$1" | egrep "^0") ]] && echo "$1: do not start with zero, except your input is zero." && return 1
  #echo "not start with zero"
  [[ $1 -ge 256 ]] && echo "$1: do not greater than 255." && return 1
  #echo "less than 256"
  return 0
}

int2char_oct () {
  # transfer to OCT firstly, then to \NNN (byte with octal value NNN (1 to 3 digits))
  printf "\\$(printf "%03o" "$1")\n"  # 03 (length 3 characters, complete with 0), not necessary.
}

int2char_hex () {
  # transfer to HEX firstly, then to "\xHH" (byte with hexadecimal value HH (1 to 2 digits))
  printf "\x$(printf "%x" "$1")\n"
}

char2int () {
  # The Single Unix Specification: "If the leading character is a single-quote or double-quote, 
  # the value shall be the numeric value in the underlying codeset of the character following
  # the single-quote or double-quote.
  printf "%d\n" "'$1"
}

while read -p "Chose your operation (1 for int_to_char, 2 for char_to_int, # for exit): " choice; do

  case $choice in
    '1') 
      read -p "Input an integer: " int
      #echo "int $int"
      legal_int $int
      if [[ $? -eq 0 ]]; then
        int2char_hex $int 
      fi
      ;;
    '2')
      read -p "Input a character: " char
      char2int $char
      ;;
    '#') break
      ;;
    *) 
      echo "Not surpported. Try again." 
      ;;
  esac

done

exit 0
