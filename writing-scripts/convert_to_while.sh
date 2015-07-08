#!/bin/bash

planets=(Mercury Venus Earth Mars Jupiter Saturn Uranus Neptune Pluto)
i=0
total=${#planets[@]}

while (( i < total )); do
  echo -n ${planets[$i]}" "
  (( i += 1 ))
done
echo 

(( i-- ))

until (( i < 0 )); do
  echo -n  ${planets[$i]}" "
  (( i -= 1 ))
done
echo
