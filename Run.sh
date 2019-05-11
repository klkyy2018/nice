#!/bin/bash
MY_BIN=$HOME/bin
USR_BIN=/usr/local/my
DEV_HOME=$HOME/mydev
REPO_DEV=$DEV_HOME/repo
JAVA_DEV=$DEV_HOME/java
CPP_DEV=$DEV_HOME/cpp
GO_DEV=$DEV_HOME/go
PY_DEV=$DEV_HOME/python
read -t 10 -p "[sudo] password for $USER: " password
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
  if [ ! -d ~/.oh-my-zsh ]; then
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
  [ -f $1 ] && return 1 || return 0
}

path=$HOME/Downloads/newcentos
function install_package {
  file_type=$1
  file_name=$2
  echo "will install $file_name'...'"
  file=$path/$file_name
  install_flag="."$file_name"_installed"
  file_exists $file
  if [ $? -eq 1 ];then
    case $file_type in
    tar)
      if [ -f $USR_BIN/$install_flag ];then
        echo "$file has been installed."
      else
        echo $password | sudo -S tar xzf $file -C $USR_BIN
        sudo -S touch /usr/local/my/$install_flag
      fi
      ;; 
    rpm)
      echo $password | sudo -S yum install -y $file
      ;;
    *)
      echo "not support type!($file_type)"
      ;;
    esac
    return 1
  else
    echo "$file not exists, skip install it."
    return 0
  fi
}

function install_jdk {
  install_package tar jdk-8u201-linux-x64.tar.gz
}

function install_mvn {
  install_package tar apache-maven-3.6.0-bin.tar.gz
}

function install_go {
  install_package tar go1.11.linux-amd64.tar.gz
}

function install_clion {
  install_package tar CLion-2019.1.3.tar.gz
}

function install_intelij {
  install_package tar ideaIC-2019.1.2.tar.gz
}

function install_goland {
  install_package tar goland-2019.1.1.tar.gz
}

function install_pycharm {
  install_package tar pycharm-community-2019.1.2.tar.gz
}

function rpm_installed {
  [ -z "$(which $1)" ] && return 0 || return 1
}

function install_rpm_check {
  rpm_installed $1
  if [ $? -eq 0 ]; then
    install_package rpm $2
		return 1
  else 
    echo "$1 has been installed"
		return 0
  fi

}

function install_docker {
	install_rpm_check docker docker-ce-18.06.3.ce-3.el7.x86_64.rpm
  if [ $? -eq 1 ];then
    echo $password | sudo -S usermod -aG docker ${USER}
  fi
}

function install_chrome {
  install_rpm_check google-chrome google-chrome-stable_current_x86_64.rpm
}

function install_vscode {
  install_rpm_check code code-1.33.1-1554971173.el7.x86_64.rpm  
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
  install_clion
  install_intelij
  install_goland
  install_pycharm
  install_docker
	install_vscode
  install_chrome
}

function config_centos {
  ln_dotfile 
  ln_vpn
}

function main {
  mk_code_dir
  read -n 1 -t 10 -p "Is this a new Centos?[Y/N] " newcentos
  echo ""
  case $newcentos in
  Y|y)
    new_centos
    ;;
  *)
    echo "this centos will be treated as configed centos.(rerun this script if this is a new centos)!"
    ;;
  esac
  config_centos
  echo "Your computer is successfully installed."
}

main
