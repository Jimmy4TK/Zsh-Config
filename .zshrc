#  ╔═╗╔═╗╦ ╦╦═╗╔═╗  ╔═╗╔═╗╔╗╔╔═╗╦╔═╗	- Jimmy4TK
#  ╔═╝╚═╗╠═╣╠╦╝║    ║  ║ ║║║║╠╣ ║║ ╦	- https://github.com/Jimmy4TK/Zsh-Config
#  ╚═╝╚═╝╩ ╩╩╚═╚═╝  ╚═╝╚═╝╝╚╝╚  ╩╚═╝	- oh my zsh conf

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ======================================================================
# Variables de entorno
# ======================================================================

export ZSH="/usr/share/zsh"
export EDITOR='nvim'
export BROWSER='firefox'
export VISUAL="${EDITOR}"
export SUDO_PROMPT="Usuario pijudo para %u. Password pls:"

# ======================================================================
# Opciones
# ======================================================================

setopt autocd

# ======================================================================
# Historial
# ======================================================================

export HISTORY_IGNORE="(ls|cd|pwd|exit*|clear|sudo reboot|history|cd -|cd ..)"
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt sharehistory

# Historial: no guardar los comandos que fallan.
# zshaddhistory corre ANTES de ejecutar, así que retiene la línea y precmd la guarda
# recién al conocer el exit status. Con `return 1` la línea fallida sigue disponible
# con flecha arriba hasta ejecutar la siguiente, para poder corregirla.
# 130/141/143 (Ctrl-C, SIGPIPE, SIGTERM) no son errores del comando: se guardan.
_hist_pending=""
_hist_last=""
_hist_hold() {
  _hist_pending="${1%%$'\n'}"
  return 1
}
_hist_commit() {
  local exit_status=$?
  [[ -z $_hist_pending ]] && return
  case $exit_status in
    0|130|141|143)
      # el duplicado se filtra acá
      if [[ $_hist_pending != $_hist_last ]]; then
        print -Sr -- "$_hist_pending"
        fc -AI  # sin esto, recién se escribe al ejecutar el comando siguiente
        _hist_last=$_hist_pending
      fi
      ;;
  esac
  _hist_pending=""
}
autoload -Uz add-zsh-hook
add-zsh-hook zshaddhistory _hist_hold
precmd_functions=(_hist_commit $precmd_functions)

# ======================================================================
# Completado
# ======================================================================

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ======================================================================
# Atajos de teclado
# ======================================================================

bindkey -e
bindkey '^[[Z' reverse-menu-complete
# Flechas: buscan en el historial por el prefijo ya escrito.
# Se bindean las dos secuencias: ^[[A (modo normal) y ^[OA (modo application).
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[OA' history-beginning-search-backward
bindkey '^[OB' history-beginning-search-forward
bindkey -s ^f "$HOME/.config/tmux/sessionizer.sh \r"

# ======================================================================
# Plugins
# ======================================================================

plugins=(zsh-autosuggestions zsh-syntax-highlighting)

for plugin in "${plugins[@]}"; do
  source $ZSH/plugins/$plugin/${plugin}.plugin.zsh
done
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#aa7c7c'

# ======================================================================
# Prompt
# ======================================================================

function dir_align_right {
  
  if [[ "$PWD" =~ "$HOME".* ]]; then
    (( spare_width =  ${COLUMNS} - ${#PWD} + ${#HOME} - 1))
  else
    (( spare_width = ${COLUMNS} - ${#PWD} ))
  fi

  prompt="$(printf '%*s' "$spare_width" '')%~"
  PROMPT="$prompt%2{%(?.%B%F{#7bda70}❯ .%B%F{#f37f97}❯ )%f%b%}"
  

}

# Cargamos el promp de git
git_prompt_info(){
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    git_prefix="%1{%B%F{#ff5733}%b%f%}"
    branch="$(git symbolic-ref --short HEAD 2>/dev/null)"
    git_status=$( [[ $(git status --porcelain) ]] && echo "%1{%B%F{#900c0c}✗%b%f%}" || echo "%1{%B%F{#7bda70}✓%b%f%}")
    RPROMPT="$git_prefix $branch $git_status"
  else
    RPROMPT=""
  fi
}

# Hook que ejecuta la función antes de mostrar el prompt
add-zsh-hook precmd dir_align_right
add-zsh-hook precmd git_prompt_info

# ======================================================================
# Integraciones y alias
# ======================================================================

# Funciones propias o de otras configuraciones, como BSPWM
if [ -f ~/.zsh_functions ]; then
  . ~/.zsh_functions
fi

# Los alias son de cada uno: van en ~/.zsh_aliases, que no se versiona.
# Se cargan al final para poder pisar los de las integraciones.
if [ -f ~/.zsh_aliases ]; then
  . ~/.zsh_aliases
fi

# ======================================================================
# Funciones
# ======================================================================

command_not_found_handler() {
	printf "Que re poronga es %s?\n" "$0" >&2
    return 127
}

# ======================================================================
# Entornos y PATH
# ======================================================================

# El orden importa: lo último que se agrega al PATH tiene prioridad.
# Busqueda de binarios y sus scripts
[ -s "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
[ -s "$HOME/.autoenv/activate.sh" ] && source "$HOME/.autoenv/activate.sh"

# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"

# opencode
export PATH=$HOME/.opencode/bin:$PATH
