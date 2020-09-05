# update-script
This script is used to quickly update nodes on vps servers.

## Example:
*wget ..URL/ohmcoin-update.sh && sudo ./ohmcoin-update.sh && ohmcoind -arguments*

Usage if:
github_version_tag = `v3.0.2.0`
version_number = `3.0.2.0`

### Example Call

`wget https://raw.githubusercontent.com/theohmproject/ohmcoin-update-script/develop/ohmcoin-update.sh 
  && chmod 755 ohmcoin-update.sh 
  && sudo ./ohmcoin-update.sh 
  && ohmcoind -daemon`

**Warning**, this script is OCD and likes to clean up after itself in an agressive manner, i.e. it will remove old daemon versions, clean up, and remove itself as well.
