function portainer --description 'Toggle local Portainer on TufTux'
    set -l compose "$HOME/services/portainer/compose.yaml"

    if not test -f "$compose"
        echo "Portainer: fichier introuvable : $compose" >&2
        return 1
    end

    if not docker info >/dev/null 2>&1
        echo "Portainer: Docker n'est pas accessible." >&2
        return 1
    end

    set -l running (docker inspect --format '{{.State.Running}}' portainer-local 2>/dev/null)

    if test "$running" = true
        docker compose -f "$compose" -p portainer-local down
        or return $status
        echo "Portainer arrêté."
    else
        docker compose -f "$compose" -p portainer-local up -d
        or return $status
        echo "Portainer démarré : https://localhost:9443"
    end
end
