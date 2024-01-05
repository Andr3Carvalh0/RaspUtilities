#!/bin/bash
#
# Created by André Carvalho on 5th January 2024
# Last modified: 5th January 2024
#
# Initializes everything you need
#
readonly SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Override login banner
touch ~/.hushlogin # Disable default login message
mkdir -p "/boot/utilities" && cp "${SCRIPT_DIRECTORY}/rasp-banner.sh" "/boot/utilities/"
echo "if [[ -n \$SSH_CONNECTION ]] ; then
        clear && /boot/utilities/rasp-banner.sh
fi" >> ~/.bashrc