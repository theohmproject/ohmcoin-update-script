# update-script
This script is used to quickly update nodes on vps servers.

Example:
wget https://github.com/theohmproject/ohmcoin/releases/download/github_version_tag/ohmcoin-version_number-linux.tar.gz && tar -xzvf ohmc-version_number-linux.tar.gz  && sudo ./update.sh && ohmcd -arguments

Usage if:
github_version_tag = v2.4.0.0
version_number = 2.4.0.0

wget https://github.com/theohmproject/ohmcoin/releases/download/2.4.0.0/ohmcoin-2.4.0.0-64-linux.tar.gz && tar -xzvf vitae-2.4.0.0-linux.tar.gz  && sudo ./update.sh && ohmcd -daemon -txindex


Warning, this script is OCD and likes to clean up after itself in an agressive manner ie. rm -rf /usr/local/bin/backup/ ohmcd-* is used in the script. If you have anything in your directory that you run this script it in it WILL delete anything that begins with the name "ohmc-".
