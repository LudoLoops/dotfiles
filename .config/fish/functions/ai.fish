# =============================================================================
# AI & ML Tools
# =============================================================================

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
