# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
ZSH_THEME="robbyrussell"

# Plugins
# plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
  git
  autojump
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker
)

source $ZSH/oh-my-zsh.sh

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:${unameOut}"
esac
export MACHINE

# Source aliases
# For a full list of active aliases, run `alias`.
if [[ "$MACHINE" == "Linux" ]];then
  PROJECT_ROOT="/mnt/c/Users/"$USER"/projects/dotfiles"
  source "$PROJECT_ROOT/env/aliases-shared.sh"
  source "$PROJECT_ROOT/env/aliases-linux.sh"
  source "$PROJECT_ROOT/env/exports.sh"
  source "$PROJECT_ROOT/env/functions.sh"
elif [[ "$MACHINE" == "Mac" ]]; then
  PROJECT_ROOT="/Users/$USER/dotfiles"
  source "$PROJECT_ROOT/env/aliases-shared.sh"
  source "$PROJECT_ROOT/env/aliases-mac.sh"
  source "$PROJECT_ROOT/env/exports.sh"
fi

# ClassPass config

# Huge history. Doesn't appear to slow things down, so why not?
HISTFILE=~/.zhistory
HISTSIZE=500000
HISTFILESIZE=100000

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '

##### Homebrew installed things #####
if hash brew 2> /dev/null; then
    BREW_PREFIX=/usr/local
else
    echo "Couldn't find Homebrew installation"
fi
if [ -n "$BREW_PREFIX" ]; then
    if [ -f $BREW_PREFIX/etc/profile.d/autojump.sh ]; then
        . $BREW_PREFIX/etc/profile.d/autojump.sh
    else
        echo "Couldn't find Homebrew-installed autojump"
        echo "Install it with: brew install autojump"
    fi
fi

##### Aliases #####
# Make colored 'ls' output legible
export LSCOLORS=ExFxCxDxBxegedabagacad
alias ls="ls -G"
alias sl="ls"
alias l="ls"
alias s="ls"
alias ll="ls -l"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."

alias grep='grep --color=auto'

### Git
function g {
    if [[ $# > 0 ]]; then
        git $@
    else
        git st
    fi
}
alias gti='git'
alias gitl='git l -n3'
alias gitb='git branch'
alias gitd='git diff'
alias master="git checkout master"
alias amd="git commit -a --amend --no-edit"
alias yoink='git stash && git pull && git stash pop'
alias yolo='git push -f'

### Maven
alias mci='mvn clean install'
alias mcit='mci -DskipTests'
alias mcp='mvn clean package'
alias mcpt='mcp -DskipTests'
alias mct="mvn clean test"

### Gradle
alias gr="./gradlew"
alias gw="./gradlew"
alias gcb="./gradlew clean build"

### Docker
alias dk=docker
alias dkc=docker-compose
alias dcu='docker-compose up'
alias dcb='docker-compose build base'
# Show all running containers
alias dps='docker ps --format "table {{.ID}}\t{{.CreatedAt}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}"'
# Stop all containers
alias dsa='docker stop $(docker ps -q)'
# Remove all containers
alias drm='docker rm $(docker ps --filter 'status=exited' --format '{{.ID}}' | xargs)'
# Remove all images
alias drmi='docker rmi $(docker images | grep ^classpass | tr -s " " | cut -f 3 -d " " | xargs)'
# Remove everything Docker knows about
alias docker-smash='dsa; docker rm $(docker ps -a -q); docker system prune -a; docker volume rm $(docker volume ls -q)'
# Login to ECR
docker-login () {
  saml2aws login --skip-prompt -p default --session-duration=43200;
}

### Python
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export WORKON_HOME=~/.venvs
mkdir -p $WORKON_HOME
eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy

cp-etp-pip-error() {
    # looks at the return code of the last call (pip calls), and if it has a non-zero exit code, 
    # gives this error and note about setting up python
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "Error installing python packages. If error is about missing a ClassPass package, "
        echo "please setup your local environment for python. "
        echo "https://docs.classpass.engineering/engineering-practices/services/builds/registries/python/"
    fi
}

enter-the-python() {
    NAME=$(basename `pwd`)

    # If the project specifies a version but it's not installed, install that version
    pyenv version > /dev/null
    if [[ $? -ne 0 ]]; then
        if [[ -f .python-version ]]; then
            VERSION=$(cat .python-version)
            echo "Installing Python $VERSION"

            pyenv install "$VERSION"
        else
            echo "Don't know what Python version to install (no .python-version file)"
            echo "See output of `pyenv version` for details"
        fi
    fi

    workon "$NAME" 2> /dev/null
    if [[ $? -ne 0 ]]; then
        # If there isn't a virtualenv setup for the project create it
        echo "Creating virtualenv for $NAME"

        mkvirtualenv "$NAME"
        workon "$NAME"

        # And install any necessary dependencies
        if [[ -f "requirements.txt" ]]; then
            pip install -r requirements.txt
            cp-etp-pip-error
        fi
        if [[ -f "setup.py" ]]; then
            pip install -e .
            cp-etp-pip-error
        fi
    fi
}

#SDKMAN Aliases
j8 () {
    sdk use java 8.0.292-zulu; # remember to set this to the version you installed
}

j11 () {
    sdk use java 11.0.11-zulu; # remember to set this to the version you installed
}

# useful to reference in your shell prompt so you know which version is currently active
java_version () {
  sdk c java | grep -Eo "[0-9]+\.[0-9]+\..*"
}

### ClassPass deployment
alias deploy-dev='cp_tools deploy_development update_service'
alias deploy-prod='cp_tools deploy_production update_service'
alias info-dev='cp_tools deploy_development service_info -h'
alias info-prod='cp_tools deploy_production service_info -h'

alias ij="open /Applications/IntelliJ\ IDEA.app" # open ij from a shell -- useful as it brings in all your env variables

saml2aws login --skip-prompt -pdefault
export PATH="/usr/local/opt/postgresql@9.5/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"

#JFrog Config
export CP_JFROG_READ_USERNAME=noah.pan
export CP_JFROG_PYPI_URL=https://classpassengineering.jfrog.io/artifactory/api/pypi/pypi-local/simple
#Get jfrog api key through another file
source ./.jfrog_env

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/noah.pan/.sdkman"
[[ -s "/Users/noah.pan/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/noah.pan/.sdkman/bin/sdkman-init.sh"
