#!/bin/bash
aarch64-linux-gnu-as -g -c main.s -o main.o
aarch64-linux-gnu-ld main.o -lc -o main
