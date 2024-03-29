#!/bin/bash
#
# Created by Andre Carvalho on 5th January 2024
# Last modified: 9th January 2024
#
# Custom banner for a DietPi installation
#
readonly DIETPI_GREEN='\e[38;5;154m'
readonly BOLD_WHITE='\e[1m'
readonly DIETPI_GREY='\e[90m'
readonly RESET='\e[0m'

sdCardValue=$(echo -e " ${DIETPI_GREEN}-${RESET} ${BOLD_WHITE}SD Card usage${RESET} ${DIETPI_GREEN}:${RESET} $(df -h --output=used,size,pcent / | mawk 'NR==2 {printf $1" / "$2" ("$3"%)"}' 2>&1)")
diskValue=$(echo -e " ${DIETPI_GREEN}-${RESET} ${BOLD_WHITE}Hard drive(s) usage${RESET} ${DIETPI_GREEN}:${RESET} $(df -h -x aufs -x tmpfs -x overlay -x drvfs -x devtmpfs  --total | grep "total" | mawk '{printf $3" / "$2" ("$5"%)"}' 2>&1)")
ramValue=$(echo -e " ${DIETPI_GREEN}-${RESET} ${BOLD_WHITE}RAM usage${RESET} ${DIETPI_GREEN}:${RESET} $(free -h --si | mawk 'NR==2 {printf $3" / "$2}' 2>&1)")
ramPercentage="$(free -b | mawk 'NR==2 {printf "%.0f", 100*$3/$2}' 2>&1)"

output=""

while IFS= read -r line; do
        transformedLine="$line"

        if [[ "$transformedLine" == *"CPU temp"* ]]; then
                IFS='//' read -ra celsius <<< "$transformedLine"
                IFS=':' read -ra message <<< "${celsius[1]}"
                tempValue="${celsius[0]}${DIETPI_GREY}:${message[1]}${RESET}"

                transformedLine="${tempValue}\n${ramValue} (${ramPercentage}%)\n${sdCardValue}\n${diskValue}"
        fi

        output="${output}${transformedLine}\n"
done <<<"$(/boot/dietpi/func/dietpi-banner 1)"

echo -e "${output}"
