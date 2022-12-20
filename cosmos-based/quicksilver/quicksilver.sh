#!/bin/bash
clear
echo -e "\e[96m"
##########################################################
#     START configuration by https://jambulmerah.dev     #
##########################################################
# Project name
project_name="quicksilver"
repo="https://github.com/ingenuity-build/quicksilver.git"
repo_dir="quicksilver"
chain_dir="$HOME/.quicksilverd"
bin_name="quicksilverd"

# Testnet
testnet_denom="uqck"
testnet_chain_id="innuendo-4"
testnet_repo_tag="v0.10.8"
testnet_rpc="https://quicksilver-testnet-rpc.jambulmerah.dev:443"
testnet_genesis="https://raw.githubusercontent.com/ingenuity-build/testnets/main/innuendo/genesis.json"
testnet_seeds=""
testnet_peers="`curl -sS $testnet_rpc/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's/\n/,/g;s/.$//'`"
testnet_snapshot="`curl -s https://snapshots.polkachu.com/testnet-snapshots | xmlstarlet fo | grep -o "quicksilver.*\.tar.lz4" | head -1`"
testnet_snapshot_url="https://snapshots.polkachu.com/testnet-snapshots/${testnet_snapshot}"
testnet_snapshot_provider="Polkachu.com"

# Mainnet
mainnet_denom="uqck"
mainnet_chain_id="quicksilver-1"
mainnet_repo_tag="v1.0.0"
mainnet_rpc="https://quicksilver-rpc.jambulmerah.dev:443"
mainnet_genesis="https://raw.githubusercontent.com/ingenuity-build/mainnet/main/genesis.json"
mainnet_seeds=""
mainnet_peers="`curl -sS $mainnet_rpc/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's/\n/,/g;s/.$//'`"
mainnet_snapshot="`curl -s https://snapshots.polkachu.com/snapshots | xmlstarlet fo | grep -o "quicksilver.*\.tar.lz4" | head -1`"
mainnet_snapshot_url="https://snapshots.polkachu.com/snapshots/${mainnet_snapshot}"
mainnet_snapshot_provider="Polkachu.com"

# Script
bline="================================================================="
build_binary="https://raw.githubusercontent.com/jambulmerah/guide-testnet/main/cosmos-based/script/buildbinary.sh"
set_init_node="https://raw.githubusercontent.com/jambulmerah/guide-testnet/main/cosmos-based/script/setinitnode.sh"
sync_method="https://raw.githubusercontent.com/jambulmerah/guide-testnet/main/cosmos-based/script/syncmethod.sh"
##########################################################
#      END configuration by https://jambulmerah.dev      #
##########################################################


while true; do
if [[ -d $chain_dir ]]; then
  echo "Aborting: $project_nect chain directory in $chain_dir exists"
  exit 1
fi
cosmovisorOpt(){
echo "[1] Run with cosmovisor..."
echo "[2] Run without cosmovisor..."
echo "[3] Back"
echo "[0] Exit"
echo -n "What do you like...? "
}
  curl -s https://raw.githubusercontent.com/jambulmerah/guide-testnet/main/script/logo.sh | bash
  echo $bline
  echo "Welcome to "$project_name" node installer by jambulmerah | Cosmos⚛️Lovers❤️"
  echo $bline

  echo "Mainnet info:"
  echo "Chain ID: $mainnet_chain_id"
  echo "Binary version: $(curl -s $mainnet_rpc/abci_info | jq -r .result.response.version)"
  echo "Block height: $(curl -s $mainnet_rpc/status | jq -r .result.sync_info.latest_block_height)"
  echo $bline
  echo "Testnet info:"
  echo "Chain ID: $testnet_chain_id"
  echo "Binary version: $(curl -s $testnet_rpc/abci_info | jq -r .result.response.version)"
  echo "Block height: $(curl -s $testnet_rpc/status | jq -r .result.sync_info.latest_block_height)"
  echo $bline
  echo "[1] Install "$project_name" mainnet node ("$mainnet_chain_id")"
  echo "[2] Install "$project_name" testnet node ("$testnet_chain_id")"
  echo "[0] Exit"
  read -p "What chain do you want to run? " opt
  if [[ ! $opt == [0-2] ]]; then
    continue
  elif [[ $opt == "0" ]]; then
    exit
  elif [[ $opt -eq 1 && -n $mainnet_chain_id ]]; then
    while true; do
      clear
      echo "Choose your service to run node "$project_name" "$testnet_chain_id""
      cosmovisorOpt
      read i
      if [[ ! $i == [0-3] ]]; then
	continue
      elif [[ $i == "0" ]]; then
        exit
      elif [[ $i -eq 1 ]]; then
        join_main=true
	with_cosmovisor=true
        break
      elif [[ $i -eq 2 ]]; then
        join_main=true
        break
      elif [[ $i -eq 3 ]]; then
        break
      fi
    done
  elif [[ $opt -eq 2 && -n $testnet_chain_id ]]; then
    while true; do
      clear
      echo "Choose your service to run node "$project_name" "$testnet_chain_id""
      cosmovisorOpt
      read i
      if [[ ! $i == [0-3] ]]; then
	continue
      elif [[ $i == "0" ]]; then
        exit
      elif [[ $i -eq 1 ]]; then
        join_test=true
	with_cosmovisor=true
        break
      elif [[ $i -eq 2 ]]; then
        join_test=true
        break
      elif [[ $i -eq 3 ]]; then
        break
      fi
    done
  fi
  if [[ $join_test == "true" || $join_main == "true" ]]; then
    clear
    . <(curl -sSL "$build_binary")
    clear
    . <(curl -sSL "$set_init_node")
    clear
    . <(curl -sSL "$sync_method")
    clear
    sleep 1
    break
  fi
done
echo -e "=============== $project_name node setup finished ==================="
echo -e "To check logs: \tjournalctl -u $bin_name -f -o cat"
echo -e "To check sync status: \tcurl -s localhost:${rpc_port}/status | jq .result.sync_info"
echo -e ""$bline"\e[m"
