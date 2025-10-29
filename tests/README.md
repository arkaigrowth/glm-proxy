# Tests Directory

This directory contains the test suite and example request payloads for the Claude GLM Proxy.

## Contents

### `test_glm.sh`
Comprehensive test suite with 10 test scenarios covering:

1. **Basic Math & Reasoning** - Simple arithmetic to verify basic functionality
2. **Code Generation (Python)** - Tests Python code generation capabilities
3. **Code Generation (JavaScript)** - Tests JavaScript code generation
4. **System Design** - Architecture and design questions
5. **Algorithm Explanation** - Code comprehension and explanation
6. **Creative Writing** - Story generation and creative tasks
7. **Data Structures** - Technical CS fundamentals
8. **Best Practices** - Software engineering advice
9. **Debugging Scenario** - Code debugging and problem-solving
10. **Complex Reasoning** - Multi-step logical reasoning

### `examples/`
Directory containing example request payloads in JSON format:

- `test_request.json` - Basic request template
- `test_code_gen.json` - Code generation example
- `test_api_design.json` - API design example

## Running Tests

### Run Full Test Suite
```bash
# From project root
./tests/test_glm.sh

# Or with full path
~/AI/claude-glm-proxy/tests/test_glm.sh
```

### Run Individual Test
Modify `test_glm.sh` to comment out tests you don't want to run, or extract a specific test command.

### Using Example Payloads
```bash
# Send a request using example payload
curl -s -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Authorization: Bearer glm-proxy-key" \
  -H "Content-Type: application/json" \
  -d @tests/examples/test_request.json | jq -r ".choices[0].message.content"
```

## Creating Custom Tests

### Example Test Structure
```bash
echo "🧪 Test Name"
curl -s -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Authorization: Bearer glm-proxy-key" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "messages": [{"role": "user", "content": "Your test prompt here"}],
    "max_tokens": 1000
  }' | jq -r ".choices[0].message.content"
echo -e "\n---\n"
```

## Test Requirements

- Proxy must be running: `./bin/start-proxy` or `./bin/start-proxy-bash`
- `jq` must be installed: `brew install jq`
- `curl` must be available (standard on macOS/Linux)
- Valid OpenRouter API key configured in `.env`

## Expected Output

Each test should:
- Display a clear test name with emoji
- Show the model's response
- Separate tests with `---` dividers

## Troubleshooting Tests

### Test Fails with "Connection Refused"
Proxy isn't running. Start it first:
```bash
./bin/start-proxy  # or ./bin/start-proxy-bash
```

### Test Returns Empty Response
- Check API key in `.env`
- Verify API key has credits on OpenRouter
- Check proxy logs: `tail -f logs/proxy.log`

### jq Command Not Found
Install jq:
```bash
brew install jq  # macOS
```

## Adding New Tests

1. Open `test_glm.sh` in your editor
2. Copy an existing test block
3. Modify the test name and prompt
4. Adjust `max_tokens` if needed for longer/shorter responses
5. Save and run the test suite

## Performance Notes

- Each test makes a live API call to GLM-4.6 via OpenRouter
- Tests may take 2-10 seconds each depending on response length
- The full test suite typically takes 1-2 minutes to complete
- API costs apply (OpenRouter charges per token)
