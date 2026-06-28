#!/bin/bash
# Test 3: Parallel Work Pattern
# Tests multiple mimo instances working in parallel

set -e

echo "=== Test 5: Parallel Work Pattern ==="

# Create test directories
mkdir -p /tmp/mimo-parallel/{task1,task2,task3}

# Create test files for each task
for i in 1 2 3; do
    cat > /tmp/mimo-parallel/task$i/README.md << EOF
# Task $i
This is test project $i for parallel MiMo Code execution.
EOF
done

echo "Starting 3 parallel mimo instances..."

# Start parallel tasks in background
mimo run 'Create a file called result.txt with content: TASK1_DONE' \
    --model mimo/mimo-auto \
    --dir /tmp/mimo-parallel/task1 \
    > /tmp/mimo-parallel/task1/output.log 2>&1 &
PID1=$!

mimo run 'Create a file called result.txt with content: TASK2_DONE' \
    --model mimo/mimo-auto \
    --dir /tmp/mimo-parallel/task2 \
    > /tmp/mimo-parallel/task2/output.log 2>&1 &
PID2=$!

mimo run 'Create a file called result.txt with content: TASK3_DONE' \
    --model mimo/mimo-auto \
    --dir /tmp/mimo-parallel/task3 \
    > /tmp/mimo-parallel/task3/output.log 2>&1 &
PID3=$!

echo "Waiting for all tasks to complete..."
echo "PIDs: $PID1, $PID2, $PID3"

# Wait for all background processes
wait $PID1
RESULT1=$?
wait $PID2
RESULT2=$?
wait $PID3
RESULT3=$?

echo ""
echo "=== Results ==="

SUCCESS=0
TOTAL=3

if [ $RESULT1 -eq 0 ] && [ -f /tmp/mimo-parallel/task1/result.txt ]; then
    echo "✓ Task 1 completed successfully"
    SUCCESS=$((SUCCESS + 1))
else
    echo "✗ Task 1 failed"
fi

if [ $RESULT2 -eq 0 ] && [ -f /tmp/mimo-parallel/task2/result.txt ]; then
    echo "✓ Task 2 completed successfully"
    SUCCESS=$((SUCCESS + 1))
else
    echo "✗ Task 2 failed"
fi

if [ $RESULT3 -eq 0 ] && [ -f /tmp/mimo-parallel/task3/result.txt ]; then
    echo "✓ Task 3 completed successfully"
    SUCCESS=$((SUCCESS + 1))
else
    echo "✗ Task 3 failed"
fi

echo ""
echo "Score: $SUCCESS/$TOTAL tests passed"

# Cleanup
rm -rf /tmp/mimo-parallel

if [ $SUCCESS -eq $TOTAL ]; then
    echo ""
    echo "=== All Parallel Work Tests Passed ==="
    exit 0
else
    echo ""
    echo "=== Some Parallel Work Tests Failed ==="
    exit 1
fi
