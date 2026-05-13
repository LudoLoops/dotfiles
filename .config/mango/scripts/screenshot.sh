#!/bin/bash
# Capture only the active monitor, then open satty for annotation
focused=$(mmsg -g -o | awk '/selmon 1/ {print $1}')
grim -o "$focused" - | satty -f - --resize smart --floating-hack
