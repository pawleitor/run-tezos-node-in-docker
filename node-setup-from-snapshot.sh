#!/bin/sh
CONFIG=$TEZOS_NODE_DATA/data/config.json
DATA_DIR=$TEZOS_NODE_DATA/data/

echo 'if data dir does not exist, create config and import snapshot'
[ ! -d $TEZOS_NODE_DATA/data ] \
&& echo 'initialize node' \
&& tezos-node config --config-file=$CONFIG --network=$NETWORK init \
&& echo 'always get new snapshot on rebiuld' \
&& wget $SNAPSHOT_URL -O $SNAPSHOT_PATH/$SNAPSHOT_FILE \
&& tezos-node snapshot import $SNAPSHOT_PATH/$SNAPSHOT_FILE --data-dir $DATA_DIR \
|| echo 'Data already exists'

echo 'start node'
tezos-node run --config-file=$CONFIG