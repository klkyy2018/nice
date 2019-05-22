# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

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
  docker
  docker-compose
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

######################################################################
## user's sys function
#######################################################################
# prevent TMUX to change the PATH
function PATH_CONFIGER {
  what_path_you_want_to_add=$1
  if [[ -z $TMUX ]]; then
    export PATH="$what_path_you_want_to_add:$PATH"
  fi
}

######################################################################
## user's sys config
#######################################################################
export EDITOR=vim
export DEV_HOME=$HOME/mydev
alias c='clear'
alias lla='ls -al'
alias zshenable="source ~/.zshrc"
# prevent ksshaskpath to work
unset SSH_ASKPASS

REPO_DEV=$DEV_HOME/repo
JAVA_DEV=$DEV_HOME/java
CPP_DEV=$DEV_HOME/cpp
GO_DEV=$DEV_HOME/go
PY_DEV=$DEV_HOME/python
USR_BIN=/usr/local/my
alias gowork="cd $DEV_HOME"
alias cdrepo="cd $REPO_DEV"
alias cdjava="cd $JAVA_DEV"
alias cdcpp="cd $CPP_DEV"
alias cdgo="cd $GO_DEV"
alias cdpy="cd $PY_DEV"

######################################################################
## user's software config
#######################################################################
# grpc & protobuf
export GRPC_HOME=$HOME/bin/grpc
export PB_HOME=$GRPC_HOME/protoc
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$GRPC_HOME/lib/pkgconfig:$PB_HOME/lib/pkgconfig
PATH_CONFIGER $GRPC_HOME/bin:$PB_HOME/bin

# maven
export MAVEN_HOME=$USR_BIN/apache-maven-3.6.0
PATH_CONFIGER $MAVEN_HOME/bin


# java
export JAVA_HOME=$USR_BIN/jdk1.8.0_201
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
PATH_CONFIGER $JAVA_HOME/bin

# go
export GOPATH=$DEV_HOME/go
export GOROOT=$USR_BIN/go
export GODEBUG=netdns=go
PATH_CONFIGER $GOROOT/bin

# mysql
MYSQL5725=$USR_BIN/mysql5.7.25
alias MYSQL=$MYSQL5725/bin/mysql
alias MYSQLD=$MYSQL5725/bin/mysqld
alias MYSQLD_SAFE=$MYSQL5725/bin/mysqld_safe

# KunDB
export MYSQL_FLAVOR="MySQL56"
export VT_MYSQL_ROOT="$USR_BIN/mysql57"
export VT_MARIA_ROOT="$USR_BIN/mariadb"
export kunDataRoot="$GOPATH/vtdataroot"
export kunHome="$GOPATH/src/github.com/youtube/vitess"
alias cdk="[ -d $kunHome ] && cd $kunHome || echo 'no kundb src directory'"
alias cddt="[ -d $kunDataRoot ] && cd $kunDataRoot || echo 'no kundb data directory'"

# charts
export kunChartsHome="$REPO_DEV/application-helmcharts/kundb/1.2"
alias sshcharts="sshpass -p "holoZhuo" ssh root@172.26.0.5"
alias sshidc="sshpass -p "holoZhuo" ssh root@172.16.3.231"
alias sshqiang="sshpass -p "inceptor" ssh root@172.16.3.241"
alias cdcharts="[ -d $kunChartsHome ] && cd $kunChartsHome || echo 'no charts directory'"

#rvm
PATH_CONFIGER $HOME/.rvm/bin
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# tmuxinator mux
_tmuxinator() {
  local commands projects
  commands=(${(f)"$(tmuxinator commands zsh)"})
  projects=(${(f)"$(tmuxinator completions start)"})

  if (( CURRENT == 2 )); then
    _alternative \
      'commands:: _describe -t commands "tmuxinator subcommands" commands' \
      'projects:: _describe -t projects "tmuxinator projects" projects'
  elif (( CURRENT == 3)); then
    case $words[2] in
      copy|debug|delete|open|start)
        _arguments '*:projects:($projects)'
      ;;
    esac
  fi

  return
}

compdef _tmuxinator tmuxinator mux
alias mux="tmuxinator"
unset -f PATH_CONFIGER 

