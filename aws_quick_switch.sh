#!/bin/bash
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BIGBLUE='\033[1;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

AWS_CRED="/home/${USER}/.aws/credentials"
AWS_CONF="/home/${USER}/.aws/config"

declare -A CREDS
N=0

if [ -z $1 ]
then
	printf "${GREEN}AWS profiles:\n${NC}"
fi

for profile in $(cat $AWS_CRED | grep -oP "(?<=\[).*(?=\])" )
do
	if [ -z $1 ]
	then
		printf "${YELLOW} ${N}-${profile}\n${NC}"
	fi
	CREDS[${N}]=${profile}
	N=$(( N + 1 ))
done


for profile in $(cat $AWS_CONF | grep -oP "(?<=\[profile ).*(?=\])" )
do
	if [ -z $1 ]
	then
		printf "${YELLOW} ${N}-${profile}\n${NC}"
	fi
	CREDS[${N}]=${profile}
	N=$(( N + 1 ))
done

if [ ! -z $1 ] && [  $1 -le ${N} ]
then
	echo "export AWS_PROFILE=${CREDS[$1]}"
fi

	


