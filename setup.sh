#!/usr/bin/bash

# Function definations
add_keybinding() {
    local new_keybinding="$1"
    local keybindings_file="$HOME/.config/Code/User/keybindings.json"

    if [[ ! -f "$keybindings_file" ]]; then
        echo "[]" > "$keybindings_file"
    fi

    local content
    content=$(grep -v '^//' "$keybindings_file" | tr -d '\n' | tr -d '\r')

    content=$(echo "$content" | tr -d '\n' | tr -d '\r')

    if [[ "$content" == "[]" ]]; then
        echo "[$new_keybinding]" > "$keybindings_file"
    else
        if [[ "$content" =~ \]$ ]]; then
            content="${content%?}"
            echo "$content,$new_keybinding]" > "$keybindings_file"
        else
            echo "$content$new_keybinding]" > "$keybindings_file"
        fi
    fi
}

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

KEY_C='{"key": "meta+c","command": "workbench.action.terminal.copySelection","when": "terminalTextSelectedInFocused || terminalFocus && terminalHasBeenCreated && terminalTextSelected || terminalFocus && terminalProcessSupported && terminalTextSelected || terminalFocus && terminalTextSelected && terminalTextSelectedInFocused || terminalHasBeenCreated && terminalTextSelected && terminalTextSelectedInFocused || terminalProcessSupported && terminalTextSelected && terminalTextSelectedInFocused"}'
KEY_C_REMOVE='{"key": "ctrl+shift+c","command": "-workbench.action.terminal.copySelection","when": "terminalTextSelectedInFocused || terminalFocus && terminalHasBeenCreated && terminalTextSelected || terminalFocus && terminalProcessSupported && terminalTextSelected || terminalFocus && terminalTextSelected && terminalTextSelectedInFocused || terminalHasBeenCreated && terminalTextSelected && terminalTextSelectedInFocused || terminalProcessSupported && terminalTextSelected && terminalTextSelectedInFocused"}'

KEY_V='{"key": "meta+v","command": "workbench.action.terminal.paste","when": "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported"}'
KEY_V_REMOVE='{"key": "ctrl+shift+v","command": "-workbench.action.terminal.paste","when": "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported"}'

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

# Key bindings
add_keybinding "$KEY_C"
add_keybinding "$KEY_C_REMOVE"
add_keybinding "$KEY_V"
add_keybinding "$KEY_V_REMOVE"
