#!/bin/bash
MY_BIN=${HOME}/bin
SYS_BIN=/usr/local/${USER}
DEV_HOME=${HOME}/dev
GO_DEV=${DEV_HOME}/go
# all tarball should put into IMPORTANT_PATH
IMPORTANT_PATH=${HOME}/.important

function get_sudo_pass() {
  stty -echo
  read -t 10 -p "[sudo] password for ${USER}: " password
  if [[ -z ${password} ]]; then
    echo "timeout! please rerun this script..."
    exit 1
  fi
  echo ${password}
  stty echo
}

function mk_user_dir() {
  mkdir -p ${MY_BIN}
  mkdir -p ${DEV_HOME}
  mkdir -p ${GO_DEV}
}

function mk_sys_dir() {
  echo ${password} | sudo -S mkdir -p ${SYS_BIN}
}

function file_exists() {
  [[ -f $1 ]] && return 1 || return 0
}

function is_package_installed() {
  if [[ ! $(command -v $1) ]]; then
    return 0
  else
    echo "$1 has been installed"
    return 1
  fi
}

function install_env_check() {
  if [[ -z ${INSTALL_KIT} ]]; then
    echo "env not set, please set INSTALL_KIT to yum,apt-get..."
    exit 1
  fi
  if [[ -z ${password} ]]; then
    echo "we need password to execute priviledge command"
    exit 2
  fi
}

function install_package() {
  install_env_check
  pkgs=$@
  for pkg in ${pkgs}; do
    is_package_installed ${pkg}
    if [[ $? -eq 0 ]]; then
      echo ${password} | sudo -S ${INSTALL_KIT} install -y ${pkg}
    fi
  done
}

function install_opt_package() {
  install_env_check
  file_type=$1
  file_name=$2
  echo "will install $file_name'...'"
  file=${IMPORTANT_PATH}/${file_name}
  install_flag="."${file_name}"_installed"
  file_exists ${file}
  if [[ $? -eq 1 ]]; then
    case ${file_type} in
      tar)
        if [[ -f ${SYS_BIN}/${install_flag} ]]; then
          echo "${file} has been installed."
          echo "force re-install by removing ${SYS_BIN}/${install_flag}"
        else
          echo ${password} | sudo -S tar xzf $file -C ${SYS_BIN}
          sudo -S touch ${SYS_BIN}/${install_flag}
        fi
        ;;
      TYPE_INSTALL_KIT)
        echo ${password} | sudo -S ${INSTALL_KIT} install -y ${file}
        ;;
      *)
        echo "not support type!(${file_type})"
        ;;
    esac
    return 1
  else
    echo "${file} not exists, skipping install it."
    return 0
  fi
}

function install_jdk() {
  install_opt_package tar jdk-8u201-linux-x64.tar.gz
}

function install_ant() {
  install_opt_package tar apache-ant-1.10.6-bin.tar.gz
}

function install_mvn() {
  install_opt_package tar apache-maven-3.6.0-bin.tar.gz
}

function install_go() {
  install_opt_package tar go1.11.linux-amd64.tar.gz
}

function install_clion() {
  install_opt_package tar CLion-2019.1.3.tar.gz
}

function install_intelij() {
  #install_opt_package tar ideaIC-2019.1.2.tar.gz
  install_opt_package tar ideaIC-2019.3.1.tar.gz
}

function install_goland() {
  install_opt_package tar goland-2019.3.tar.gz
}

function install_pycharm() {
  install_opt_package tar pycharm-community-2019.3.1.tar.gz
}

function install_docker() {
  case ${INSTALL_KIT} in
    "apt-get")
      install_opt_package TYPE_INSTALL_KIT docker-ce_18.06.3_ce_3-0_ubuntu_amd64.deb
      ;;
    "yum")
      install_opt_package TYPE_INSTALL_KIT docker-ce-18.06.3.ce-3.el7.x86_64.rpm
      ;;
    *)
      echo "not support KIT: ${INSTALL_KIT}"
      exit 1
      ;;
  esac
  if [ $? -eq 1 ]; then
    echo ${password} | sudo -S usermod -aG docker ${USER}
  fi
}

function install_chrome() {
  case ${INSTALL_KIT} in
    "apt-get")
      install_opt_package TYPE_INSTALL_KIT google-chrome-stable_current_x86_64.deb
      ;;
    "yum")
      install_opt_package TYPE_INSTALL_KIT google-chrome-stable_current_x86_64.rpm
      ;;
    *)
      echo "not support KIT: ${INSTALL_KIT}"
      exit 1
      ;;
  esac
}

function install_rbenv() {
  if [[ ! -d ~/.rbenv ]]; then
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    cd ~/.rbenv && src/configure && make -C src -j 2
  else
    echo "rbenv has been installed."
  fi
}

