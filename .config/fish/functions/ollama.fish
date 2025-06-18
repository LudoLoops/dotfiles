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

function ollama-status
    if pgrep -x ollama >/dev/null
        echo "✅ Ollama is running."
    else
        echo "⛔ Ollama is not running."
    end
end
