#!/usr/bin/env bash
set -e

#Copyright (c) 2018 - 2020 The Ohmcoin developers
#maintained and created by A. LaChasse rasalghul at ohmcoin dot org

#The MIT License (MIT)

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

######### User Vars #########
# Change to '0' to keep backup!
REMOVE_BACKUP=1

######### Pre 3.0 Coin Specific Vars (deprecated, will be removed) #########
PRE_DAEMON="ohmcd"
PRE_CLI="ohmc-cli"
PRE_TX="ohmc-tx"
######### Pre 3.0 Coin Specific Vars (deprecated, will be removed) #########

### Coin Specific Vars ###
COINNAME="ohmcoin"
VERSION="3.0.2"
NODENAME="Karmanode"

### Binary Files ###
BINARY_FILE="$COINNAME-$VERSION-x86_64-linux-gnu.tar.gz"
BINARY_URL="https://github.com/theohmproject/ohmcoin/releases/download/$VERSION/"
#SOURCE_URL="https://github.com/theohmproject/ohmcoin/archive/"
INSTALL_DIR="/usr/local/bin"
TEMP_DIR="/tmp/ohmcoin"

### Binary names
DAEMON="ohmcoind"
CLI="ohmcoin-cli"
TX="ohmcoin-tx"
#QT="ohmcoin-qt"

######### No need to touch anything below here unless you know what you are doing #########

#Colors
gold='\033[0;33m'
yellow='\033[1;33m'
green='\033[1;32m'
dark_green='\033[0;32m'
red='\033[1;31m'
dark_red='\033[0;31m'
gray='\033[1;30m'
nc='\033[0m'

#Functions
function fileExist() {
  if [ -f "$1" ]; then
    echo "Exists!"
  fi
}

#Main..
cd ~
echo -e "${red}> ${nc}${yellow}ATTENTION!!!${nc}"
echo -e "${red}>> ${nc}${dark_red}This Script will stop your daemon and install a new version of $COINNAME!${nc}"
echo -e "${red}>> ${nc}${dark_red}Press CTRL+C now, to abort and cancel ${nc}${gold}(you have 6 seconds)${nc}"

if [[ $EUID -ne 0 ]] ; then
echo -e "${dark_red}Please run as root or use sudo${nc}" 2>&1
exit 1
fi

sleep 5
echo -e "${red}...${nc}"
sleep 1

### Check for older version ###
PRE_VERSION_FOUND=0
resp=$(fileExist "$INSTALL_DIR/$PRE_DAEMON")
if [[ $resp == "Exists!" ]]; then
  PRE_VERSION_FOUND=1
  echo -e "${yellow}Pre $COINAME $VERSION is installed.${nc}"
  echo -e "${dark_green}Stopping $COINNAME daemon...${nc}"
  $PRE_CLI stop && sleep 10 || echo -e "${gray}> Daemon Already Stopped--${nc}"
  echo -e "${gold}Backing up old daemon incase of script bomb${nc}"
  sleep 3

  resp=$(fileExist "$INSTALL_DIR/$PRE_DAEMON")
  if [[ $resp == "Exists!" ]]; then
    mkdir $INSTALL_DIR/backup || echo -e "${gold}> Backup Directory Already Exists!${nc}"
    mv $INSTALL_DIR/$PRE_DAEMON $INSTALL_DIR/backup/ || echo -e "${red}> Move Failed!${nc}"
    mv $INSTALL_DIR/$PRE_CLI $INSTALL_DIR/backup/ || echo -e "${red}> Move Failed!${nc}"
    mv $INSTALL_DIR/$PRE_TX $INSTALL_DIR/backup/ || echo -e "${red}> Move Failed!${nc}"
    resp=$(fileExist "$INSTALL_DIR/backup/$PRE_DAEMON")
    if [[ $resp == "Exists!" ]]; then
      echo -e "${green}Backup Complete!${nc}"
    fi
  else
    echo -e "${red}Backup Failed..  Assets not found???${nc}"
  fi

