#!/bin/bash

# Expected input: a temporary raw log file created by run_script.sh
RAW_OUTPUT_FILE="/app/test_output_raw.txt"
JSON_OUTPUT_FILE="/app/test_results.json"

# Arrays to hold results
phase1_results=()
phase2_results=()

# Helper function to convert status to JSON entries
make_json_entry() {
    local name="$1"
    local status="$2"
    echo "{\"name\": \"${name}\", \"status\": \"${status}\"}"
}

# Parse the raw output
current_phase=""
while IFS= read -r line; do
    if [[ "$line" == "=== PHASE 1 START ===" ]]; then
        current_phase="1"
        continue
    fi
    if [[ "$line" == "=== PHASE 2 START ===" ]]; then
        current_phase="2"
        continue
    fi

    # Expected line format:
    # <test_path> | <test_title> :: <PASSED/FAILED>
    if [[ "$line" == *"::"* ]]; then
        test_name=$(echo "$line" | cut -d':' -f1 | xargs)
        test_status=$(echo "$line" | awk -F'::' '{print $2}' | xargs)
        json_entry=$(make_json_entry "$test_name" "$test_status")

        if [[ "$current_phase" == "1" ]]; then
            phase1_results+=("$json_entry")
        elif [[ "$current_phase" == "2" ]]; then
            phase2_results+=("$json_entry")
        fi
    fi
done < "$RAW_OUTPUT_FILE"

# Determine overall result
overall="FAILURE"

# Separate F2P and P2P tests for phase 1
phase1_f2p=()
phase1_p2p=()
for entry in "${phase1_results[@]}"; do
    if [[ "$entry" == *".f2p.test.js"* ]] || [[ "$entry" == *".f2p.test.ts"* ]]; then
        phase1_f2p+=("$entry")
    elif [[ "$entry" == *".p2p.test.js"* ]] || [[ "$entry" == *".p2p.test.ts"* ]]; then
        phase1_p2p+=("$entry")
    fi
done

# Check Phase 1: F2P should all FAIL, P2P should all PASS
phase1_f2p_all_failed=true
phase1_p2p_all_passed=true

for entry in "${phase1_f2p[@]}"; do
    if [[ "$entry" != *"FAILED"* ]]; then
        phase1_f2p_all_failed=false
        break
    fi
done

for entry in "${phase1_p2p[@]}"; do
    if [[ "$entry" != *"PASSED"* ]]; then
        phase1_p2p_all_passed=false
        break
    fi
done

# Check Phase 2: All tests should PASS
phase2_all_passed=true
for entry in "${phase2_results[@]}"; do
    if [[ "$entry" != *"PASSED"* ]]; then
        phase2_all_passed=false
        break
    fi
done

# Overall SUCCESS if all conditions met
if [ ${#phase1_f2p[@]} -gt 0 ] && [ ${#phase1_p2p[@]} -gt 0 ] && [ ${#phase2_results[@]} -gt 0 ]; then
    if $phase1_f2p_all_failed && $phase1_p2p_all_passed && $phase2_all_passed; then
        overall="SUCCESS"
    fi
fi

# Produce the final JSON
{
    echo "{"
    echo "  \"phase_1\": ["
    printf "    %s\n" "$(IFS=$',\n    '; echo "${phase1_results[*]}")"
    echo "  ],"
    echo "  \"phase_2\": ["
    printf "    %s\n" "$(IFS=$',\n    '; echo "${phase2_results[*]}")"
    echo "  ],"
    echo "  \"overall_result\": \"${overall}\""
    echo "}"
} > "$JSON_OUTPUT_FILE"

# Also print it to stdout
cat "$JSON_OUTPUT_FILE"
