#!/bin/sh
current=$(mmsg -g -l | grep -m1 -oP 'layout \K.')
case "$current" in
    S) mmsg -s -l "T" ;;
    *) mmsg -s -l "S" ;;
esac