### Post 3.0.0 Update ###
else
  echo -e "${dark_green}Stopping $COINNAME daemon...${nc}"
  $CLI stop && sleep 10 || echo -e "${gray}Daemon Already Stopped..${nc}"
  echo -e "${yellow}Backing up old daemon incase of script bomb${nc}"
  sleep 3

  resp=$(fileExist "$INSTALL_DIR/$DAEMON")
  if [[ $resp == "Exists!" ]]; then
    mkdir $INSTALL_DIR/backup || echo -e "${gold}> Backup Directory Already Exists!${nc}"
    mv $INSTALL_DIR/$DAEMON $INSTALL_DIR/backup/ || echo -e "${red}> Move Failed!${nc}"
    mv $INSTALL_DIR/$CLI $INSTALL_DIR/backup/ || echo -e "${red}> Move Failed!${nc}"
    mv $INSTALL_DIR/$TX $INSTALL_DIR/backup/ || echo -e "${red}> Move Failed!${nc}"
    resp=$(fileExist "$INSTALL_DIR/backup/$DAEMON")
    if [ $resp == "Exists!" ]; then
      echo -e "${green}Backup Complete!${nc}"
    fi
  else
    echo -e "${red}Backup Failed.. Version 3.x Assets not found.${nc}"
  fi
fi

### Install ###
echo -e "${yellow}Downloading $(tr a-z A-Z <<< ${COINNAME:0:1})${COINNAME:1} binaries...${nc}"

mkdir $TEMP_DIR && echo "..."
cd $TEMP_DIR
wget $BINARY_URL$BINARY_FILE || echo -e "${red}Download Failed!!  Aborting..${nc}" || exit 1

echo -e "${yellow}Updating $(tr a-z A-Z <<< ${COINNAME:0:1})${COINNAME:1} daemon files...${nc}"
sleep 3

tar -xvzf $BINARY_FILE -C $INSTALL_DIR

resp=$(fileExist "$INSTALL_DIR/$DAEMON")
if [[ $resp != "Exists!" ]]; then
  echo -e "${dark_red}Install Failed!!  ${nc}${red}Something went terribly wrong, Aborting..${nc}"
  exit 1
fi

### Laser Cleanup ###
echo -e "${green}+====================+${nc}"
echo -e "${green}$(tr a-z A-Z <<< ${COINNAME:0:1})${COINNAME:1} files updated!${nc}"
sleep 2

echo -e "${gold}Charging laser weapons${nc}"
sleep 3

echo -e "${yellow}Acquiring target${nc}"
sleep 2
echo -e "${gray}.${nc}"
sleep 1
echo -e "${gray}.${nc}"
sleep 1
echo -e "${gold}Target Acquired... preparing to destroy backup and tmp files${nc}"
sleep 3

echo  -e "${dark_green}Firing all lasers${nc}"
sleep 1

if [ $PRE_VERSION_FOUND -eq 1 ]; then
  rm $INSTALL_DIR/$PRE_DAEMON && rm $INSTALL_DIR/$PRE_CLI && rm $INSTALL_DIR/$PRE_TX && echo -e "${dark_red}> Pre 3.x Version Destroyed!${nc}"
fi
firesp=$(fileExist "$INSTALL_DIR/readme.txt")
if [[ $resp != "Exists!" ]]; then
   rm "$INSTALL_DIR/readme.txt" && echo -e "${dark_red}> Legacy Readme Destroyed!${nc}"
fi
if [ $REMOVE_BACKUP -eq 1 ]; then
  rm -r $INSTALL_DIR/backup
fi

echo -e "${red}Target destroyed${nc}"
sleep 2

echo " "
echo " "
echo -e "${green}You may now start the $(tr a-z A-Z <<< ${COINNAME:0:1})${COINNAME:1} daemon normally ie.${nc}"
sleep 3

echo " "
echo  -e "${dark_green}$DAEMON -daemon ${nc}"
echo " "
sleep 3
echo -e "${dark_red}Please make sure to restart your $NODENAME in your controller wallet to complete the upgrade process${nc}"

sleep 4
echo " "
echo -e "${gray}P.S. I delete myself${nc}"

rm -r $TEMP_DIR || echo "> TMP dir gone already.."
cd ~
rm $(echo "$0" | sed -e 's/[^A-Za-z0-9._-/]//g') || echo -e "${gray}..or not.${nc}" && echo -e "${gray}o/${nc}"

echo " "
# fin
