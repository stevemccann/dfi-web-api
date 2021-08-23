# dfi-web-api

This project creates a Docker service / image to run a defichain node 
along with a Node.JS REST API to retrieve data from the node. It was
created because many public Defichan REST API endpoints are not stable.

Prerequisite software for this to run:
* docker
* docker-compose
* git

The script `init-defi.sh` should do all the necessary pre-requisite steps to download a snapshot of defichain to avoid the many hours / days it takes to fully sync a new defi node. It also dowmloads the defi CLI, which is the node software itself. This CLI will need to be updated occasionally to work properly.

Note that this shell script is design to work with linux or unix-like system. It's possible for this project to run under Windows, but you will need to manually download and unzip the snapshot and CLI to the correct directories.

Commands to get up and running:

1. git clone https://github.com/stevemccann/dfi-web-api.git
2. cd dfi-web-api
3. ./init-defi.sh

If this runs successfully, the node should startup and be accessible at http://localhost:8333

By default, the docker container will always start with your operating system. Some more instructions on how to work with docker can be added in the future.