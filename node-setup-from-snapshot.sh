#!/bin/sh
CONFIG=$TEZOS_NODE_DATA/data/config.json
DATA_DIR=$TEZOS_NODE_DATA/data

echo 'if config file does not exist, create it'
[ ! -f $CONFIG ] \
&& echo 'create new config file' \
&& tezos-node config --config-file=$CONFIG --network=$NETWORK init \
&& tezos-node config --config-file=$CONFIG --rpc-addr=0.0.0.0:$RPC_PORT update \
&& tezos-node config --config-file=$CONFIG --connections=100 --max-download-speed=1024 --max-upload-speed=1024 update \
&& tezos-node config --config-file=$CONFIG --data-dir=$DATA_DIR update \
|| echo 'Config file already exists; retain it'

echo 'if data dir does not exist, import snapshot'
[ ! -d $DATA_DIR/context  ] \
&& echo 'always get new snapshot on rebiuld' \
&& wget $SNAPSHOT_URL -O $SNAPSHOT_PATH/$SNAPSHOT_FILE \
&& tezos-node snapshot import $SNAPSHOT_PATH/$SNAPSHOT_FILE --data-dir $DATA_DIR \
|| echo 'Data already exists'

echo 'start node'
tezos-node run --config-file=$CONFIG
