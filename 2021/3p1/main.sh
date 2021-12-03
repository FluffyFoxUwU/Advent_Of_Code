#!/bin/bash

ZERO=()
ONE=()
while read -r LINE; do
  I=0
  for BIT in `echo $LINE | sed -e 's/\(.\)/\1\n/g'`; do
    if [ $BIT = 1 ]; then
      ONE[I]=$((ONE[I] + 1))
    else
      ZERO[I]=$((ZERO[I] + 1))
    fi
    I=$((I+1))
  done 
done

GAMMA=
EPSILON=
for (( I=0; I<${#ZERO[@]}; I++ )); do
  if [ ${ZERO[I]} -gt ${ONE[I]} ]; then
    GAMMA=${GAMMA}0
    EPSILON=${EPSILON}1
  else
    GAMMA=${GAMMA}1
    EPSILON=${EPSILON}0
  fi 
done
echo $(($((2#$GAMMA)) * $((2#$EPSILON)))) 



