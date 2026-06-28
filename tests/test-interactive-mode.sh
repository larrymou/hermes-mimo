#!/bin/bash
# Test 2: Interactive Mode (tmux sessions)
# Tests mimo with tmux for multi-turn sessions

set -e

SESSION_NAME="mimo-test-interactive"

echo "=== Test 4: Interactive Mode with tmux ==="

# Check if tmux is available
if ! command -v tmux &> /dev/null; then
    echo "✗ tmux not found, skipping interactive tests"
    exit 0
fi

# Clean up any existing session
tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true

echo "Starting tmux session..."
tmux new-session -d -s "$SESSION_NAME" -x 120 -y 40

echo "Launching mimo in tmux..."
tmux send-keys -t "$SESSION_NAME" "mimo --model mimo/mimo-auto" Enter

# Wait for mimo to start
echo "Waiting for mimo to start..."
sleep 8

echo "Sending test prompt..."
tmux send-keys -t "$SESSION_NAME" "Respond with exactly: INTERACTIVE_OK" Enter

# Wait for response
echo "Waiting for response..."
sleep 10

echo "Capturing output..."
OUTPUT=$(tmux capture-pane -t "$SESSION_NAME" -p -S -50)

if echo "$OUTPUT" | grep -q "INTERACTIVE_OK"; then
    echo "✓ Interactive mode test passed"
else
    echo "✗ Interactive mode test failed"
    echo "Output: $OUTPUT"
    tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true
    exit 1
fi

echo "Cleaning up tmux session..."
tmux send-keys -t "$SESSION_NAME" C-c
sleep 2
tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true

echo ""
echo "=== Interactive Mode Test Passed ==="
