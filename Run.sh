#!/bin/bash
password="9102"
MY_BIN=$HOME/bin
REPO_DEV=$HOME/code/repo
JAVA_DEV=$HOME/code/java
CPP_DEV=$HOME/code/cpp
GO_DEV=$HOME/code/go
PY_DEV=$HOME/code/python

function mk_code_dir {
    mkdir -p $REPO_DEV
    mkdir -p $JAVA_DEV
    mkdir -p $CPP_DEV
    mkdir -p $GO_DEV
    mkdir -p $PY_DEV
    mkdir -p $MY_BIN
}

function install_zsh {
    echo $password | sudo -S yum install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

function install_tmux {
    echo $password | sudo -S yum install -y ncurses-devel libevent libevent-devel make
    cd $REPO_DEV
    git clone https://github.com/tmux/tmux.git
    cd tmux
    sh autogen.sh
    ./configure && make
    echo $password | sudo -S make install
    cd
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
}

function install_jdk {
    cp $HOME/Downloads/jdk-8u201-linux-x64.tar.gz /tmp
    cd /tmp && tar xzf jdk-8u201-linux-x64.tar.gz 
    echo $password | sudo -S mv jdk1.8.0_201 /usr/local
}

function install_mvn {
    cp $HOME/Downloads/apache-maven-3.6.0-bin.tar.gz /tmp
    cd /tmp && tar xzf apache-maven-3.6.0-bin.tar.gz
    echo $password | sudo -S mv apache-maven-3.6.0 /usr/local
}

function install_go {
    cp $HOME/Downloads/go1.12.linux-amd64.tar.gz /tmp
    cd /tmp && tar xzf go1.12.linux-amd64.tar.gz
    echo $password | sudo -S mv go /usr/local
}

function install_docker {
    cd $HOME/Downloads/
    echo $password | sudo -S rpm -ivh docker-ce-18.06.3.ce-3.el7.x86_64.rpm
    echo $password | sudo -S usermod -aG docker ${USER}
}

function ln_dotfile {
    cd 
    ln -sf $REPO_DEV/nice/dotfile/.zshrc
    ln -sf $REPO_DEV/nice/dotfile/.vimrc
    ln -sf $REPO_DEV/nice/dotfile/.gitconfig
    ln -sf $REPO_DEV/nice/dotfile/.tmux.conf.local
}

function ln_vpn {
    cd $MY_BIN
    ln -sf $REPO_DEV/nice/vpn/create_vpn.sh
    ln -sf $REPO_DEV/nice/vpn/vpn.sh 
}


function new_centos {
    install_zsh
    install_tmux
    ln_dotfile
    ln_vpn
    install_jdk
    install_go
    install_docker
}

function config_centos {
  ln_dotfile 
  ln_vpn
}

mk_code_dir
config_centos
