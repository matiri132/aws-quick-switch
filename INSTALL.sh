#!/bin/bash
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BIGBLUE='\033[1;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'


INSTALL_DIR="/home/$USER/.local/bin"
SCRIPT="aws-quick-switch"
COMPLETION="aws-quick-switch-completion"
SOURCE="/home/$USER/.zshrc"

SUCCESS=0

if [ -f "$INSTALL_DIR/$SCRIPT" ]; then
    cp "$SCRIPT" "$INSTALL_DIR"/"$SCRIPT"
    chmod +x "$INSTALL_DIR"/"$SCRIPT"
    printf "${GREEN}AWS Quick Switch Updated successfully...${NC}\n"

else
    if [ -f "$INSTALL_DIR/aws_quick_switch.sh" ]; then

        printf "${YELLOW}Previous version found, this will remove old files and update ~/.zshrc. Continue?${GREEN} y/n ${NC}\n"
        read k
        if [ ${k} = 'y' ]
        then
            rm "$INSTALL_DIR/aws_quick_switch.sh"
            sed '/alias aws-sp/d' $SOURCE > zshrc.backup
            cat zshrc.backup > $SOURCE
            printf "${GREEN}AWS Quick Switch Previous version ${RED}Removed${GREEN} successfully...${NC}\n"
            
        fi
    fi
    
    cp "$SCRIPT" "$INSTALL_DIR"/"$SCRIPT"

    chmod +x "$INSTALL_DIR"/"$SCRIPT"
    
    printf "${GREEN}AWS Quick Switch Installed successfully...${NC}\n"
    
    echo "" >> ${SOURCE}
    echo "alias aws-sp='function a(){if [ ! -z \$1 ];then \$(aws-quick-switch \$1); else; aws-quick-switch; fi;  };a'" >> ${SOURCE}
    printf "${GREEN}Added ALIAS for aws-sp in ${YELLOW}$SOURCE${YELLOW}...${NC}\n"
    printf "${YELLOW}This action needs a terminal restart to take effect${NC}\n"

fi


if [ ! -f "$INSTALL_DIR/$COMPLETION" ]; then
    printf "${YELLOW}Do you want to install autocomplete for aws-sp? (This will ~/.zshrc)${GREEN} y/n${NC} \n"
    read k
    if [ ${k} = 'y' ]; then
        cp "$COMPLETION" "$INSTALL_DIR"/"$COMPLETION"
        echo "source ${INSTALL_DIR}/${COMPLETION}" >> ${SOURCE}
        echo "setopt completealiases" >> ${SOURCE}
        printf "${GREEN}Autocompletion for aws-sp installed successfully ...${NC}\n"
        printf "${YELLOW}This action needs a terminal restart to take effect${NC}\n"
    fi
fi


