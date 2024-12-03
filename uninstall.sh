#!/usr/bin/bash

# Variables
DIR_NAME=Wcode
DIR_PATH=$HOME/$DIR_NAME

DESKTOP_NAME=code.desktop
URL_DESKTOP_NAME=code-url-handler.desktop
DESKTOP_PATH=$HOME/.local/share/applications/$DESKTOP_NAME
URL_DESKTOP_PATH=$HOME/.local/share/applications/$URL_DESKTOP_NAME

# Deletions
rm -rf $DIR_PATH
rm -f $DESKTOP_PATH
rm -f $URL_DESKTOP_PATH
