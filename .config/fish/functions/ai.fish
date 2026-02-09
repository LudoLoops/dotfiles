# =============================================================================
# AI & ML Tools
# =============================================================================
# n8n workflow automation, Ollama local LLM, future: Claude CLI, LM Studio

# Global n8n directory configuration
set -gx N8N_DIR /home/loops/1Dev/app/n8n

# n8n Start
# Starts n8n Docker Compose services and opens web UI
function n8n-start
    if not test -d "$N8N_DIR"
        echo "❌ Error: n8n directory not found: $N8N_DIR"
        return 1
    end

    pushd $N8N_DIR >/dev/null || begin
        echo "❌ Error: failed to enter directory: $N8N_DIR"
        return 1
    end

    docker-compose up -d || begin
        echo "❌ Error: failed to start n8n services"
        popd >/dev/null
        return 1
    end

    xdg-open http://localhost:5678 || begin
        echo "⚠️  Warning: failed to open browser"
    end

    popd >/dev/null
    echo "✅ n8n started"
end

# n8n Stop
# Stops n8n Docker Compose services
function n8n-stop
    if not test -d "$N8N_DIR"
        echo "❌ Error: n8n directory not found: $N8N_DIR"
        return 1
    end

    pushd $N8N_DIR >/dev/null || begin
        echo "❌ Error: failed to enter directory: $N8N_DIR"
        return 1
    end

    docker-compose down || begin
        echo "❌ Error: failed to stop n8n services"
        popd >/dev/null
        return 1
    end

    popd >/dev/null
    echo "✅ n8n stopped"
end

# n8n Logs
# Tails n8n Docker Compose logs
function n8n-logs
    if not test -d "$N8N_DIR"
        echo "❌ Error: n8n directory not found: $N8N_DIR"
        return 1
    end

    pushd $N8N_DIR >/dev/null || begin
        echo "❌ Error: failed to enter directory: $N8N_DIR"
        return 1
    end

    docker-compose logs -f || begin
        echo "❌ Error: failed to view n8n logs"
        popd >/dev/null
        return 1
    end

    popd >/dev/null
end

# Ollama Toggle
# Starts or stops the Ollama LLM server
# If running, stops it. If not running, starts it in detached mode.
function ollama-toggle
    # Check if Ollama command exists
    if not command -v ollama >/dev/null 2>&1
        echo "❌ Error: ollama is not installed"
        return 1
    end

    # Check if Ollama server is running
    if pgrep -x ollama >/dev/null
        echo "🔴 Ollama is running → stopping..."
        # Kill the running Ollama server process
        pkill -f 'ollama serve' || begin
            echo "❌ Error: failed to stop Ollama"
            return 1
        end
        echo "✅ Ollama stopped"
    else
        echo "🟢 Ollama is not running → starting..."
        # Start Ollama server in a detached session (survives terminal close)
        setsid ollama serve >/dev/null 2>&1 &

        # Wait a moment and verify it started
        sleep 1
        if pgrep -x ollama >/dev/null
            echo "✅ Ollama started"
        else
            echo "❌ Error: failed to start Ollama"
            return 1
        end
    end
end

# Ollama Status
# Shows whether Ollama LLM server is running
function ollama-status
    if not command -v ollama >/dev/null 2>&1
        echo "❌ Error: ollama is not installed"
        return 1
    end

    if pgrep -x ollama >/dev/null
        echo "✅ Ollama is running."
    else
        echo "⛔ Ollama is not running."
    end
end
