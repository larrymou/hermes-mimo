#!/bin/bash
# MiMo Code Orchestration Test Runner
# Runs all test scripts for the mimo-code skill

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     MiMo Code Orchestration Pattern Tests                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check prerequisites
echo "=== Checking Prerequisites ==="

if ! command -v mimo &> /dev/null; then
    echo "✗ mimo CLI not found"
    echo "  Install: npm install -g @mimo-ai/cli"
    exit 1
fi
echo "✓ mimo CLI found: $(mimo --version)"

if ! command -v tmux &> /dev/null; then
    echo "⚠ tmux not found (interactive tests will be skipped)"
else
    echo "✓ tmux found: $(tmux -V)"
fi

echo ""

# Run tests
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

run_test() {
    local test_name="$1"
    local test_script="$2"
    
    echo "┌──────────────────────────────────────────────────────────┐"
    echo "│ Running: $test_name"
    echo "└──────────────────────────────────────────────────────────┘"
    
    if [ ! -f "$test_script" ]; then
        echo "⚠ Test script not found: $test_script"
        TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
        return
    fi
    
    if bash "$test_script"; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    echo ""
}

# Run all tests
run_test "Print Mode Tests" "$SCRIPT_DIR/test-print-mode.sh"
run_test "Interactive Mode Tests" "$SCRIPT_DIR/test-interactive-mode.sh"
run_test "Parallel Work Tests" "$SCRIPT_DIR/test-parallel-work.sh"

# Summary
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                      Test Summary                         ║"
echo "╠════════════════════════════════════════════════════════════╣"
echo "║  Passed:   $TESTS_PASSED"
echo "║  Failed:   $TESTS_FAILED"
echo "║  Skipped:  $TESTS_SKIPPED"
echo "╚════════════════════════════════════════════════════════════╝"

if [ $TESTS_FAILED -eq 0 ]; then
    echo ""
    echo "✓ All tests passed!"
    exit 0
else
    echo ""
    echo "✗ Some tests failed"
    exit 1
fi
