#!/bin/bash

#
# Author: Loyal Zuo
# Email: zzczuo@gmail.com
#
# Write a script that reads each line of a target file, then writes the line back to stdout, but with an extra blank line following. This has the effect of double-spacing the file.
# Include all necessary code to check whether the script gets the necessary command-line argument (a filename), and whether the specified file exists.
# When the script runs correctly, modify it to triple-space the target file.
# Finally, write a script to remove all blank lines from the target file, single-spacing it.
#
# Usage: change_line_spacing.sh filename
#

ERR_ARG=85
ERR_FILE=87

[[ $# -eq 0 ]] && echo "Must input a filename." && exit $ERR_ARG 

file=$1

[[ ! -e $file ]] && echo "File not exits." && exit $ERR_FILE 

#sed -i G $file  # Double space a file. Each G space a file one time. For instance, "sed -i 'G;G' $file" while triple space a file.
sed -i "/^$/d;G" $file  # Delete all blank lines of a file, then double space it.

while read line; do

  echo $line

done < $file

sed -i "/^$/d" $file

exit 0
