# update-script
This script is used to quickly update nodes on vps servers.

Example:
wget ..URL/ohmcoin-update.sh && sudo ./ohmcoin-update.sh && ohmcd -arguments

Usage if:
github_version_tag = v3.0.2.0
version_number = 3.0.2.0

wget https://raw.githubusercontent.com/theohmproject/ohmcoin-update-script/develop/ohmcoin-update.sh && chmod 755 ohmcoin-update.sh && sudo ./ohmcoin-update.sh && ohmcd -daemon

Warning, this script is OCD and likes to clean up after itself in an agressive manner ie. rm -rf /usr/local/bin/backup/ ohmcd-* is used in the script. If you have anything in your directory that you run this script it in it WILL delete anything that begins with the name "ohmc-". This will be changed in later releases.
