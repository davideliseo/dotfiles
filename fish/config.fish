if status is-interactive
    # Vi mode by default; use `fish_default_key_bindings` to go back to default mode
    # List of vi mode commands: https://fishshell.com/docs/current/interactive.html
    clear
    fish_vi_key_bindings
end

fish_ssh_agent

eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
source /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.fish

starship init fish | source
zoxide init fish | source
thefuck --alias | source

alias ls="eza -lah"
alias jo="joshuto"

export VISUAL="nvim"
export EDITOR="nvim"
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1
