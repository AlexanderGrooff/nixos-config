# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='grep -E --color=auto'
fi

command -v nvim &> /dev/null && alias vim=nvim

# Show all services listening to ports
alias lsofp='lsof -Pnl +M -i4'

# some more ls aliases
alias ll='ls -hlAF'

# mkdir goes to created dir
function mkd {
    mkdir "$1"
    cd "$1"
}
alias lln="ls -lhtr  --time-style long-iso | tac | cat -n | tac | sed -s 's/^\s*\([0-9]*\)\s*\(.*\)/[\1]  \2 [\1]/'g && pwd"
function lf {
    if [ $# -eq 0 ];
    then
        local n=1
    else
        local n="${1}"
    fi
    ls -rt1 | tail -n ${n} | head -n 1
}

function expand_dirs {
    # Expand ... to ../..
    function vbe-expand-dot-to-parent-directory-path() {
      case $LBUFFER in
        (./..|* ./..) LBUFFER+='.' ;; # In Go: "go list ./..."
        (..|*[ /=]..) LBUFFER+='/..' ;;
        (*) LBUFFER+='.' ;;
      esac
    }
    zle -N vbe-expand-dot-to-parent-directory-path
    bindkey "." vbe-expand-dot-to-parent-directory-path
    bindkey -M isearch "." self-insert
}
expand_dirs

function log() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` \
      --bind "ctrl-m:execute:
                echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R'"
}
# Grep from $1 until $2 in $3+
function gu() {
    sed -n -e "/$1/,/$2/ p" ${@:3}
}

# git aliases
alias gsp='git stash pop'
alias gcm='/home/alex/scripts/git_checkout_master.sh'
alias gp='git pull'
alias gc='git commit -v'
alias gca='git commit --amend -v'
alias gdf='git diff'
alias gpb='git checkout -'
alias grh='git reset --hard'
alias gph='git push -u origin HEAD'
alias doit='ga .; gca --no-edit; gpf'
alias gitparent='git show-branch |& grep "*" | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed "s/.*\[\(.*\)\].*/\1/" | sed "s/[\^~].*//"'
function gch {
    local target="$@"  # All arguments. Don't checkout '-b' of `gch -b target-branch`
    # Check if target is a github url
    if [[ $target == *"github.com"* ]]; then
        local local_repo=$(git remote get-url origin | cut -d: -f2 | sed 's/.git//g')
        if [[ $target == *"$local_repo"* ]]; then
            local pr_nr=$(echo $target | sed -r 's/.*\/pull\/([0-9]+)/\1/g')
            gh pr checkout $pr_nr
        else
            echo "Tried checkout but target repo does not match $local_repo"
        fi
    else
        # Echo multiple args
        git checkout $(echo $target)
    fi
}
function gpr {
    local tmpfile=$(mktemp)
    trap "rm $tmpfile" EXIT
    local initial_title=$(git log --pretty=format:%s HEAD~1..HEAD)
    local initial_body=$(git log --pretty=format:%b HEAD~1..HEAD | tr '\n' ' ' | sed 's/^ //g')

    echo $initial_title > $tmpfile
    echo "" >> $tmpfile
    echo $initial_body >> $tmpfile
    $EDITOR $tmpfile
    local title=$(cat $tmpfile | head -n1)
    local body=$(cat $tmpfile | tail -n+3)

    local url=$(gh pr create --title "$title" --body "$body" | tail -n1)
    echo "$url $title"
}
function rmcommit {
    # Get all commits up to the given commit
    commits=`git log $1..HEAD --pretty=format:%H`
    echo "Stashing changes"
    git stash
    echo "\nSetting HEAD to just before commit $1"
    git reset --hard $1~1
    echo "\nApplying inbetween commits: $commits"
    echo $commits | xargs git cherry-pick
    echo "\nPopping stash"
    git stash pop
}

# Kubernetes aliases
alias k='kubectl'
alias kubeload='kubectl get node -o json | jq -r ".items[].metadata.name" | xargs -I {} ssh {} "hostname; w; echo"'

# docker aliases
alias drmc='docker rm $(docker ps -qa --no-trunc --filter "status=exited")'
alias drmi='docker rmi $(docker images -a --filter=dangling=true -q)'
alias drmv='docker volume ls -qf dangling=true | xargs -r docker volume rm'
alias dc='docker-compose'
function dcip {
    local DC_NAME=$1
    local DC_PROJECT=$(basename $(pwd))
    dc ps -q $DC_NAME | xargs docker inspect | jq -r ".[0].NetworkSettings.Networks.${DC_PROJECT}_default.IPAddress"
}
function katt {
    dc kill $1
    dc rm -f $1
    dc up --force-recreate -d $1
}

# Web development
alias wpb='./node_modules/.bin/webpack --progress --config webpack.config.js --colors'

# Commonly used repos
alias dotf='cd /home/alex/code/dotfiles'

# Systemctl aliases
alias susy='sudo systemctl'
complete -F _complete_alias susy

# Pip stuff
alias pir='pip install -r requirements/development.txt'

alias s='ssh -o stricthostkeychecking=no -o userknownhostsfile=/dev/null'
function jh {
    if ping -c1 -W1 alpha 2&>1 /dev/null; then
        ssh -D 5000 jh -J alpha
    else
        ssh -D 5000 jh
    fi
}

# Venv stuff
alias de='cd ~; deactivate'

export DISTROBOX_DEFAULT_NAME=debian-buster
function dbe {
    if [ $DISTROBOX_ENTER_PATH ]; then
        echo "Distrobox is already active"
        exit 1
    fi
    local db_name=${1:-$DISTROBOX_NAME}
    if [ -n "$db_name" ]; then
        echo "Entering distrobox $db_name"
        distrobox enter --name $db_name
    else
        echo "Assuming default distrobox $DISTROBOX_DEFAULT_NAME"
        distrobox enter --name $DISTROBOX_DEFAULT_NAME
    fi
}
function dbb {
    if [ $DISTROBOX_ENTER_PATH ]; then
        echo "Distrobox is already active"
        exit 1
    fi
    local name=${DISTROBOX_NAME:-$DISTROBOX_DEFAULT_NAME}

    echo "Making $name in $PWD"
    if [ -f .distrobox/.env ]; then
        docker build $(eval $(cat .distrobox/.env | xargs echo eval echo) | xargs -n1 echo --build-arg) -t distrobox-$name $1 .distrobox/
    else
        docker build -t distrobox-$name $1 .distrobox/
    fi
    distrobox list | grep -q $name && distrobox rm $name -f
    distrobox create --image distrobox-$name $name
}

# Create venv in current dir
function mkv {
    if [[ `command -v poetry` ]]; then
        if [ -f poetry.lock ]; then
            poetry install
            return
        fi
    fi
    local venv_name=$(basename $(pwd))
    if [ -z $VIRTUAL_ENV ]; then
        mkvirtualenv -a . -p python3 $venv_name $1
    else
        echo "Virtualenv $(basename $VIRTUAL_ENV) already active, not making new one"
    fi

    if [ -f requirements.txt ]; then
        pip install -r requirements.txt
    elif [ -f requirements/development3.txt ]; then
        pip install -r requirements/development3.txt
    elif [ -f requirements/development.txt ]; then
        pip install -r requirements/development.txt
    fi

    if [[ `command -v pre-commit` ]]; then
        pre-commit install --allow-missing-config
    fi

}
alias rt='$(cat $VIRTUAL_ENV/$VIRTUALENVWRAPPER_PROJECT_FILENAME)/runtests.sh -1'

# On Buster, fd is installed under fdfind
if [ -x /usr/bin/fdfind ]; then
    alias fd='fdfind'
fi

# Utilities
alias sum='python -c "import sys; print(sum(int(l) for l in sys.stdin))"'
alias chmox="chmod +x"

function check_cert {
    local DOMAIN=$1
    openssl s_client -connect $DOMAIN:443 -servername $DOMAIN < /dev/null 2>/dev/null | openssl x509 -noout -subject -issuer -dates
}
alias check_domain=check_cert

function which {
    # Source of which on fedora
    which_declare="declare -f"
    which_opt="-f"
    which_shell="$(cat /proc/$$/comm)"

    if [ "$which_shell" = "ksh" ] || [ "$which_shell" = "mksh" ] || [ "$which_shell" = "zsh" ] ; then
        which_declare="typeset -f"
        which_opt=""
    fi

    ( alias; eval ${which_declare} ) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot "$@"

    export which_declare
    export ${which_opt} which
}

# Tasks
alias t='task'
alias tw='timew'

# Nomad
function get_nomad_alloc_id {
    nomad job status -verbose $1 | grep $1 | grep running | cut -d' ' -f1
}
function nl {
    get_nomad_alloc_id $1 | xargs -P 2 -I {} nomad alloc logs "${@:2}" {}
}

# yay browser
function yay-ls () {
    yay -Slq | fzf -m --preview 'cat <(yay -Si {1}) <(yay -Fl {1} | awk "{print \$2}")' | xargs -ro  yay -S
}

# Activate venv based on directory name
function wo {
    workon $(basename $PWD)
}
alias start_all_distroboxes="distrobox list | awk '{print\$3}' | grep -v NAME | xargs -n1 distrobox enter"
alias stop_all_distroboxes="distrobox list | grep Up | awk '{print\$3}' | xargs -n1 distrobox stop -Y"
alias mutt=neomutt
if [[ $(command -v gem) ]]; then
    export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
    export PATH="$PATH:$GEM_HOME/bin"
fi
alias sus='sort | uniq -c | sort -n'
function compare_ns {
    echo "nsa.byte.nl: $(dig @nsa.byte.nl $1 +short +all)"
    echo "ns1.hypernode.com: $(dig @ns1.hypernode.com $1 +short +all)"
}
alias hm="home-manager"
alias hms='nix run home-manager/master -- switch --flake ".#$(hostname)"'
