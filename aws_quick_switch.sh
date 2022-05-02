#!/bin/bash
################################################################################
# CONFIG
################################################################################
AWS_CRED="/home/${USER}/.aws/credentials"
AWS_CONF="/home/${USER}/.aws/config"
VERBOSE=1

################################################################################
# USEFULL VARIABLES
################################################################################
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BIGBLUE='\033[1;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

INFO=0

declare PROF_CREDENTIALS
declare PROF_CONFIG
declare PROFILES

################################################################################
# CHECK ARGUMENTS
################################################################################

if [[ ${#} -eq 0 ]]; then
   INFO=1
fi

################################################################################
# FUNCTIONS
################################################################################

get_profiles() {
  
	while read -r line; do
		PROF_CREDENTIALS+=("${line}")
	done < <(cat $AWS_CRED | grep -oP "(?<=\[).*(?=\])" )

    PROFILE=""
    SOURCE_PROFILE=""
    while read -r line ; do  
		T_PROFILE=$(echo "${line}" | grep -Po  "(?<=\[profile ).*(?=\])")
		if [ -n "${T_PROFILE}" ]; then 
			PROFILE=$T_PROFILE
		fi

		T_SOURCE_PROFILE=$(echo "${line}" | grep -Po "(?<=source_profile\ =\ ).*")
		if [ -n "${T_SOURCE_PROFILE}" ]; then 
			SOURCE_PROFILE=$T_SOURCE_PROFILE
		fi

		if [ -n "${PROFILE}" ] && [ -n "${SOURCE_PROFILE}" ]; then
			PROF_CONFIG+=("${PROFILE}>${SOURCE_PROFILE}")
			PROFILE=""
			SOURCE_PROFILE=""
		fi
    done < <(cat "$AWS_CONF" | grep -P -A3 "(?<=\[profile ).*(?=\])")

    PROFILES=( "${PROF_CONFIG[@]}" "${PROF_CREDENTIALS[@]}" )

    IFS=$'\n' PROFILES=($(sort <<<"${PROFILES[*]}"))
    unset IFS
}

print_numbered_profiles() {
	printf "${YELLOW}AWS profiles:${NC}\n"
    if [ "$#" -gt 0 ] && [ "$1" == "source" ]; then
        for k in "${!PROFILES[@]}"; do
            if [[ ${PROFILES[$k]} == *\>* ]]; then
                prof=$(echo "${PROFILES[$k]}" | cut -d ">" -f 1)
                source=$(echo "${PROFILES[$k]}" | cut -d ">" -f 2)
                printf "${YELLOW}%s-${GREEN}%s${BLUE} -> ${BIGBLUE}%s${NC}\n" "$k" "$prof" "${source}"
            else
                printf "${YELLOW}%s-${GREEN}%s${NC}\n" "$k" "${PROFILES[$k]}" 
            fi
        done
    else
        for k in "${!PROFILES[@]}"; do
            printf "${YELLOW}%s-${GREEN}%s${NC}\n" "$k" "${PROFILES[$k]}" | cut -d ">" -f 1
        done
    fi
} 

get_profile_by_index () {
    echo "${PROFILES[$1]}" | cut -d ">" -f 1
}

################################################################################
# MAIN
################################################################################

get_profiles


if [ $INFO -eq 1 ]
then
    if [ $VERBOSE -eq 1 ]; then
        print_numbered_profiles source
    else
        print_numbered_profiles
    fi
fi



if [[ "$1" =~ ^[0-9]+$ ]] && [  "$1" -le "${#PROFILES[@]}" ]
then
	echo "export AWS_PROFILE=$(get_profile_by_index ${1})"
fi
