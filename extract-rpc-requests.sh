#!/bin/bash

# Script to extract JSON-RPC requests from eth-rpc server log output
# Usage: ./target/bin/eth-rpc ... 2>&1 | ./extract-rpc-requests.sh
# Or: ./extract-rpc-requests.sh < /tmp/eth-rpc.log > eth-rpc.log

# Read from stdin (pipe or redirect)
# Look for lines with recv= and extract the JSON content
grep 'recv=' | sed -E 's/.*recv="(.*)"/\1/' | while read -r line; do
    # Only process lines that contain eth_sendRawTransaction
    if echo "$line" | grep -q '\\"method\\":\\"eth_sendRawTransaction\\"'; then
        # Unescape the JSON (replace \" with ")
        echo "$line" | sed 's/\\"/"/g'
    fi
done
