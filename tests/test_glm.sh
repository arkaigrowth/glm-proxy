#!/bin/bash

# GLM-4.6 Proxy Comprehensive Test Script
# This script tests various capabilities of the GLM-4.6 model through the proxy

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROXY_URL="http://localhost:8000/v1/chat/completions"
AUTH_KEY="glm-proxy-key"

echo "================================================"
echo "     GLM-4.6 Proxy Comprehensive Test Suite    "
echo "================================================"
echo

# Function to make API call
api_call() {
    local prompt="$1"
    local max_tokens="${2:-500}"

    curl -s -X POST "$PROXY_URL" \
        -H "Authorization: Bearer $AUTH_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"model\": \"claude-3-5-sonnet-20241022\",
            \"messages\": [{\"role\": \"user\", \"content\": \"$prompt\"}],
            \"max_tokens\": $max_tokens
        }" | jq -r ".choices[0].message.content"
}

# Function to test and display result
run_test() {
    local test_name="$1"
    local prompt="$2"
    local max_tokens="${3:-500}"

    echo -e "${YELLOW}Test:${NC} $test_name"
    echo -e "${YELLOW}Prompt:${NC} $prompt"
    echo -e "${YELLOW}Response:${NC}"

    response=$(api_call "$prompt" "$max_tokens")

    if [ -z "$response" ] || [ "$response" == "null" ]; then
        echo -e "${RED}✗ Failed${NC}"
        echo
        return 1
    else
        echo "$response" | head -n 10
        if [ $(echo "$response" | wc -l) -gt 10 ]; then
            echo "... (truncated for display)"
        fi
        echo -e "${GREEN}✓ Success${NC}"
        echo
        return 0
    fi
}

# Check if proxy is running
echo -e "${YELLOW}Checking proxy status...${NC}"
if curl -s http://localhost:8000/health -H "Authorization: Bearer $AUTH_KEY" >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Proxy is running${NC}"
else
    echo -e "${RED}✗ Proxy is not running${NC}"
    echo "Please start the proxy with: ~/AI/claude-glm-proxy/bin/start-proxy-bash"
    exit 1
fi
echo

# Test Suite
tests_passed=0
tests_failed=0

echo "================================================"
echo "            Running Test Suite                 "
echo "================================================"
echo

# Test 1: Basic Math
if run_test "Basic Math" "What is 25 * 4?" 100; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

# Test 2: Code Generation - Python
if run_test "Python Code Generation" "Write a Python one-liner to find all prime numbers up to 100" 500; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

# Test 3: Code Generation - JavaScript
if run_test "JavaScript Code Generation" "Write a JavaScript arrow function to debounce a function call" 800; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

# Test 4: System Design
if run_test "System Design" "Design a simple URL shortener system. List the main components." 1000; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

# Test 5: Algorithm Explanation
if run_test "Algorithm Explanation" "Explain how quicksort works in simple terms" 800; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

# Test 6: Creative Writing
if run_test "Creative Writing" "Write a haiku about artificial intelligence" 200; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

# Test 7: Data Structure
if run_test "Data Structure" "What's the difference between a stack and a queue? Give one use case for each." 600; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

# Test 8: Debugging
if run_test "Debugging Help" "Why might a REST API return a 504 Gateway Timeout error?" 600; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

# Test 9: Best Practices
if run_test "Best Practices" "What are 3 best practices for writing clean code?" 600; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

# Test 10: Complex Reasoning
if run_test "Complex Reasoning" "If it takes 5 machines 5 minutes to make 5 widgets, how long would it take 100 machines to make 100 widgets?" 400; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

echo "================================================"
echo "              Test Results Summary              "
echo "================================================"
echo
echo -e "${GREEN}Tests Passed: $tests_passed${NC}"
echo -e "${RED}Tests Failed: $tests_failed${NC}"
echo

if [ $tests_failed -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed successfully!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Some tests failed. Check the output above for details.${NC}"
    exit 1
fi