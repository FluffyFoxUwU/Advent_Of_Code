#!/bin/bash
# Fox: 70 bytes
paste -sd+ | sed s/++/\\n/g | bc | sort -n | tail -3 | paste -sd+ | bc

