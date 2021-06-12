#!/bin/bash
# shellcheck disable=SC1091
#---------------------------------------------------#
#  A BitCanna-Cosmos Community Installation Script  #
#                 Testnet - Stage2                  #   
#---------------------------------------------------#
#---------------------------------------------------#
#                  Version: V1.01                   #
#             Donate BitCanna Address:              #
#    --> B73RRFVtndfPRNSgSQg34yqz4e9eWyKRSv <--     #
#---------------------------------------------------#

. CONFIG

info "Welcome to Stage2 !!\nHave you Completed the Testnet-Stage1 ?Choose(Y/N):"
read -r choix
if [ "$choix" == "y" ] || [ "$choix" == "Y" ]; then 
 ok "Lets Goo.."
else 
 erro "WTF! ARE YOU DOING HERE?! "
fi

if sudo systemctl is-active "$BCNAD".service ; then
 sudo systemctl stop "$BCNAD"
 sudo systemctl disable "$BCNAD"
 ok "$BCNAD Stopped and Disabled"
else
 sudo systemctl disable "$BCNAD"
 warn "$BCNAD.service already stopped"
fi

rm -rf "$BCNACONF"/genesis.json
rm -rf "$BCNACONF"/gentx/ 
curl -s https://raw.githubusercontent.com/BitCannaGlobal/testnet-bcna-cosmos/main/instructions/stage2/genesis.json > "$BCNACONF"/genesis.json || erro "Unable get genesis.json from Stage2 page"

MYWALLETADDR=$($BCNAD keys show "$WALLETNAME" -a)

if "$BCNAD" add-genesis-account "$($BCNAD keys show $WALLETNAME -a)" 100000000000ubcna ; then
 ok "Genesis Account Added with Success"
else
 erro "Genesis Account Added with Success"
fi

if "$BCNAD" gentx "$WALLETNAME" 90000000000ubcna --moniker "$MONIKER" --chain-id "$CHAINID" -y ; then
 ok "genesis.json generated"
else
 erro "genesis.json NOT generated"
fi

info "Setting DDOS Protection for Validator (with Sentry Nodes)"
sed -E -i "s/persistent_peers = \".*\"/persistent_peers = \"$PERSISTPEERS\"/" "$BCNACONF"/config.toml
sed -E -i "/private_peer_ids =/ s/^#*/#/" "$BCNACONF"/config.toml
sed -E -i "s/pex = true/pex = false/" "$BCNACONF"/config.toml
sed -E -i "s/addr_book_strict = true/addr_book_strict = false/" "$BCNACONF"/config.toml

info "$(ls -la "$BCNACONF"/gentx/ | tail -n1 | awk '{print $9}')"
warn "TIME TO SEND YOUR GENERATED .json file to Network knack"
sleep 1
warn "TIME TO SEND YOUR GENERATED .json file to Network knack"
sleep 1
warn "TIME TO SEND YOUR GENERATED .json file to Network knack"
sleep 1



### TASK 2 PENDING
