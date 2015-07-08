#!/bin/bash

#
# Author: Loyal Zuo
# Email: zzczuo@gmail.com
#
# Given a list of filenames, decompress them automatically.
# 
# Usage: auto_decompress.sh file1 file2 ..
#

ERR_ARG=85  # Too few arguments

[[ $# -eq 0 ]] && echo "$#: too few arguments." && exit $ERR_ARG

while [[ ! -z $1 ]]; do

  if [[ ! -e $1 ]]; then

    echo "$1 is not exits. Going to procee next file."

  else

    ft=$(file $1 | awk '{print $2}')  # extract file type.
    
    case $ft in # support zip, bzip2, gzip for now.
      "Zip") unzip $1
      ;;
      "bzip2") tar jvxf $1
      ;;
      "gzip") tar zxvf $1
      ;;
      *) echo "Not supported yet."
    esac

  fi

  shift # read next arguments

done

exit 0