function install_vscode() {
  if [[ ! $(which code) ]]; then
    case ${INSTALL_KIT} in
      "apt-get")
        echo ${password} | curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
        echo ${password} | sudo -S install -o root -g root -m 644 /tmp/packages.microsoft.gpg /usr/share/keyrings/
        echo ${password} | sudo -S sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
        echo ${password} | sudo -S apt-get install apt-transport-https
        echo ${password} | sudo -S apt-get update
        echo ${password} | sudo -S apt-get install code
        ;;
      "yum")
        echo ${password} | sudo -S rpm --import https://packages.microsoft.com/keys/microsoft.asc
        echo ${password} | sudo -S sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        echo ${password} | sudo -S yum check-update
        echo ${password} | sudo -S yum install code
        ;;
      *)
        echo "not support KIT: ${INSTALL_KIT}"
        exit 1
        ;;
    esac
  else
    echo "vscode has been installed."
  fi
}

function install_zsh() {
  install_package zsh
  if [[ ! -d ~/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  else
    echo "oh-my-zsh has been installed."
  fi
}

function install_tmux_dependencies() {
  install_env_check
  case ${INSTALL_KIT} in
    "apt-get")
      echo ${password} | sudo -S apt-get install -y libncurses-dev libevent-dev
      ;;
    "yum")
      echo ${password} | sudo -S yum install -y ncurses-devel libevent libevent-devel
      ;;
    *)
      echo "not support KIT: ${INSTALL_KIT}"
      exit 1
      ;;
  esac
}

function install_tmux() {
  if [[ ! -d ~/.tmux ]]; then
    install_tmux_dependencies
    cd ${DEV_HOME}
    git clone https://github.com/tmux/tmux.git
    cd tmux
    sh autogen.sh
    ./configure && make -j 2
    echo ${password} | sudo -S make install
    cd ${HOME}
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
  else
    echo "tmux has been installed."
  fi
}

function ln_dotfile() {
  cd ${HOME}
  ln -sf ${DEV_HOME}/nice/dotfile/.zshrc
  ln -sf ${DEV_HOME}/nice/dotfile/.zshrc.darwin
  ln -sf ${DEV_HOME}/nice/dotfile/.zshrc.linux
  ln -sf ${DEV_HOME}/nice/dotfile/.tmuxinator.zsh
  ln -sf ${DEV_HOME}/nice/dotfile/.aliases
  ln -sf ${DEV_HOME}/nice/dotfile/.vimrc
  ln -sf ${DEV_HOME}/nice/dotfile/.gitconfig
  ln -sf ${DEV_HOME}/nice/dotfile/.tmux.conf.local
}

function ln_vpn() {
  cd ${MY_BIN}
  ln -sf ${DEV_HOME}/nice/vpn/create_vpn.sh
  ln -sf ${DEV_HOME}/nice/vpn/vpn.sh
}

function ln_bin() {
  cd ${MY_BIN}
  ln -sf ${DEV_HOME}/nice/bin/vitess.env
}

function new_linux() {
  install_package curl vim automake autoconf make flex bison pkg-config
  install_rbenv
  install_zsh
  install_tmux
  install_jdk
  install_mvn
  install_ant
  install_go
  install_clion
  install_intelij
  install_goland
  install_pycharm
  install_docker
  install_vscode
  install_chrome
}

function new_apt() {
  new_linux
}

function new_yum() {
  new_linux
}

function lnk_file() {
  ln_dotfile
  ln_vpn
  ln_bin
}

function main_apt() {
  export INSTALL_KIT="apt-get"
  echo "Using ${INSTALL_KIT}."
  new_apt
  echo "Your computer is successfully installed."
}

function main_yum() {
  export INSTALL_KIT="yum"
  echo "Using ${INSTALL_KIT}."
  new_yum
  echo "Your computer is successfully installed."
}

function main_linux() {
  mk_user_dir
  password=$(get_sudo_pass)
  mk_sys_dir
  echo -e "\nChoose your linux distribution?"
  select var in "CentOS" "Ubuntu"; do
    case ${var} in
      "CentOS")
        main_yum
        ;;
      "Ubuntu")
        main_apt
        ;;
      *)
        if [[ -z ${var} ]]; then
          echo "wrong choice."
        else
          echo "${var} is not support now."
        fi
        ;;
    esac
    break
  done
  lnk_file
}

function main_darwin() {
  ln_dotfile
  ln_bin
}

function main() {
  if [[ ${quick_mode} == "true" ]]; then
    main_quick
    exit 0
  fi
  os=$(uname -s)
  echo "Runing on ${os}."
  case "${os}" in
    "Darwin")
      main_darwin
      ;;
    "Linux")
      main_linux
      ;;
  esac
  echo "all finished."
}

function backup() {
  for file in $@; do
    file_exists ${file}
    if [[ $? -eq 1 ]]; then
      mv ${file} ${file}.$(date +%s)
    fi
  done
}

function main_quick() {
  cd ${HOME}
  backup ".bashrc" ".vimrc" ".gitconfig"
  ln -sf ${DEV_HOME}/nice/dotfile/.bashrc
  ln -sf ${DEV_HOME}/nice/dotfile/.vimrc
  ln -sf ${DEV_HOME}/nice/dotfile/.gitconfig
}

quick_mode=""
while getopts "q" args; do
  case ${args} in
    q)
      echo "quick mode!"
      quick_mode="true"
      ;;
    *)
      echo "unsupported option"
      exit 1
      ;;
  esac
done

main
