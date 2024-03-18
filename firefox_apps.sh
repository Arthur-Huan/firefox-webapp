#!/bin/bash    
firefox -CreateProfile "$1"    
touch "$HOME/.local/share/applications/$1.desktop"
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=$1
Exec=firefox --name=$1 --class $1 --no-remote -P $1 -url=$2
StartupWMClass=$1
Icon=$1
" >> "$HOME/.local/share/applications/$1.desktop"

cd $HOME/.mozilla/firefox/"$(grep 'Path=' ~/.mozilla/firefox/profiles.ini | sed s/^Path=// | grep "$1")"
touch user.js
echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> user.js
echo 'user_pref("browser.tabs.inTitlebar", 0);' >> user.js
mkdir chrome
cd chrome
touch userChrome.css
echo "#TabsToolbar {visibility: collapse;}
#navigator-toolbox {visibility: collapse;}
" >> userChrome.css

#!/bin/bash

# Ask the user if they want to edit the .desktop file
read -p "Do you want to edit the desktop file? [y/n] (n): " answer

# Check if the answer is 'y' or 'Y'
if [[ $answer = y ]] || [[ $answer = Y ]]
then
	${EDITOR:-vi} "$HOME/.local/share/applications/$1.desktop"
else
    echo "Aborted."
fi
