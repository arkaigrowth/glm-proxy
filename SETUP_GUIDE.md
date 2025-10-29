# GLM 4.6 Proxy Setup & Usage Guide

## Overview
This proxy allows you to use GLM-4.6 (a powerful Chinese AI model) through a Claude-compatible interface. It uses LiteLLM to route requests through OpenRouter to the GLM-4.6 model.

## Prerequisites
- macOS with Homebrew installed
- Fish shell (`brew install fish`)
- jq for JSON processing (`brew install jq`)
- Python 3.9+ with pip
- LiteLLM (`pip install litellm`)

## Quick Setup

### 1. Check Prerequisites
```bash
# Verify installations
which fish      # Should show: /opt/homebrew/bin/fish or similar
which jq        # Should show: /opt/homebrew/bin/jq or similar
which litellm   # Should show path to litellm
```

### 2. Start the Proxy
```bash
# Navigate to the proxy directory
cd ~/AI/claude-glm-proxy

# Start the proxy (runs in background)
./bin/start-proxy
```

### 3. Verify Proxy is Running
```bash
# Check proxy health
curl -s http://localhost:8000/health -H "Authorization: Bearer glm-proxy-key" | jq
```

### 4. Use GLM-4.6

#### Option A: Using the claude-glm command (Fish shell)
```fish
# Simple prompt
~/AI/claude-glm-proxy/bin/claude-glm "What is the capital of France?"

# Code generation
~/AI/claude-glm-proxy/bin/claude-glm "Write a Python function to reverse a string"
```

#### Option B: Direct API calls (any shell)
```bash
# Create a request
cat > request.json << 'EOF'
{
  "model": "claude-3-5-sonnet-20241022",
  "messages": [{"role": "user", "content": "Hello, how are you?"}],
  "max_tokens": 500
}
EOF

# Send request
curl -s -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Authorization: Bearer glm-proxy-key" \
  -H "Content-Type: application/json" \
  -d @request.json | jq -r ".choices[0].message.content"
```

### 5. Stop the Proxy
```bash
~/AI/claude-glm-proxy/bin/stop-proxy
```

## Terminal Window Activation Guide

### For New Terminal Session

1. **Open a new terminal window**

2. **Navigate to the proxy directory:**
   ```bash
   cd ~/AI/claude-glm-proxy
   ```

3. **Start the proxy if not running:**
   ```bash
   # Check if already running
   curl -s http://localhost:8000/health >/dev/null 2>&1
   if [ $? -ne 0 ]; then
       echo "Starting proxy..."
       ./bin/start-proxy
   else
       echo "Proxy already running!"
   fi
   ```

4. **Create an alias for easy access (optional):**

   For bash/zsh:
   ```bash
   # Add to ~/.bashrc or ~/.zshrc
   alias glm='~/AI/claude-glm-proxy/bin/claude-glm'
   alias start-glm='~/AI/claude-glm-proxy/bin/start-proxy'
   alias stop-glm='~/AI/claude-glm-proxy/bin/stop-proxy'
   ```

   For fish:
   ```fish
   # Add to ~/.config/fish/config.fish
   alias glm='~/AI/claude-glm-proxy/bin/claude-glm'
   alias start-glm='~/AI/claude-glm-proxy/bin/start-proxy'
   alias stop-glm='~/AI/claude-glm-proxy/bin/stop-proxy'
   ```

5. **Test it's working:**
   ```bash
   # If using alias
   glm "Hello, are you GLM-4.6?"

   # Or full path
   ~/AI/claude-glm-proxy/bin/claude-glm "Hello, are you GLM-4.6?"
   ```

## Bash/Zsh Wrapper Scripts

Since the original scripts are in Fish shell, here are bash-compatible versions:

### Create bash version of claude-glm
```bash
cat > ~/AI/claude-glm-proxy/bin/claude-glm-bash << 'EOF'
#!/bin/bash
# Check if proxy is running
if ! curl -s http://localhost:8000/health >/dev/null 2>&1; then
    echo "❌ GLM proxy not running. Start it with:"
    echo "   ~/AI/claude-glm-proxy/bin/start-proxy-bash"
    exit 1
fi

echo "🚀 Using GLM 4.6 via proxy..."

# Call proxy with the provided prompt
curl -s -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Authorization: Bearer glm-proxy-key" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"claude-3-5-sonnet-20241022\",
    \"messages\": [{\"role\": \"user\", \"content\": \"$*\"}],
    \"max_tokens\": 2000
  }" | jq -r ".choices[0].message.content"
EOF

chmod +x ~/AI/claude-glm-proxy/bin/claude-glm-bash
```

### Create bash version of start-proxy
```bash
cat > ~/AI/claude-glm-proxy/bin/start-proxy-bash << 'EOF'
#!/bin/bash
cd "$(dirname "$0")/.."
echo "🚀 Starting GLM 4.6 proxy..."
litellm --config config.yaml --port 8000 > logs/proxy.log 2>&1 &
proxy_pid=$!
echo $proxy_pid > logs/proxy.pid
echo "✅ Proxy started (PID: $proxy_pid)"
echo "📋 Logs: tail -f ~/AI/claude-glm-proxy/logs/proxy.log"
EOF

chmod +x ~/AI/claude-glm-proxy/bin/start-proxy-bash
```

### Create bash version of stop-proxy
```bash
cat > ~/AI/claude-glm-proxy/bin/stop-proxy-bash << 'EOF'
#!/bin/bash
cd "$(dirname "$0")/.."
if [ -f logs/proxy.pid ]; then
    pid=$(cat logs/proxy.pid)
    if kill $pid 2>/dev/null; then
        echo "✅ Proxy stopped (PID: $pid)"
    else
        echo "⚠️  Process $pid not found"
    fi
    rm -f logs/proxy.pid
else
    echo "❌ No proxy PID file found"
fi
EOF

chmod +x ~/AI/claude-glm-proxy/bin/stop-proxy-bash
```

## Advanced Usage

### Changing Models
Edit `config.yaml` to map different Claude model names to GLM-4.6 or other OpenRouter models.

### Adjusting Parameters
Modify the JSON requests to change:
- `max_tokens`: Response length (100-4000)
- `temperature`: Creativity (0.0-1.0)
- `top_p`: Nucleus sampling (0.0-1.0)

### Monitoring
```bash
# View proxy logs
tail -f ~/AI/claude-glm-proxy/logs/proxy.log

# Check proxy status
ps aux | grep litellm

# View recent requests
tail -f ~/AI/claude-glm-proxy/audit_events_all.json | jq
```

## Troubleshooting

### Proxy won't start
- Check if port 8000 is already in use: `lsof -i :8000`
- Verify LiteLLM is installed: `pip show litellm`
- Check Python version: `python --version` (needs 3.9+)

### No response from GLM
- Verify OpenRouter API key in `.env` file
- Check API key has credits: Visit OpenRouter dashboard
- Review proxy logs: `tail -f logs/proxy.log`

### Fish shell issues
- Use the bash wrapper scripts instead (claude-glm-bash, etc.)
- Or install Fish: `brew install fish`

## Security Notes
- The `.env` file contains your OpenRouter API key - keep it secure
- The proxy uses a local bearer token (`glm-proxy-key`) for authentication
- Only accessible on localhost by default (port 8000)

## Support
For issues or questions:
1. Check the proxy logs first
2. Verify all prerequisites are installed
3. Ensure the OpenRouter API key is valid and has credits