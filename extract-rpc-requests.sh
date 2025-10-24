#!/bin/bash

# Script to extract JSON-RPC requests from eth-rpc server log output
# Usage: ./target/bin/eth-rpc ... 2>&1 | ./extract-rpc-requests.sh
# Or: ./extract-rpc-requests.sh < /tmp/eth-rpc.log > eth-rpc.log

# Read from stdin (pipe or redirect)
# Look for lines with recv= and eth_sendRawTransaction, extract and unescape JSON
# Single pipeline - no subshells or loops
grep 'recv=' | grep '\\"method\\":\\"eth_sendRawTransaction\\"' | sed -E 's/.*recv="(.*)"/\1/' | sed 's/\\"/"/g'
