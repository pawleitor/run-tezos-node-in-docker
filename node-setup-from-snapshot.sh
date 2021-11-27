#!/bin/sh
CONFIG=$TEZOS_NODE_DATA/data/config.json
ID=$TEZOS_NODE_DATA/data/identity.json
DATA_DIR=$TEZOS_NODE_DATA/data

echo 'if config file does not exist, create it'
[ ! -f $CONFIG ] \
&& echo 'create new config file' \
&& tezos-node config --config-file=$CONFIG --network=$NETWORK init \
&& tezos-node config --config-file=$CONFIG --rpc-addr=0.0.0.0:$RPC_PORT update \
&& tezos-node config --config-file=$CONFIG --data-dir=$DATA_DIR update \
&& tezos-node config --config-file=$CONFIG --allow-all-rpc=0.0.0.0:8732 update \
&& tezos-node config --config-file=$CONFIG --cors-header='content-type' update \
&& tezos-node config --config-file=$CONFIG --cors-origin='*' update \
|| echo 'Config file already exists; retain it'

echo ''
echo 'if data dir does not exist, import snapshot'
[ ! -d $DATA_DIR/context  ] \
&& echo 'always get new snapshot on rebiuld' \
&& wget $SNAPSHOT_URL -O $SNAPSHOT_PATH/$SNAPSHOT_FILE \
&& tezos-node snapshot import $SNAPSHOT_PATH/$SNAPSHOT_FILE --data-dir $DATA_DIR \
|| echo 'Data already exists; do not import snapshot'

echo ''
echo 'create new identity if needed'
[ ! -f $ID ] \
&& tezos-node identity generate 28 --config-file=$CONFIG \
|| echo 'ID exists already'

echo ''
echo 'start node'
tezos-node run --config-file=$CONFIG
