#!/bin/bash

# count specified letters in specified file
# usage: letter-count.sh file letters

E_PARAMERR=85  # Too few arguments.

print_usage()
{
    echo "Usage: letter-count.sh file letters"
    echo "For example: ./letter-count.sh file.log a b c"
    exit $E_PARAMERR
} 
 
# check if specified file exits. 
if [[ ! -f "$1" ]]; then
  echo "$1: No such file."
  print_usage
fi 

# check if specify letters to count
if [[ -z "$2" ]]; then
  echo "$2: No letters specified."
  print_usage
fi 

FILE=$1 # file to count
shift

init_letters=""
i=0

# initialize awk script
for letter in "$@"; do
  init_letters="$init_letters letters[${i}] = \"$letter\"; count[${i}] = 0; " 
  ((i += 1))
done

# echo $init_letters

# count by awk
cat $FILE | awk "BEGIN { $init_letters }
{ 
  split(\$0, a, \"\"); 
  for (ca in a) { 
    for (cl in letters) { 
      if (letters[cl] == a[ca]) { 
        count[cl]++ 
      } 
    } 
  }
} 
END { 
  for (c in count) { 
    print letters[c] \" => \" count[c] 
  } 
}"
