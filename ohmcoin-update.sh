#!/usr/bin/env bash
#Copyright (c) 2018 The Ohmcoin developers

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



#Colors
yellow='\033[1;31m'
green='\033[0;32m'
red='\033[0;31m'
nc='\033[0m'

if [[ $EUID -ne 0 ]]; then
echo -e "${red}Please run as root or use sudo${nc}" 2>&1
exit 1
else ohmc-cli stop && \
echo "${yellow}Backing up old daemon incase of script bomb${nc}" && \
sleep 30 && \
mkdir /usr/local/bin/backup && \
mv /usr/local/bin/ohmcd /usr/local/bin/backup/ && \
mv /usr/local/bin/ohmc-cli /usr/local/bin/backup/ && \
mv /usr/local/bin/ohmc-tx /usr/local/bin/backup/ && \
echo -e "${yellow}Updating Vitae daemon files${nc}" && \
sleep 3 && \
mv ohmcd /usr/local/bin/ && \
mv ohmc-cli /usr/local/bin/ && \
mv ohmc-tx /usr/local/bin/ && \
echo -e "${green}Ohmcoin files updated${nc}" && \
sleep 3 && \
echo -e "${yellow}Charging laser weapons${nc}" && \
sleep 3 && \
echo -e "${yellow}Acquiring target${nc}" && \
sleep 3 && \
echo -e "${yellow}Target Aquired preparing to destroy backup files${nc}" && \
sleep 3 && \
echo  -e "${yellow}Firing all lasers${nc}" && \
sleep 3 && \
rm -rf /usr/local/bin/backup/ ../ohmc*.tar.gz && \
echo -e "${red}Target destroyed${nc}" && \
sleep 3 && \
echo -e "${green}You may now start the Vitae daemon normally ie.${nc}" && \
sleep 3 && \
echo " " && \
echo  -e "${red}ohmcd -daemon -txindex${nc}" && \
echo " " && \
sleep 3 && \
echo -e "${red}Please make sure to restart your karmanode in your controller wallet to complete the upgrade process${nc}"
fi
exit
