#!/bin/bash
# Test 1: Print Mode (One-Shot Tasks)
# Tests mimo run for non-interactive coding tasks

set -e

echo "=== Test 1: Print Mode Smoke Test ==="
echo "Testing mimo run with simple prompt..."

RESULT=$(mimo run 'Respond with exactly: PRINT_MODE_OK' --model mimo/mimo-auto 2>&1)
if echo "$RESULT" | grep -q "PRINT_MODE_OK"; then
    echo "✓ Print mode smoke test passed"
else
    echo "✗ Print mode smoke test failed"
    echo "Output: $RESULT"
    exit 1
fi

echo ""
echo "=== Test 2: Print Mode with File Attachment ==="
echo "Creating test file..."

mkdir -p /tmp/mimo-test
cat > /tmp/mimo-test/test.txt << 'EOF'
This is a test file for MiMo Code orchestration.
Line 2: Testing file attachment capability.
Line 3: End of test file.
EOF

echo "Testing mimo run with file attachment..."
RESULT=$(mimo run 'Read the attached file and respond with: FILE_ATTACHED' -f /tmp/mimo-test/test.txt --model mimo/mimo-auto 2>&1)
if echo "$RESULT" | grep -q "FILE_ATTACHED"; then
    echo "✓ File attachment test passed"
else
    echo "✗ File attachment test failed"
    echo "Output: $RESULT"
    exit 1
fi

echo ""
echo "=== Test 3: Print Mode with Agent Selection ==="
echo "Testing mimo run with plan agent..."

RESULT=$(mimo run --agent plan 'Respond with exactly: PLAN_AGENT_OK' --model mimo/mimo-auto 2>&1)
if echo "$RESULT" | grep -q "PLAN_AGENT_OK"; then
    echo "✓ Plan agent test passed"
else
    echo "✗ Plan agent test failed"
    echo "Output: $RESULT"
    exit 1
fi

echo ""
echo "=== All Print Mode Tests Passed ==="
