# zestyWin - [Download](https://github.com/w0lfschild/SIMBLPlugins/raw/master/zestyWin/zestyWin.zip)

![preview](zestyWin.png) 

# Information:

- Designed for 10.10+
- Author: [w0lfschild](https://github.com/w0lfschild)

# Functions:

- Tries to add Vibrancy to every application window on OS X 10.10+

# Installation:

1. Install [SIMBL](https://github.com/w0lfschild/SIMBLPlugins/tree/master/SIMBLInstaller)
2. Download zestyWin bundle
3. Unzip download
4. Copy to ``/Library/Application Support/SIMBL/Plugins``
5. Restart applications to have zestWin plugin loaded into them

# Warnings:

- Some applications may look bad or crash
- Applications that do no use NSWindow will not be effected
- To blacklist zestyWin from loading for an app add that app bundle ID to the zestyWin preference file
- You can accomplish this by running the following terminal command (replace Steam with your app):
    - `defaults write com.w0lf.zestyWin $(osascript -e 'id of app "Steam"') 0`
- Automatically blacklisted applications include:
    - Finder 
    - TextEdit
    - iTunes
    - Terminal
    - Sublime Text