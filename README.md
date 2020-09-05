# update-script
This script is used to quickly update nodes on vps servers.

Example:
wget https://github.com/theohmproject/ohmcoin/releases/download/github_version_tag/ohmcoin-version_number-linux.tar.gz && tar -xzvf ohmc-version_number-linux.tar.gz && sudo ./ohmcoin-update.sh && ohmcd -arguments

Usage if:
github_version_tag = v3.0.2.0
version_number = 3.0.2.0

wget https://github.com/theohmproject/ohmcoin/releases/download/3.0.2/ohmcoin-3.0.2-x86_64-linux-gnu.tar.gz && tar -xzvf ohmcoin-3.0.2-x86_64-linux-gnu.tar.gz && chmod 755 ohmcoin-update.sh && sudo ./ohmcoin-update.sh && ohmcd -daemon

Warning, this script is OCD and likes to clean up after itself in an agressive manner ie. rm -rf /usr/local/bin/backup/ ohmcd-* is used in the script. If you have anything in your directory that you run this script it in it WILL delete anything that begins with the name "ohmc-". This will be changed in later releases.
