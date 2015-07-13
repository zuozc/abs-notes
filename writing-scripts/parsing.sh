#!/bin/bash

#
# Author: Loyal Zuo
# Email: zzczuo@gmail.com
#
# Parse /etc/passwd, and output its contents in nice, easy-to-read tabular form.
#

printf "%18s\t%8s\t%s\t%s\t%35s\t%30s%30s\n" Username Password UID GID description HOME "Login Shell"
cat /etc/passwd | awk 'BEGIN {FS=":"} { printf "%18s\t%8s\t%s\t%s\t%35s\t%30s%30s\n", $1, $2, $3, $4, $5, $6, $7 }'

exit 0
