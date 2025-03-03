# ==============================================================================
# ZINIT INSTALLATION AND INITIALIZATION
# ==============================================================================
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing ZINIT...%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ==============================================================================
# ZINIT PLUGINS AND ANNEXES
# ==============================================================================
# Load annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Add LS_COLORS for file/directory coloring
zinit lucid reset \
      atclone"gdircolors -b LS_COLORS > clrs.zsh" \
      atpull'%atclone' pick"clrs.zsh" nocompile'!' \
      atload'zstyle ":completion:*:default" list-colors "${(s.:.)LS_COLORS}";' for \
      trapd00r/LS_COLORS

# Initialize completion system
autoload -Uz compinit
compinit

zinit light zsh-users/zsh-completions

zinit wait lucid for \
      Aloxaf/fzf-tab

zinit wait'1' lucid for \
      zsh-users/zsh-history-substring-search

zinit wait'1' lucid atload'
     bindkey "^[[A" history-substring-search-up
     bindkey "^[[B" history-substring-search-down
     ' for zsh-users/zsh-history-substring-search

zinit light zdharma-continuum/history-search-multi-word
# zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
# zinit light spaceship-prompt/spaceship-prompt
# ==============================================================================
# ENVIRONMENT CONFIGURATION
# ==============================================================================
setopt autocd           # Enable autocd feature

export CLICOLOR=1

eval "$(starship init zsh)"

