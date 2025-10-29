# GLM-4.6 Proxy Quick Reference

## 🚀 Quick Start (Any Terminal)

### Check Status
```bash
curl -s http://localhost:8000/health -H "Authorization: Bearer glm-proxy-key" | jq
```

### Start Proxy
```bash
# For bash/zsh
~/AI/claude-glm-proxy/bin/start-proxy-bash

# For fish
~/AI/claude-glm-proxy/bin/start-proxy
```

### Use GLM-4.6
```bash
# For bash/zsh
~/AI/claude-glm-proxy/bin/claude-glm-bash "Your prompt here"

# For fish
~/AI/claude-glm-proxy/bin/claude-glm "Your prompt here"
```

### Stop Proxy
```bash
# For bash/zsh
~/AI/claude-glm-proxy/bin/stop-proxy-bash

# For fish
~/AI/claude-glm-proxy/bin/stop-proxy
```

## 📝 Common Commands

### Simple Question
```bash
~/AI/claude-glm-proxy/bin/claude-glm-bash "What is 2+2?"
```

### Code Generation
```bash
~/AI/claude-glm-proxy/bin/claude-glm-bash "Write a Python function to calculate factorial"
```

### Complex Analysis
```bash
~/AI/claude-glm-proxy/bin/claude-glm-bash "Explain the differences between REST and GraphQL APIs"
```

## 🔧 Direct API Usage

### Basic Request
```bash
curl -s -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Authorization: Bearer glm-proxy-key" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "messages": [{"role": "user", "content": "Hello!"}],
    "max_tokens": 500
  }' | jq -r ".choices[0].message.content"
```

### With System Prompt
```bash
curl -s -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Authorization: Bearer glm-proxy-key" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "messages": [
      {"role": "system", "content": "You are a helpful coding assistant."},
      {"role": "user", "content": "Write a regex for email validation"}
    ],
    "max_tokens": 1000
  }' | jq -r ".choices[0].message.content"
```

## 🧪 Testing

### Run Test Suite
```bash
~/AI/claude-glm-proxy/tests/test_glm.sh
```

### Quick Health Check
```bash
~/AI/claude-glm-proxy/bin/claude-glm-bash "Say 'OK' if you're working" | grep -q "OK" && echo "✅ Working!" || echo "❌ Not working"
```

## 💡 Shell Aliases

Add to your shell config file:

### Bash/Zsh (~/.bashrc or ~/.zshrc)
```bash
alias glm='~/AI/claude-glm-proxy/bin/claude-glm-bash'
alias glm-start='~/AI/claude-glm-proxy/bin/start-proxy-bash'
alias glm-stop='~/AI/claude-glm-proxy/bin/stop-proxy-bash'
alias glm-test='~/AI/claude-glm-proxy/tests/test_glm.sh'
```

### Fish (~/.config/fish/config.fish)
```fish
alias glm='~/AI/claude-glm-proxy/bin/claude-glm'
alias glm-start='~/AI/claude-glm-proxy/bin/start-proxy'
alias glm-stop='~/AI/claude-glm-proxy/bin/stop-proxy'
alias glm-test='~/AI/claude-glm-proxy/tests/test_glm.sh'
```

After adding aliases, reload your shell config:
```bash
# Bash
source ~/.bashrc

# Zsh
source ~/.zshrc

# Fish
source ~/.config/fish/config.fish
```

Then use:
```bash
glm-start           # Start proxy
glm "Your prompt"   # Use GLM-4.6
glm-test           # Run tests
glm-stop           # Stop proxy
```

## 🔍 Troubleshooting

### Check if proxy is running
```bash
ps aux | grep litellm
```

### View logs
```bash
tail -f ~/AI/claude-glm-proxy/logs/proxy.log
```

### Kill stuck proxy
```bash
pkill -f litellm
```

### Test with verbose output
```bash
curl -v -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Authorization: Bearer glm-proxy-key" \
  -H "Content-Type: application/json" \
  -d '{"model": "claude-3-5-sonnet-20241022", "messages": [{"role": "user", "content": "test"}], "max_tokens": 10}'
```

## 📊 Model Info

- **Model**: GLM-4.6 (ChatGLM by Zhipu AI)
- **Provider**: OpenRouter → Novita/AtlasCloud
- **Context Window**: ~128K tokens
- **Languages**: Excellent at both English and Chinese
- **Strengths**: Code generation, reasoning, analysis, creative writing
- **Special Feature**: Shows reasoning process in `reasoning_content` field