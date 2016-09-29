#!/bin/bash

#
# Author: Loyal Zuo
# Email: zzczuo@gmail.com
#
# Find the sum of all five-digit numbers (in the range 10000 - 99999) containing exactly two out of the following set of digits: { 4, 5, 6 }. 
# These may repeat within the same number, and if so, they count once for each occurrence.
# Some examples of matching numbers are 42057, 74638, and 89515.
#

# sum of matching numbers
digits=(4 5 6)  # given digit set
log="matching.log"  # logs
sum=0 # sum of matched numbers
USER_INT=89 # exit status of user interrupt

[[ -e "$log" ]] && rm "$log"

trap "rm -f $log; exit $USER_INT" INT TERM  # clean when occur user interruption

echo "matching digits"

# match in number range
for ((i = 10000; i < 20000; i ++)); do
  #echo; echo -n "$i, "
  for d1 in "${digits[@]}"; do
    for d2 in "${digits[@]}"; do
      #echo "\".*${d1}.*${d2}.*\" || \".*${d2}.*${d1}.*\""
      if [[ $(echo "$i" | egrep -w ".*${d1}.*${d2}.*") || $(echo "$i" | egrep -w ".*${d2}.*${d1}.*") ]]; then
        ((sum += 1))
        echo $i >> matching.log
        break 2 # break to next if matched to avoid over count.
      fi
    done
  done
done

echo $sum
