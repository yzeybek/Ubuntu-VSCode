#!/usr/bin/bash

# Variables
APP_NAME=Ubuntu-VSCode

DIR_NAME=Ubuntu-VSCode
DIR_PATH=$HOME/$DIR_NAME

TAR_NAME=Ubuntu-VSCode.tar.gz
TAR_PATH=$DIR_PATH/$TAR_NAME

FOLDER_NAME=VSCode-linux-x64
FOLDER_PATH=$DIR_PATH/$FOLDER_NAME

ICON_NAME=code.png
ICON_PATH=$DIR_PATH/resources/app/resources/linux/$ICON_NAME

# Tar file operations
mkdir $DIR_PATH
curl https://vscode.download.prss.microsoft.com/dbazure/download/stable/e8653663e8840adaf45af01eab5c627a5af81807/code-stable-x64-1730980362.tar.gz -o $TAR_PATH
tar -xzf $TAR_PATH -C $DIR_PATH
cp -r $FOLDER_PATH/* $DIR_PATH
rm -rf $FOLDER_PATH $TAR_PATH
rm -f $ICON_PATH

# Get image
curl https://raw.githubusercontent.com/yzeybek/Ubuntu-VSCode/refs/heads/main/code.png -o $ICON_PATH

# Desktop entry
echo "[Desktop Entry]
Name=$APP_NAME
Comment=Programming Text Editor
Exec=$DIR_PATH/bin/code
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Development" > ~/.local/share/applications/$APP_NAME.desktop
chmod +x ~/.local/share/applications/$APP_NAME.desktop
update-desktop-database ~/.local/share/applications

# Gnome shell update
current_favorites=$(gsettings get org.gnome.shell favorite-apps)
current_favorites_cleaned=$(echo "$current_favorites" | sed "s/^\[//" | sed "s/\]//")
new_favorites="$current_favorites_cleaned, '$APP_NAME.desktop'"
new_favorites_wrapped="[$new_favorites]"
gsettings set org.gnome.shell favorite-apps "$new_favorites_wrapped"

# Adding path
echo "export PATH=\$PATH:$DIR_PATH/bin" >> ~/.zshrc
echo "export PATH=\$PATH:$DIR_PATH/bin" >> ~/.bashrc
source ~/.bashrc
source ~/.zshrc
