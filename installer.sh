#!/usr/bin/env bash
set -e

#Copyright (c) 2018 - 2020 The Ohmcoin developers
#maintained and created by A. LaChasse rasalghul at ohmcoin.org

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
### Add questionnaire at beginning of script so installer/update can be an answer and walk away setup
### Compile option logic
### Detect if coin has already been installed and add logic for update
### Add Security install options such as fail2ban
### Add advanced ssh config options
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
COINNAME=Ohmcoin
NODENAME=karmanode
VERSION=
BINARYURL=https://github.com/theohmproject/ohmcoin/releases/download
#SOURCEURL= For when compile logic is added

### Coin Config Dir ###
CONF_DIR=~/.ohmc/
CONF_FILE=ohmc.conf
PORT=52020
RPCPORT=52021

### Binary names
DAEMON=ohmcoind
CLI=ohmcoin-cli
TX=ohmcoin-tx

### Snapshot/Boostrap
SNAPURL=


#Dependencies for compile option space separated
#YUM_PACKAGE_NAME=""
#DEB_PACKAGE_NAME=""

######### No need to touch anything below here unless you know what you are doing #########

#Colors
yellow='\033[1;31m'
green='\033[0;32m'
red='\033[0;31m'
nc='\033[0m'


### this script really should switch between users on later updates ###
if [[ $EUID -ne 0 ]]; then
echo "${red}Please run as root or use sudo${nc}" 2>&1
exit 1

### the following could be said in a better way to not be so confusing, but will probably be removed on later updates ###
echo "${red}Warning this script assumes it will be running as the same user running this script and will install $COINAME for the executing user${nc}"

echo "${yellow}Is this a fresh server install? [y/n]${nc}"
read DOSETUP

if [[ $DOSETUP =~ "y" ]] ; then

  echo "${red}Creating Swap Space${nc}"
  cd /var
  touch swap.img
  chmod 600 swap.img
  dd if=/dev/zero of=/var/swap.img bs=1024k count=4000
  mkswap /var/swap.img
  swapon /var/swap.img
  free
  echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
fi

  echo "Configuring IP - Please Wait......."

  declare -a NODE_IPS
  for ips in $(netstat -i | awk '!/Kernel|Iface|lo/ {print $1," "}')
  do
  NODE_IPS+=($(curl --interface $ips --connect-timeout 2 -s4 icanhazip.com))
  done

  if [ ${#NODE_IPS[@]} -gt 1 ] ; then
     echo "${yellow}Please enter number of ip you would like to use${nc}"
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

   echo "IP Done"
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

echo "${yellow}Is this a karmanode install? [y/n]${nc}"
read DOSETUPKN

if [[ $DOSETUPKN =~ "y" ]] ; then
   echo "${yellow}Enter $NODENAME private key${nc}"
   read PRIVKEY
   echo "$NODENAMEprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE
 fi


echo "${yellow}Would you like to install the snapshot/bootstrap? [y/n]${nc}"
read DOSETUPSNAP

if [[ $DOSETUPSNAP =~ "y" ]] ; then
curl -O $SNAPURL

fi

   echo "${yellow}You may start your  with the following command${nc}"
   echo ""
   echo "$DAEMON -daemon"

exit 0








