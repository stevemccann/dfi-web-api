#!/bin/bash

# This script downloads a snapshot of defichain to speed up the time it takes to sync a new node. It also downloads the CLI for use in the container.

# Get latest snapshot from https://defi-snapshots-europe.s3.eu-central-1.amazonaws.com/index-1.8.0.txt where 1.8.0 is the main CLI version
# Can also check https://github.com/DeFiCh/ain/releases
SNAPSHOT='snapshot-mainnet-1481625.zip'
DEFI_DIRECTORY='data/dfi-node/defi'
CLI_VERSION='2.3.1'

CLI_FILE=defichain-${CLI_VERSION}-x86_64-pc-linux-gnu.tar.gz

echo "Starting dfi-web-api initializatioin script"

# Check if there's already a defi data directory
if [ -d "$DEFI_DIRECTORY" ]; then
    echo "$DEFI_DIRECTORY already exists, aborting"
    exit 1
fi

mkdir -p data/dfi-node

echo "Downloading snapshot"
wget https://defi-snapshots-europe.s3.eu-central-1.amazonaws.com/${SNAPSHOT}

if [ -f "$SNAPSHOT" ]; then
    echo "Unzipping $SNAPSHOT"
    unzip ${SNAPSHOT} -d ${DEFI_DIRECTORY}
fi

echo "Downloading defi cli"
SNAPSHOT_BASE_URL='https://defi-snapshots.s3.ap-southeast-1.amazonaws.com'
#wget https://defi-snapshots-europe.s3.eu-central-1.amazonaws.com/${SNAPSHOT}
wget ${SNAPSHOT_BASE_URL}/${SNAPSHOT}

if [ -f "$CLI_FILE" ]; then
    echo "Untarring $CLI_FILE"
    # folder in tar is defichain-<VERSION> i.e. defichain-1.8.2
    tar -xzf ${CLI_FILE} --directory data/dfi-node
fi

echo "Cleaning up - removing downloaded files"
rm $CLI_FILE $SNAPSHOT

echo "Starting docker container"
cd docker
docker-compose up --build --detach

# TODO: Fix issue with Dockerfile not running npm install
docker exec -it dfi-web-api npm install
docker restart dfi-web-api --time 30

echo '
Finished init script!'