#!/bin/bash
# Fox: 52 bytes
paste -sd+ | sed s/++/\\n/g | bc | sort -n | tail -1

