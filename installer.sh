#!/usr/bin/env bash

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



######### Begin Todo #########
###
### Add alternate user home install location for config and snapshot install
###    https://www.cyberciti.biz/faq/linux-list-users-command/
### Add questionnaire at beginning of script so installer/update can be an answer and walk away setup
### Compile option
### Add OS/Hardware Detection for compile logic and os
###    https://github.com/coto/server-easy-install/blob/master/lib/core.sh
### Detect if coin has already been installed and add logic for update
### Add Security install options such as fail2ban
### Add Firewall Rules
### Add advanced ssh config options
### Add Testnet set up
###
######### For Future Updates #########
###
### Add option to install DNS Seeder
### Add option to install Explorer
### Add option to install Electrum server
### Add email status options
###
######### End Todo #########



### Coin Specific Vars ###
COINNAME=ohmcoin
VERSION=3.0.0
NODENAME=karmanode

### Binary Files ###
BINARY_FILE=$COINNAME-$VERSION-x86_64-linux-gnu.tar.gz
BINARY_URL=https://github.com/theohmproject/ohmcoin/releases/download/
#SOURCE_URL=https://github.com/theohmproject/ohmcoin/archive/
INSTALL_DIR= /usr/local/bin/

### Coin Config Dir ###
CONF_DIR=~/.ohmc/
CONF_FILE=ohmc.conf
PORT=52020
RPCPORT=52021

### Binary names
DAEMON=ohmcoind
CLI=ohmcoin-cli
TX=ohmcoin-tx
QT=ohmcoin-qt

### Snapshot/Boostrap
# needs trailing slash
SNAP_URL=https://ohmcoin.org/downloads/
SNAP_FILE=snapshot.tar.gz

#Dependencies for compile option space separated
#YUM_PACKAGE_NAME=""
#DEB_PACKAGE_NAME=""

######### No need to touch anything below here unless you know what you are doing #########

#Colors
yellow='\033[1;31m'
green='\033[0;32m'
red='\033[0;31m'
nc='\033[0m'


### this script really should switch between users on later updates but will still need sudo to run ###
if [[ $EUID -ne 0 ]]; then
echo -e "${red}Please run as root or use sudo${nc}"
exit 1
fi

### the following could be said in a better way to not be so confusing, but will probably be removed on later updates ###
echo -e "${red}Warning this script assumes it will be running as the same user running this script and will install the $(tr a-z A-Z <<< ${COINNAME:0:1})${COINNAME:1} config files for the executing user${nc}"
sleep 3





# Availbale Options
if [ ! "$#" -ge 1 ]; then
    echo "Usage: $0 {size}"
    echo "(Default path: /var/lib/swap)"
    printf '%s\n' "$@"

	echo "---------------------------------------"
	echo "Available options:"
	printf '%s\n' "$@"
	echo "size - Size of swap ( Example - 1G,2G or 1024M)"
	echo "path - Path to create a swapfile"
    exit 1
fi

SWAP_SIZE=$1

# Default swap file

SWAP_FILE=/var/lib/swap
if [ ! -z "$2" ]; then
    SWAP_FILE="$2"
fi


# Checking if swap already exists in ./etc/fstab
grep -q "swap" /etc/fstab
if ! grep -q "swap" /etc/fstab; then
	 fallocate -l "$SWAP_SIZE" "$SWAP_FILE"
	 chmod 600 "$SWAP_FILE"
	 mkswap "$SWAP_FILE"
	 swapon "$SWAP_FILE"
	echo "$SWAP_FILE   none    swap    sw    0   0" |  tee /etc/fstab -a
else
	echo 'swapfile found. No changes made.'
fi

echo '----------------------'
echo 'Checking list of swap'
echo '----------------------'
swapon -s


echo -e "Downloading Binaries"

  curl -O $BINARY_URL$COMP_FILE

echo -e "Installing $(tr a-z A-Z <<< ${COINNAME:0:1})${COINNAME:1}"
  tar xvzf -C $BINARY_FILE $INSTALL_DIR

echo -e "Configuring IP - Please Wait......."

  declare -a NODE_IPS
  for ips in $(netstat -i | awk '!/Kernel|Iface|lo/ {print $1," "}')
  do
  NODE_IPS+=($(curl --interface $ips --connect-timeout 2 -s4 icanhazip.com))
  done

  if [ ${#NODE_IPS[@]} -gt 1 ]; then
     echo -e "${yellow}Please enter the number of which ip you would like to use${nc}"
     INDEX=0
     for ip in "${NODE_IPS[@]}"
     do
     echo ${INDEX} $ip
     let INDEX=${INDEX}+1
     done
     read -e choose_ip
     IP=${NODE_IPS[$choose_ip]}
     else
     IP=${NODE_IPS[0]}
  fi

   echo -e "IP Done"
   echo ""

   mkdir -p $CONF_DIR
   echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` > $CONF_DIR/$CONF_FILE
   echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
   echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
   echo "rpcport=$RPCPORT" >> $CONF_DIR/$CONF_FILE
   echo "listen=1" >> $CONF_DIR/$CONF_FILE
   echo "server=1" >> $CONF_DIR/$CONF_FILE
   echo "daemon=1" >> $CONF_DIR/$CONF_FILE
   echo "logtimestamps=1" >> $CONF_DIR/$CONF_FILE
   echo "$NODENAME=1" >> $CONF_DIR/$CONF_FILE
   echo "port=$PORT" >> $CONF_DIR/$CONF_FILE
   echo "$NODENAMEaddr=$IP:$PORT" >> $CONF_DIR/$CONF_FILE

echo -e "${yellow}Is this a $NODENAME install? [y/n]${nc}"
read DOSETUPKN

if [[ $DOSETUPKN =~ "y" ]] ; then
   echo "${yellow}Enter $NODENAME private key${nc}"
   read PRIVKEY
   echo "$NODENAMEprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE
 fi


echo -e "${yellow}Would you like to install the snapshot/bootstrap? [y/n]${nc}"
read DOSETUPSNAP

if [[ $DOSETUPSNAP =~ "y" ]] ; then
  curl -O $SNAP_URL$SNAP_FILE
  tar xvzf -C $SNAP_FILE $CONF_DIR
  ### clean up ###
  rm $SNAP_FILE
fi


   echo -e "${yellow}Cleaning up{nc}"
   rm $BINARY_FILE

   echo -e "${yellow}You may start your node with the following command${nc}"
   sleep 1
   echo ""
   echo "$DAEMON -daemon"

   sleep 1
   echo " "
   echo -e "${red}P.S. I deleted myself${nc}"
   echo " "
rm $0








