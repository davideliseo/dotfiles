if status is-interactive
    # Vi mode by default; use `fish_default_key_bindings` to go back to default mode
    # List of vi mode commands: https://fishshell.com/docs/current/interactive.html
    clear
    fish_vi_key_bindings
end

eval (/opt/homebrew/bin/brew shellenv)
source /opt/homebrew/opt/asdf/libexec/asdf.fish
starship init fish | source
zoxide init fish | source
status --is-interactive; and rbenv init - fish | source

alias ls="eza"
alias jo="joshuto"

export VISUAL="nvim"
export EDITOR="nvim"
export CHROME_EXECUTABLE="/Applications/Google Chrome Dev.app/Contents/MacOS/Google Chrome Dev"
fish_add_path $HOME/.local/share/gem/ruby/3.2.0/bin
fish_add_path $HOME/.pub-cache/bin
fish_add_path $HOME/Library/Android/sdk
fish_add_path /Applications/Alacritty.app/Contents/MacOS

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
