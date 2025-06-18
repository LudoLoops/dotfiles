function start_docker
    echo "🚀 Starting Docker service..."
    sudo systemctl start docker
    while not systemctl is-active docker >/dev/null
        echo "⏳ Waiting for Docker to start..."
        sleep 1
    end
    echo "✅ Docker has started"
end

function stop_docker
    echo "🛑 Stopping Docker service..."
    sudo systemctl stop docker
    echo "✅ Docker has stopped"
end
function dockcontrol
    switch $argv[1]
        case start
            if not systemctl is-active docker >/dev/null
                start_docker
            end
            echo "🐳 Starting Docker Compose services..."
            docker-compose up -d
            echo "✅ Docker Compose services have started"

        case stop
            echo "🛑 Stopping Docker Compose services..."
            docker-compose down
            stop_docker

        case restart
            echo "🔄 Restarting Docker Compose services..."
            docker-compose down
            docker-compose up -d
            echo "✅ Docker Compose services have restarted"

        case '*'
            echo "Usage: dockcontrol [command]"
            echo "Commands:"
            echo "  start   - Starts Docker and Docker Compose services"
            echo "  stop    - Stops Docker Compose services and Docker"
            echo "  restart - Restarts Docker Compose services"
    end
end
