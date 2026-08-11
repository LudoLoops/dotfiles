# SSH into aether via herdr — ignores SIGHUP from WezTerm window close
# Python wrapper keeps stdin/stdout intact (unlike nohup), only blocks SIGHUP
function aether
    python3 -c "import signal,os,sys; signal.signal(signal.SIGHUP, signal.SIG_IGN); os.execvp('herdr', ['herdr', '--remote', 'aether'])"
end
