#!/bin/bash

#
# Author: Loyal Zuo
# Email: zzczuo@gmail.com
#
# Backup file or files under specific directory and modified within -d days.
#
# Usage: backup_files.sh -p=folder|file -d=days
# -p specify file or folder to find files
# -d within how many days, default to 1
#

# process arguments
process_args () {

  for value in "$@"; do
    echo $value
    case $value in
      -p=*) 
        TARGET="${value#*=}"
        echo $TARGET
        shift
      ;;
      -d=*) 
        DAYS="${value#*=}"
        echo $TARGET
        shift
      ;;
      *)
      
    esac
  
  done

}

usage () {

  echo "Usage:"
  echo "  $0 -p=directory|file -d=number_of_days"

}

DAYS=1  # default
TARGET=
ERR_ARG_NUM=85  # too few arguments
ERR_NOT_EXIST=87 # not exits

if [[ $# -eq 0 ]]; then
  echo "$#: too few arguments." 
  usage
  exit $ERR_ARG_NUM
fi

process_args "$@"

TARGET=${TARGET%/}
# echo "TARGET=$TARGET"

[[ ! -e $TARGET ]] && echo "$TARGET: file/directory not exists." && exit $ERR_NOT_EXIST

ct=$(date +%Y%m%d%H%M%S)  # time to backup

# check what we need to backup, a file or files under specific forlder and modified within -d days
if [[ -d $TARGET ]]; then
  files=$(find $TARGET -mtime -$DAYS | egrep -xv "$TARGET"  | tr "\n" ' ') # initialize files to be compressed
  [[ -z $files ]] && echo "No modify within $DAYS days." && exit 0
else
  files=$TARGET
fi

tar -zvcf backup.${ct}.tar.gz $files

exit 0
