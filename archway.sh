#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
sudo apt install -y uidmap dbus-user-session
cd $HOME
mkdir archway && cd archway
wget "https://github.com/Northa/archway_bin/releases/download/v0.0.3/archwayd"
sha256sum archwayd
chmod +x archwayd
sudo mv archwayd /usr/local/bin/
ARCHWAY_CHAIN="augusta-1"
ARCHWAY_MONIKER="SERGO"
ARCHWAY_WALLET="SERGO" 
echo 'export ARCHWAY_CHAIN='${ARCHWAY_CHAIN} >> $HOME/.bash_profile
echo 'export ARCHWAY_MONIKER='${ARCHWAY_MONIKER} >> $HOME/.bash_profile
echo 'export ARCHWAY_WALLET='${ARCHWAY_WALLET} >> $HOME/.bash_profile
source $HOME/.bash_profile
archwayd init ${ARCHWAY_MONIKER} --chain-id $ARCHWAY_CHAIN
archwayd config chain-id $ARCHWAY_CHAIN
seeds="2f234549828b18cf5e991cc884707eb65e503bb2@34.74.129.75:31076,c8890bcde31c2959a8aeda172189ec717fef0b2b@95.216.197.14:26656"
PEERS="1f6dd298271684729d0a88402b1265e2ae8b7e7b@162.55.172.244:26656"
sed -i.bak -e "s/^seeds *=.*/seeds = \"$seeds\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.archway/config/config.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address = \"\"/external_address = \"$external_address:26656\"/" $HOME/.archway/config/config.toml
sed -i.bak -e "s/prometheus = false/prometheus = true/" $HOME/.archway/config/config.toml
wget -O $HOME/.archway/config/genesis.json "https://github.com/maxzonder/archway/raw/main/genesis.json"
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="5000"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.archway/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.archway/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.archway/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.archway/config/app.toml
archwayd unsafe-reset-all
archwayd keys add $ARCHWAY_WALLET


