#!/bin/env bash
# Affiche les 3 villes par défaut
manille=$(TZ="Asia/Manila" date +"%R")
paris=$(TZ="Europe/Paris" date +"%R")
montreal=$(TZ="America/Montreal" date +"%R")
date_locale=$(date +"%d·%m·%y")

echo "🇵🇭 $manille · 🇫🇷 $paris · 🇨🇦 $montreal 📅 $date_locale"
