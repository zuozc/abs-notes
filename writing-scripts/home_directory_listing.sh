#!/bin/bash

# Author: Loyal Zuo
# Email: zzczuo@gmail.com
#
# Perform a recursive directory listing on the user's home directory and save the information to a file. Compress the file, have the script prompt the user to insert a USB flash drive, then press ENTER. Finally, save the file to the flash drive after making certain the flash drive has properly mounted by parsing the output of df. Note that the flash drive must be unmounted before it is removed.
#

HOME=/home/zuozc  # user home directory
TMP_FILE=home_dir_info  # temporary file to store info

# save home directory info recursively.
save_info () {
  
  echo "$1" >> $TMP_FILE
  
  if [[ -d $1 ]]; then

    for f in $1/*; do
    #  echo $f
      save_info $f
    done

  fi
  
  return 0

}

touch $TMP_FILE

trap "rm ${TMP_FILE}*; exit 130" INT TERM # clean temporary file once CTRL+C pressed

save_info $HOME

if [[ $? -ne 0 ]]; then
  echo "Exception occurs."
  exit 1
fi

tar -jvcf ${TMP_FILE}.tar.bz2 $TMP_FILE # compress

read -p "Please insert a USB flash drive to store home directory info. Then PRESS ENTER. " line # prompt to insert USB flash drive

usb=$(df -h | grep "\/media\/" | awk '{print $6}')  # find mounted directory

cp ${TMP_FILE}.tar.bz2 ${usb}/  # save info to USB

rm ${TMP_FILE}* # remove temporary files

umount $usb

exit 0
