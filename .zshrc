# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
export ZSH_THEME="agnoster"
export EDITOR=nvim
export CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  taskwarrior
)

export PATH=$PATH:$HOME/bin:$HOME/.local/bin:$HOME/scripts:/sbin:$HOME/.cargo/bin:$HOME/npm/bin:/usr/local/go/bin:$HOME/go/bin:$HOME/.pub-cache/bin

source $ZSH/oh-my-zsh.sh

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ZSH bindkeys
if [ -f ~/.zsh_keys ]; then
    . ~/.zsh_keys
fi

# Activate virtualenvwrapper
if [[ $(command -v virtualenvwrapper.sh) ]]; then
    source virtualenvwrapper.sh
else
    VEW_SCRIPT=$(dpkg -L virtualenvwrapper |& grep -E 'virtualenvwrapper.sh$')
    if [ $VEW_SCRIPT ]; then
        source $VEW_SCRIPT
    fi
fi

# Set keyboard rate and delay
if [[ `command -v xset` && -n $DISPLAY ]]; then
    xset r rate 175 45
fi

# Use fd for fzf
if [ -x /usr/bin/fdfind ]; then
    export FZF_DEFAULT_COMMAND='fdfind --hidden --exclude ".git" .';
else
    export FZF_DEFAULT_COMMAND='fd --hidden --exclude ".git" .';
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if [[ `command -v podman` ]]; then
    export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
else
    unset DOCKER_HOST
fi

if [[ `command -v doctl` ]]; then source <(doctl completion zsh); fi
if [[ `command -v kubectl` ]]; then source <(kubectl completion zsh); fi
if [[ `command -v flux` ]]; then source <(flux completion zsh); fi

if [ -f $HOME/kubeconfig ]; then
    export KUBECONFIG=$HOME/kubeconfig
elif [ -f $HOME/.kube/config ]; then
    export KUBECONFIG=$HOME/.kube/config
fi

if [[ `command -v direnv` ]]; then eval "$(direnv hook zsh)"; fi

if [ -f /etc/bash_completion.d/complete_alias ]; then
    source /etc/bash_completion.d/complete_alias
fi

if [[ `command -v flutter` ]]; then
    #export JAVA_HOME='/usr/lib/jvm/java-8-openjdk'
    #export PATH=$JAVA_HOME:$PATH
    source <(flutter bash-completion)
fi
if [[ `command -v op` ]]; then
    eval "$(op completion zsh)"; compdef _op op
fi
if [[ `command -v gh` ]]; then
    eval "$(gh completion -s zsh)"
fi
if [[ `command -v github-copilot-cli` ]]; then
    eval "$(github-copilot-cli alias -- '$0')"
fi
if [[ `command -v gem` ]]; then
    export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
    export PATH="$PATH:$GEM_HOME/bin"
fi
if [[ `command -v gnome-keyring-daemon` ]]; then
    eval $(gnome-keyring-daemon --components=pkcs11,secrets,ssh)
    export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh
fi

[ -f ~/.github_token.txt ] && export GITHUB_TOKEN=$(cat ~/.github_token.txt)

# Disable terminal beep
unsetopt beep
if [ -e /home/alex/.nix-profile/etc/profile.d/nix.sh ]; then . /home/alex/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
