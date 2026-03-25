#!/bin/env bash
# Afficher calendrier en notification
notify-send "📅 $(date +"%B %Y")" "\n$(cal)"
