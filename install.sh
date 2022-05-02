#!/bin/bash
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BIGBLUE='\033[1;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'


INSTALL_DIR="/home/$USER/.local/bin"
SCRIPT="aws_quick_switch.sh"
SOURCE="/home/$USER/.zshrc"

if [ -f "$INSTALL_DIR/aws_quick_switch.sh" ]; then
    cp "$SCRIPT" "$INSTALL_DIR"/aws_quick_switch.sh
    chmod +x "$INSTALL_DIR"/"$SCRIPT"
    printf "${GREEN}AWS Quick Switch Updated successfully...${NC}\n"
    exit 0
else
    cp "$SCRIPT" "$INSTALL_DIR"/aws_quick_switch.sh
    chmod +x "$INSTALL_DIR"/"$SCRIPT"
    printf "${GREEN}AWS Quick Switch Installed successfully...\n"
    echo "alias aws_sp='function a(){if [ ! -z \$1 ];then \$(aws_quick_switch.sh \$1); else; aws_quick_switch.sh; fi;  };a'" >> ${SOURCE}
    printf "${GREEN}Added ALIAS for aws_sp in ${YELLOW}$SOURCE${YELLOW}...${NC}\n"
fi


