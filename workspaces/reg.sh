#!/usr/bin/env fish

if not command -v tmux >/dev/null
    echo "Error: tmux is not installed!"
    echo "Install it with: brew install tmux (macOS) or your package manager"
    exit 1
end

echo "Iniciando sesiones tmux..."

# tmux kill-session -t api 2>/dev/null
# tmux kill-session -t ui 2>/dev/null

echo "Creando sesión api..."

tmux new-session -d -s api
tmux send-keys -t api:0 'z reg api' C-m
tmux send-keys -t api:0 'DOTNET_USE_POLLING_FILE_WATCHER=1 dotnet run --project Application -v diag'

tmux new-window -t api
tmux send-keys -t api:1 'z reg api' C-m
tmux send-keys -t api:1 'ssh-add ~/.ssh/devops && nvim' C-m

echo "Creando sesión ui"

tmux new-session -d -s ui
tmux send-keys -t ui:0 'z reg ui' C-m
tmux send-keys -t ui:0 'rm -rf .next && npm run dev:host' C-m

tmux new-window -t ui
tmux send-keys -t ui:1 'z reg ui' C-m
tmux send-keys -t ui:1 'ssh-add ~/.ssh/devops && nvim' C-m

echo "Creando sesión dwh"

tmux new-session -d -s dwh
tmux send-keys -t dwh:0 'z dwh' C-m
tmux send-keys -t dwh:0 'DOTNET_USE_POLLING_FILE_WATCHER=1 dotnet run -c Development --project Fx.Bussines.DataWareHouse.Api --verbosity diag --urls=http://localhost:50123/' C-m

tmux new-window -t dwh
tmux send-keys -t dwh:1 'z dwh' C-m
tmux send-keys -t dwh:1 'ssh-add ~/.ssh/devops && nvim' C-m

echo "Creando sesión i18n"

tmux new-session -d -s i18n
tmux send-keys -t i18n:0 'z locale && cd src/Application/Fx.Translation.Fn/' C-m
tmux send-keys -t i18n:0 'DOTNET_USE_POLLING_FILE_WATCHER=1 func start'

tmux new-window -t i18n
tmux send-keys -t i18n:1 'z locale' C-m
tmux send-keys -t i18n:1 'ssh-add ~/.ssh/devops && nvim translate/es.json' C-m

tmux attach -t api
