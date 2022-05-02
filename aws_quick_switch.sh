#!/bin/bash
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BIGBLUE='\033[1;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

VERBOSE=0

AWS_CRED="/home/${USER}/.aws/credentials"
AWS_CONF="/home/${USER}/.aws/config"

declare PROF_CREDENTIALS
declare PROF_CONFIG
declare PROFILES

declare -A N_PROFILES
N=0


################################################################################
# CHECK ARGUMENTS
################################################################################

while getopts 'v' flag; do
  case "${flag}" in
    v) VERBOSE=1 ;;
    #x) x="${OPTARG}" ;;
    #*) print_usage
  esac
done

################################################################################
# FUNCTIONS
################################################################################

get_profiles() {
    for credential in $(cat $AWS_CRED | grep -oP "(?<=\[).*(?=\])" ); do
        PROF_CREDENTIALS+=("${credential}")
    done    

    PROFILE=""
    SOURCE_PROFILE=""
    while read -r line ; do
    
    T_PROFILE=$(echo $line | grep -Po  "(?<=\[profile ).*(?=\])")
    if [ ! -z $T_PROFILE ]; then 
        PROFILE=$T_PROFILE
    fi

    T_SOURCE_PROFILE=$(echo $line | grep -Po "(?<=source_profile\ =\ ).*")
    if [ ! -z $T_SOURCE_PROFILE ]; then 
        SOURCE_PROFILE=$T_SOURCE_PROFILE
    fi

    if [ ! -z $PROFILE ] && [ ! -z $SOURCE_PROFILE ]; then
        PROF_CONFIG+=("$PROFILE>$SOURCE_PROFILE")
        PROFILE=""
        SOURCE_PROFILE=""
    fi

    done < <(cat $AWS_CONF | grep -P -A3 "(?<=\[profile ).*(?=\])")

    PROFILES=( ${PROF_CONFIG[@]} ${PROF_CREDENTIALS[@]} )

    IFS=$'\n' PROFILES=($(sort <<<"${PROFILES[*]}"))
    unset IFS
}


print_profiles() {
    if [ "$#" -gt 0 ] && [ $1 == "source" ]; then
        for k in "${!PROFILES[@]}"; do
            if [[ ${PROFILES[$k]} == *\>* ]]; then
                prof=$(echo "${PROFILES[$k]}" | cut -d ">" -f 1)
                source=$(echo "${PROFILES[$k]}" | cut -d ">" -f 2)
                #p="${YELLOW}$prof${GREEN} -> ${BIGBLUE}$source${NC}\n"
                printf "${YELLOW}%s-${GREEN}%s${BLUE} -> ${BIGBLUE}%s${NC}\n" "$k" "$prof" "$source"
            else
                printf "${YELLOW}%s-${GREEN}%s${NC}\n" "$k" "${PROFILES[$k]}"
            fi
        done
    else
        for k in "${!PROFILES[@]}"; do
            printf "${YELLOW}%s-${GREEN}%s${NC}\n" "$k" "${PROFILES[$k]}" ;
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


for profile in "${PROFILES[@]}"; do
	N_PROFILES[${N}]=${profile}
	N=$(( N + 1 ))
done


if [ -z $1 ] || [ $VERBOSE -eq 1 ]
then
	printf "${YELLOW}AWS profiles:\n${NC}"
    if [ $VERBOSE -eq 1 ]; then
        print_profiles source
    else
        print_profiles
    fi
fi



if [[ $1 =~ ^[0-9]+$ ]] && [  $1 -le ${N} ]
then
	echo "export AWS_PROFILE=$(get_profile_by_index $1)"
fi