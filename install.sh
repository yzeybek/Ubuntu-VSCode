#!/usr/bin/bash

# Variables
APP_NAME=Wcode

DIR_NAME=Wcode
DIR_PATH=$HOME/$DIR_NAME

TAR_NAME=Wcode.tar.gz
TAR_PATH=$DIR_PATH/$TAR_NAME

FOLDER_NAME=VSCode-linux-x64
FOLDER_PATH=$DIR_PATH/$FOLDER_NAME

ICON_NAME=code.png
ICON_PATH=$DIR_PATH/resources/app/resources/linux/$ICON_NAME

DESKTOP_NAME=code.desktop
URL_DESKTOP_NAME=code-url-handler.desktop
DESKTOP_PATH=$HOME/.local/share/applications/$DESKTOP_NAME
URL_DESKTOP_PATH=$HOME/.local/share/applications/$URL_DESKTOP_NAME

# Tar file operations
mkdir $DIR_PATH
curl https://vscode.download.prss.microsoft.com/dbazure/download/stable/f1a4fb101478ce6ec82fe9627c43efbf9e98c813/code-stable-x64-1731511985.tar.gz -o $TAR_PATH
tar -xzf $TAR_PATH -C $DIR_PATH
cp -r $FOLDER_PATH/* $DIR_PATH
rm -rf $FOLDER_PATH $TAR_PATH

# Desktop entry
echo "[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=$DIR_PATH/bin/code %F
Icon=$ICON_PATH
Type=Application
StartupNotify=false
StartupWMClass=Code
Categories=TextEditor;Development;IDE;
MimeType=application/x-code-workspace;
Actions=new-empty-window;
Keywords=vscode;

[Desktop Action new-empty-window]
Name=New Empty Window
Name[de]=Neues leeres Fenster
Name[es]=Nueva ventana vacía
Name[fr]=Nouvelle fenêtre vide
Name[it]=Nuova finestra vuota
Name[ja]=新しい空のウィンドウ
Name[ko]=새 빈 창
Name[ru]=Новое пустое окно
Name[zh_CN]=新建空窗口
Name[zh_TW]=開新空視窗
Exec=$DIR_PATH/bin/code --new-window %F
Icon=$ICON_PATH" > $DESKTOP_PATH
echo "[Desktop Entry]
Name=Visual Studio Code - URL Handler
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=$DIR_PATH/bin/code --open-url %U
Icon=$ICON_PATH
Type=Application
NoDisplay=true
StartupNotify=true
Categories=Utility;TextEditor;Development;IDE;
MimeType=x-scheme-handler/vscode;
Keywords=vscode;" > $URL_DESKTOP_PATH
chmod +x $DESKTOP_PATH
chmod +x $URL_DESKTOP_PATH
update-desktop-database ~/.local/share/applications

# Gnome shell update
current_favorites=$(gsettings get org.gnome.shell favorite-apps)
current_favorites_cleaned=$(echo "$current_favorites" | sed "s/^\[//" | sed "s/\]//")
new_favorites="$current_favorites_cleaned, '$DESKTOP_NAME'"
new_favorites_wrapped="[$new_favorites]"
gsettings set org.gnome.shell favorite-apps "$new_favorites_wrapped"

# Adding path
echo "export PATH=\$PATH:$DIR_PATH/bin" >> ~/.zshrc
echo "export PATH=\$PATH:$DIR_PATH/bin" >> ~/.bashrc

source ~/.bashrc
source ~/.zshrc
