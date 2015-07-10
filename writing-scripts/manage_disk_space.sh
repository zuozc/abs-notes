#!/bin/bash

#
# Author: Loyal Zuo
# Email: zzczuo@gmail.com
#
# List, one at a time, all files larger than -size K in -dir directory tree.
# Give the user the option to ignore, delete or compress the file, then proceed to show the next one. 
# Write to a logfile the info of all deleted or compressed files and the operation times.
#
# Usage: manage_disk_space.sh -dir=directory -size=num
# -size num KBytes.
#

ERR_ARG_EMPTY=85
ERR_ARG_ILLEGAL=87
DIR=
SIZE=
DEFAULT_SIZE=100

[[ $# -eq 0 ]] && echo "$#: too few arguments." && exit $ERR_ARG_EMPTY

# process arguments
process_args () {
  for value in "$@"; do
    case $value in
      -dir=*)
        DIR=${value#*=}
        ;;
      -size=*)
        SIZE=${value#*=}
        ;;
      *)
        ;;
    esac
  done
}

process_args "$@"

[[ ! -d $DIR ]] && echo "$DIR: not exists or not a directory." && exit $ERR_ARG_ILLEGAL

DIR=${DIR%*\/}
#echo $DIR
SIZE_K=${SIZE:-$DEFAULT_SIZE} # size inputed
SIZE=$((SIZE_K*1024)) # size in bytes
#echo $SIZE
manage_disk_space_log=/tmp/manage_disk_space.log # log of this script
touch $manage_disk_space_log

# find files and process them
rm_or_tar () {
  # it's better using local variables in functions, to avoid side-effect.
  # for example, during recursion, $p_dir should be reset at each recursing level.
  local p_dir="$1"
  #echo $p_dir
  local tmp="$IFS"
  IFS=$'\n' # split by '\n'
  local lines=( $(ls -l "$p_dir" | sed "1d") )  # a replacement of pipe
  IFS="$tmp"
  #echo "${#lines[@]}"
  
  #############################################################################################
  # ls -l "$p_dir" | sed "1d" | while read line; do # pipe will cause prompting of sub-shell.
  #   local short=$(echo "$line" | awk '{print $9}')
  #   local name="$(echo "${p_dir}/${short}")"
  #   if [[ -d "$name" ]]; then
  #     echo "dir $name"
  #     rm_or_tar "$name"
  #   else
  #     local size=$(echo "$line" | awk '{print $5}')
  #     echo "size = $size" # will be printed
  #     if [[ $size -gt $SIZE ]]; then
  #       echo "in"  # will be printed
  #       # while block will not be processed. Maybe related to sub-shell.
  #       while read -p "$name greater than ${SIZE}K, d DELETE or c COMPRESS it? " choice; do
  #         
  #         case $choice in
  #          ...
  #         esac
  #
  #       done
  #     fi
  #   fi
  # done
  #############################################################################################
  # won't work correctly
  #
  #############################################################################################

  for line in "${lines[@]}"; do
    #echo "$line"
    local short=$(echo "$line" | awk '{print $9}')  # file name, same as basename.
    local name="$(echo "${p_dir}/${short}")"  # get absolute name

    # directory
    if [[ -d "$name" ]]; then
      #echo "dir $name"
      rm_or_tar "$name"

    # file
    else
      local size=$(echo "$line" | awk '{print $5}')
      #echo "size = $size"

      if [[ $size -gt $SIZE ]]; then
        printf "%.3fK, %s\n" "$(echo "scale=3; $size/1024" | bc)" $name
        
        # tips and choice
        while read -p "Greater than ${SIZE_K}K, i IGNORE, d DELETE or c COMPRESS it? " choice; do
          
          case $choice in
            i)
              echo "Ignore it."
              break
              ;;
            d)
              #rm $name # avoid wrong operation, if you want try, just uncomment it.
              echo "@$(date) DELETE $name" >> $manage_disk_space_log
              echo "Delete it."
              break
              ;;
            c)
              #tar -zcvf "${name}.tar.gz" $name
              #rm $name  # avoid wrong operation, if you want try, just uncomment it.
              echo "@$(date) COMPRESS $name" >> $manage_disk_space_log
              echo "Compress it."
              break
              ;;
            *)
              ;;
          esac

        done
        
      fi
    fi
  done 
}

rm_or_tar $DIR

exit 0
