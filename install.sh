#!/bin/bash

set -e -u -o pipefail

pwd=$(pwd)

apt install imagemagick python3-pip

pip3 install nxbt

cd /home/*/.local/share/applications

echo "
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Printoon
Comment=Printoon
Exec=$pwd/gui.sh
Terminal=false
" > Printoon.desktop

chmod +x Printoon.desktop

echo "Printoon installation complete."
