#!/bin/bash
#
# Created by Andre Carvalho on 5th January 2024
# Last modified: 5th January 2024
#
# Custom banner for a DietPi installation
#
readonly DIETPI_GREEN='\e[38;5;154m'
readonly BOLD_WHITE='\e[1m'
readonly RESET='\e[0m'

bannerOutput=$(/boot/dietpi/func/dietpi-banner 1)
screenfetchOutput=$(screenfetch -n -N)

diskValue=$(echo "$screenfetchOutput" | grep "Disk")
diskValue=$(echo -e "${diskValue/Disk:/${DIETPI_GREEN}-${RESET} ${BOLD_WHITE}Hard drive(s)${RESET} ${DIETPI_GREEN}:${RESET}}")

ramValue=$(echo "$screenfetchOutput" | grep "RAM")
ramValue=$(echo -e "${ramValue/RAM:/${DIETPI_GREEN}-${RESET} ${BOLD_WHITE}RAM${RESET} ${DIETPI_GREEN}:${RESET}}")

processedValue=$(echo "${bannerOutput/Freespace (RootFS)/SD card}")

output=""

while IFS= read -r line; do
        transformedLine="$line"

        if [[ "$transformedLine" == *"SD card"* ]]; then
                totalSize=$(df -h --output=size / | mawk 'NR==2 {print $1}' 2>&1)
                percentage=$(df -h --output=pcent / | mawk 'NR==2 {print $1}' 2>&1)
                transformedLine="${transformedLine} / ${totalSize} ($percentage)\n${diskValue}"
        fi

        if [[ "$transformedLine" == *"CPU temp"* ]]; then
                transformedLine="${transformedLine}\n${ramValue}"
        fi

        if [[ -z $output ]]; then
                output="${transformedLine}"
        else
                output="${output}\n${transformedLine}"
        fi
done <<<"$processedValue"

echo -e "${output}\n"
