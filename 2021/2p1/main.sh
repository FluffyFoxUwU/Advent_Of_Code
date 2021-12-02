#!/bin/bash

X=0
Y=0
while read -r LINE; do
  CHANGES=`echo $LINE | grep -E -o '[0-9]+'`
  case $LINE in 
    f*)
      X=$((X+CHANGES))
      ;;
    u*)
      Y=$((Y-CHANGES))
      ;;
    d*)
      Y=$((Y+CHANGES))
      ;;
  esac
done
echo $((X*Y))

