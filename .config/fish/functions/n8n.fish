# Définir une variable globale persistante 
set -gx N8N_DIR /home/loops/1Dev/app/n8n

function n8n-start
    pushd $N8N_DIR >/dev/null
    docker-compose up -d
    and xdg-open http://localhost:5678
    popd >/dev/null
end

function n8n-stop
    pushd $N8N_DIR >/dev/null
    docker-compose down
    popd >/dev/null
end

function n8n-logs
    pushd $N8N_DIR >/dev/null
    docker-compose logs -f
    popd >/dev/null
end
