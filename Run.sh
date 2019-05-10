#!/bin/bash

MY_BIN=$HOME/bin
USR_BIN=/usr/local/my
DEV_HOME=$HOME/mydev
REPO_DEV=$DEV_HOME/repo
JAVA_DEV=$DEV_HOME/java
CPP_DEV=$DEV_HOME/cpp
GO_DEV=$DEV_HOME/go
PY_DEV=$DEV_HOME/python
read -t 10 -p "please enter your root password: " password
if [ -z $password ];then
  echo "timeout! please rerun this script..."
  exit 1
fi

function mk_code_dir {
    mkdir -p $REPO_DEV
    mkdir -p $JAVA_DEV
    mkdir -p $CPP_DEV
    mkdir -p $GO_DEV
    mkdir -p $PY_DEV
    mkdir -p $MY_BIN
    echo $password | sudo -S mkdir -p $USR_BIN
}

function install_zsh {
  if [ ! $(which zsh) ]; then
    echo $password | sudo -S yum install -y zsh
  else
    echo "zsh has been installed."
  fi
  if [ ! -d ~/.oh-my-zsh ];then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  else
    echo "oh-my-zsh has been installed."
  fi
}

function install_tmux {
  if [ ! -d ~/.tmux ]; then
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
  else
    echo "tmux has been installed."
  fi
}

function file_exists {
  file=$1
  [ -f $file ] && return 1 || return 0
}

path=$HOME/Downloads
function install_tar {
  file_name=$1
  file=$path/$file_name
  file_exists $file
  if [ $? -eq 1 ];then
    echo $password | sudo -S tar xzf $file -C /usr/local/my
  else
    echo "$file not exists, skip install it."
  fi
}

function install_rpm {
  rpm_file=$1 
  file=$path/$rpm_file
  file_exists $file
  if [ $? -eq 1 ];then
    echo $password | sudo -S rpm -ivh $file
    return 1
  else
    echo "$file not exists, skip install it."
    return 0
  fi
}

function install_jdk {
  install_tar jdk-8u201-linux-x64.tar.gz
}

function install_mvn {
  install_tar apache-maven-3.6.0-bin.tar.gz
}

function install_go {
  install_tar go1.11.linux-amd64.tar.gz
}

function install_docker {
    install_rpm docker-ce-18.06.3.ce-3.el7.x86_64.rpm
    if [ $? -eq 1 ];then
      echo $password | sudo -S usermod -aG docker ${USER}
    fi
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
    install_jdk
    install_mvn
    install_go
    install_docker
}

function config_centos {
  ln_dotfile 
  ln_vpn
}

mk_code_dir

read -n 1 -t 10 -p "Is this a new Centos?[Y/N] " newcentos
echo ""
case $newcentos in
Y|y)
  new_centos
  ;;
*)
  echo "this centos will be treated as configed centos."
  echo "rerun this script if this is a new centos!"
  ;;
esac

config_centos
