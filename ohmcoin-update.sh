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

######### Pre 3.0 Coin Specific Vars (will be removed) #########
PRE_DAEMON=ohmcoind
PRE_CLI=ohmcoin-cli
PRE_TX=ohmcoin-tx
######### Pre 3.0 Coin Specific Vars (will be removed) #########

### Coin Specific Vars ###
COINNAME=ohmcoin
VERSION=3.0.2
NODENAME=Karmanode

### Binary Files ###
BINARY_FILE=$COINNAME-$VERSION-x86_64-linux-gnu.tar.gz
BINARY_URL=https://github.com/theohmproject/ohmcoin/releases/download/
#SOURCE_URL=https://github.com/theohmproject/ohmcoin/archive/
INSTALL_DIR=/usr/local/bin/

### Binary names
DAEMON=ohmcoind
CLI=ohmcoin-cli
TX=ohmcoin-tx
#QT=ohmcoin-qt

######### No need to touch anything below here unless you know what you are doing #########

#Colors
yellow='\033[1;31m'
green='\033[0;32m'
red='\033[0;31m'
nc='\033[0m'

if [[ $EUID -ne 0 ]] ; then
echo -e "${red}Please run as root or use sudo${nc}" 2>&1
exit 1
fi

### Check for older version ###
if ! [ -x "$(command -v $PRE_DAEMON)" ]; then
  echo -e "Pre $(tr a-z A-Z <<< ${COINNAME:0:1})${COINNAME:1} $VERSION is installed."
  $PRE_CLI stop
  echo -e "${yellow}Backing up old daemon incase of script bomb${nc}"
  sleep 30

  mkdir "$INSTALL_DIR"backup
  mv $INSTALL_DIR$PRE_DAEMON "$INSTALL_DIR"backup/
  mv $INSTALL_DIR$PRE_CLI "$INSTALL_DIR"backup/
  mv $INSTALL_DIR$PRE_TX "$INSTALL_DIR"backup/

### Post 3.0.0 Update ###
  else $CLI stop
  echo -e "${yellow}Backing up old daemon incase of script bomb${nc}"
  sleep 30

  mkdir "$INSTALL_DIR"backup
  mv $INSTALL_DIR$DAEMON "$INSTALL_DIR"backup/
  mv $INSTALL_DIR$CLI "$INSTALL_DIR"backup/
  mv $INSTALL_DIR$TX "$INSTALL_DIR"backup/
fi

echo "${yellow}Downloading $(tr a-z A-Z <<< ${COINNAME:0:1})${COINNAME:1} binaries${nc}"

  curl -O "$BINARY_UR"L$COMP_FILE

echo "${yellow}Updating $(tr a-z A-Z <<< ${COINNAME:0:1})${COINNAME:1} daemon files${nc}"
sleep 3

  tar xvzf -C $BINARY_FILE $INSTALL_DIR


echo -e "${green}$(tr a-z A-Z <<< ${COINNAME:0:1})${COINNAME:1} files updated${nc}"
sleep 3

echo -e "${yellow}Charging laser weapons${nc}"
sleep 3

echo -e "${yellow}Acquiring target${nc}"
sleep 3

echo -e "${yellow}Target Acquired... preparing to destroy backup and tmp files${nc}"
sleep 3

echo  -e "${yellow}Firing all lasers${nc}"
sleep 3

rm -rf "$INSTALL_DIR"backup "$INSTALL_DIR"readme.txt $BINARY_FILE

echo -e "${red}Target destroyed${nc}"
sleep 3

echo -e "${green}You may now start the $(tr a-z A-Z <<< ${COINNAME:0:1})${COINNAME:1} daemon normally ie.${nc}"
sleep 3

echo " "
echo  -e "${red}$DAEMON -daemon ${nc}"
echo " "
sleep 3
echo -e "${red}Please make sure to restart your $NODENAME in your controller wallet to complete the upgrade process${nc}"

sleep 3
echo " "
echo -e "${red}P.S. I delete myself${nc}"
echo " "
rm $0
