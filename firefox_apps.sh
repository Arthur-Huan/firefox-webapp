#!/bin/bash

# Parse the arguments, either `url name` or `url name displayName`
if [[ $# -eq 2 ]]; then
    url="$1"
    name="$2"
    displayName="$2"
elif [[ $# -eq 3 ]]; then
    url="$1"
    name="$2"
    displayName="$3"
else
    echo 'Invalid arguments.'
fi

# Create a new profile and customize
firefox -CreateProfile $name
cd $HOME/.mozilla/firefox/"$(grep 'Path=' ~/.mozilla/firefox/profiles.ini | sed s/^Path=// | grep "$name")"
touch user.js
echo 'user_pref("browser.tabs.inTitlebar", 0);' >> user.js
# Manipulate userChrome to hide the tab bar
echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> user.js
mkdir chrome
cd chrome
touch userChrome.css
echo "#TabsToolbar {visibility: collapse;}
#navigator-toolbox {visibility: collapse;}
" >> userChrome.css

# Write respective .desktop file
touch "$HOME/.local/share/applications/$name.desktop"
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=$displayName
Exec=firefox --name=$name --class $name --no-remote -P $name -url=$url
StartupWMClass=$name
Icon=$name 
" >> "$HOME/.local/share/applications/$name.desktop"

echo "Process finished."
