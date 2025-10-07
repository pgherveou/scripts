# tmux set-option -p @name dev-node
DEV_NODE_PANE=$(tmux list-panes -a -F '#{pane_id} #{@name}' | awk '$2=="dev-node"{print $1}')
# tmux set-option -p @name eth-rpc
ETH_RPC_PANE=$(tmux list-panes -a -F '#{pane_id} #{@name}' | awk '$2=="eth-rpc"{print $1}')

while true; do
	# Kill and restart dev-node in tmux pane named 'dev-node'
	tmux send-keys -t "$DEV_NODE_PANE" C-c
	tmux send-keys -t "$DEV_NODE_PANE" 'dev-node run' C-m

	# Kill and restart eth-rpc in tmux pane named 'eth-rpc'
	tmux send-keys -t "$ETH_RPC_PANE" C-c
	tmux send-keys -t "$ETH_RPC_PANE" 'eth-rpc run ws:localhost:9944' C-m

	# Wait for port 8545 to listen
	while ! lsof -iTCP:8545 -sTCP:LISTEN; do
		sleep 0.5
	done
	echo "Servers ready."

	# Run tests
	USE_POLKAVM=true npx hardhat test ./test/UniswapV2Router01.spec.ts --network local --grep 'swapExactTokensForETH'

	status=$?
	echo "exit status: $status"
	if [ $status -ne 0 ]; then
		break
	fi
done
