#!/bin/bash
set -e

# Configuration
WORKING_DIR="/app"
TEST_PATCH="/app/patches/test_patch.patch"
GOLD_PATCH="/app/patches/gold_patch.patch"
RAW_OUTPUT_FILE="/app/test_output_raw.txt"

# Utility function to apply patches
apply_patch() {
    local patch_file="$1"
    echo "=== Applying patch: $patch_file ==="
    # Use -C to apply patch to the correct directory
    git -C "$WORKING_DIR" apply --ignore-whitespace "$patch_file"
    echo "Patch applied successfully"
}

echo "=========================================="
echo "Running Tests for TextBehind PostHog Bug"
echo "=========================================="

# Reset raw output file
: > "$RAW_OUTPUT_FILE"

echo ""
echo "=== Adding Tests ==="
apply_patch "$TEST_PATCH"

echo ""
echo "=========================================="
echo "PHASE 1: Testing BROKEN State"
echo "=========================================="
echo ""

# Marker for parser
echo "=== PHASE 1 START ===" | tee -a "$RAW_OUTPUT_FILE"

# Run Vitest and format output to match the required pattern: <path> | <title> :: <PASSED/FAILED>
# We use a simple script to run vitest and translate results
cd "$WORKING_DIR/app"

run_vitest() {
    local phase="$1"
    local output
    output=$(npx vitest run --reporter=json 2>/dev/null || true)
    
    # Parse JSON output and print in required format
    echo "$output" | node -e "
        const data = JSON.parse(require('fs').readFileSync(0, 'utf8'));
        data.testResults.forEach(file => {
            file.assertionResults.forEach(test => {
                const status = test.status === 'passed' ? 'PASSED' : 'FAILED';
                console.log(\`\${file.name.split('app/')[1]} | \${test.title} :: \${status}\`);
            });
        });
    " | tee -a "$RAW_OUTPUT_FILE"
}

run_vitest "1"

echo ""
echo "=========================================="
echo "PHASE 2: Applying Fix and Re-testing on FIXED State"
echo "=========================================="
echo ""

echo "=== Applying Gold Patch ==="
apply_patch "$GOLD_PATCH"

echo ""
# Marker for parser
echo "=== PHASE 2 START ===" | tee -a "$RAW_OUTPUT_FILE"

run_vitest "2"

echo ""
echo "=========================================="
echo "Test Execution Complete"
echo "=========================================="

exit 0
