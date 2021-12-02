#!/bin/bash

CURRENT=-1
NUMBER_INCREASE=0
while IFS= read -r LINE; do
  if [ $LINE -gt $CURRENT ]; then
    NUMBER_INCREASE=`expr $NUMBER_INCREASE + 1`
  fi
  CURRENT=$LINE
done

echo "$NUMBER_INCREASE"
