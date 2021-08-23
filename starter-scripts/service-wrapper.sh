#!/bin/bash

# This script is used to start and monitor both the DFI node daemon as well as the Node.JS REST API
# Base of script from: https://docs.docker.com/config/containers/multi-service_container/

NODE_DELAY_SEC=15

echo "Attempting to start DFI daemon and Node.JS API"

# Start the first process
/opt/defi/bin/defid &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start defi node: $status"
  exit $status
fi

# Sleep for a period of time to ensure the DFI node is up and running.
echo "Waiting for $NODE_DELAY_SEC seconds start Node.JS app to allow defi node to start"
sleep $NODE_DELAY_SEC

# Start the second process
# ./start-node-app.sh -D
echo "Starting Node.JS app"
node /home/node/app/index.js &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Node.JS app: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container exits with an error
# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 60; do
  # echo "Checking services are still running..."
  ps aux |grep defid |grep -q -v grep
  PROCESS_1_STATUS=$?
  # TODO: Validate that the check below correctly catches a running or failed Node.JS instnace
  ps aux |grep node |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done