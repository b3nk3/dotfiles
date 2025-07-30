# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [ ! -d $ZINIT_HOME ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:$HOME/.npm-global/bin
# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export EDITOR="code --wait"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export DOCKER_HOST="unix:///Users/benszabo/.config/colima/default/docker.sock"

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::aws

# brew completion
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(oh-my-posh init zsh --config $HOME/ohmyposh/zen.toml)"

# keybindings
# bindkey '^f' autosuggest-accept
bindkey "^[[3~" delete-char

# bindkey history search to option+up/down
bindkey '^[^[[A' history-search-backward
bindkey '^[^[[B' history-search-forward
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -color $realpath'

brew_install_and_dump() {
  brew install "$@" && brew bundle dump --force --no-upgrade
}

# Aliases
alias ls='ls --color'
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(mise activate zsh)"
