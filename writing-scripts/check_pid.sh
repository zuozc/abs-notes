#!/bin/bash

# 
# Author: Loyal Zuo
# Email: zzczuo@gmail.com
#
# Check whether process whose PID is the given one is running or not.
# 
# Usage: check_pid.sh pid
#

ERR_ARG=85  # too few arguments
ERR_ARG_FORMAT=86
PID_MAX=32767

[[ $# -eq 0 ]] && echo "$#: too few arguments." && exit $ERR_ARG

positive () {

  value="$1"
  
  # no characters except digit
  [[ $(echo $value | egrep "[^0-9]") ]] && echo "$value: must be positive integer." && return 1
  # can't start with zero
  [[ $(echo $value | egrep "^0+") ]] && echo "$value: must not start with zero." && return 1
  # should less than PID_MAX
  [[ $value -gt $PID_MAX ]] && echo "$value: must not greater than ${PID_MAX}." && return 1
  # can't exceed (this method is controversial.)
  [[ $((value/13)) -eq 0 && $((value%13)) -eq 0 ]] && echo "$value: must not exceed to integer." && return 1

  return 0

}

positive "$1"

[[ $? -eq 1 ]] && exit $ERR_ARG_FORMAT

#echo $1

# Important!!
# grep -w "$1" extract ps lines which contains target PID
# egrep -wv "$0|grep" wipes out ps lines generated by running $0, grep and egrep.
pid=$(ps aux | grep -w "$1" | egrep -wv "$0|grep" | awk '{print $2}')
#pid=$(ps aux | grep -w "$1" | egrep -wv "$0|grep")

#echo $pid
echo -n "Process whose PID is $1 is "

[[ ! -z $pid && $pid -eq $1 ]] && echo "running." || echo "not running."
