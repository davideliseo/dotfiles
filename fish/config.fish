if status is-interactive
    # Vi mode by default; use `fish_default_key_bindings` to go back to default mode
    # List of vi mode commands: https://fishshell.com/docs/current/interactive.html
    clear
    fish_vi_key_bindings
end

fish_ssh_agent

eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

starship init fish | source
zoxide init fish | source
thefuck --alias | source

alias ls="eza -lah"
alias jo="joshuto"

export VISUAL="nvim"
export EDITOR="nvim"
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1

fish_add_path /home/deliseo/.dotnet/tools
