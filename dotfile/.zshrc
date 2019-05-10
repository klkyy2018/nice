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
## user's sys config
#######################################################################
export EDITOR=vim
export DEV_HOME=$HOME/mydev
alias c='clear'
alias lla='ls -al'
alias zshenable="source ~/.zshrc"

REPO_DEV=$DEV_HOME/repo
JAVA_DEV=$DEV_HOME/java
CPP_DEV=$DEV_HOME/cpp
GO_DEV=$DEV_HOME/go
PY_DEV=$DEV_HOME/python
USR_BIN=/usr/local/bin
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
export PATH=$PATH:$GRPC_HOME/bin:$PB_HOME/bin

# maven
export MAVEN_HOME=$USR_BIN/apache-maven-3.6.0
export PATH=$MAVEN_HOME/bin:$PATH

# java
export JAVA_HOME=$USR_BIN/jdk1.8.0_201
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=$JAVA_HOME/bin:$PATH

# go
export PATH=$PATH:$USR_BIN/go/bin
export GOPATH=$DEV_HOME/go
export GOROOT=$USR_BIN/go
export GODEBUG=netdns=go

# KunDB
export MYSQL_FLAVOR="MySQL56"
export VT_MYSQL_ROOT="$USR_BIN/mysql57"
export kunDataRoot="$GOPATH/vtdataroot"
export kunHome="$GOPATH/src/github.com/youtube/vitess"
alias cdk="[ -d $kunHome ] && cd $kunHome || echo 'no kundb src directory'"
alias cddt="[ -d $kunDataRoot ] && cd $kunDataRoot || echo 'no kundb data directory'"

# charts
export kunChartsHome="$REPO_DEV/application-helmcharts/kundb/1.1"
alias charts="[ -d $kunChartsHome ] && cd $KunChartsHome || echo 'no charts directory'"

# tmp
alias sshgreat="ssh greatwall@172.16.7.18"

#rvm
export PATH=$PATH:$HOME/.rvm/bin
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


