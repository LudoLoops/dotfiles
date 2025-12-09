# =============================================================================
# AI & ML Tools
# =============================================================================
# n8n workflow automation, Ollama local LLM, future: Claude CLI, LM Studio

# Global n8n directory configuration
set -gx N8N_DIR /home/loops/1Dev/app/n8n

# n8n Start
# Starts n8n Docker Compose services and opens web UI
function n8n-start
    pushd $N8N_DIR >/dev/null
    docker-compose up -d
    and xdg-open http://localhost:5678
    popd >/dev/null
end

# n8n Stop
# Stops n8n Docker Compose services
function n8n-stop
    pushd $N8N_DIR >/dev/null
    docker-compose down
    popd >/dev/null
end

# n8n Logs
# Tails n8n Docker Compose logs
function n8n-logs
    pushd $N8N_DIR >/dev/null
    docker-compose logs -f
    popd >/dev/null
end

# Ollama Toggle
# Starts or stops the Ollama LLM server
# If running, stops it. If not running, starts it in detached mode.
function ollama-toggle
    # Check if Ollama server is running
    if pgrep -x ollama >/dev/null
        echo "🔴 Ollama is running → stopping..."
        # Kill the running Ollama server process
        pkill -f 'ollama serve'
    else
        echo "🟢 Ollama is not running → starting..."
        # Start Ollama server in a detached session (survives terminal close)
        setsid ollama serve >/dev/null 2>&1 &
    end
end

# Ollama Status
# Shows whether Ollama LLM server is running
function ollama-status
    if pgrep -x ollama >/dev/null
        echo "✅ Ollama is running."
    else
        echo "⛔ Ollama is not running."
    end
end
