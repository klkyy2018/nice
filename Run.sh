#!/bin/bash
PROJECT="onekeyenv"
MY_BIN=${HOME}/bin
OPT_BIN=/opt/${USER}
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

function super() {
  cmd=$1
  if [[ -z ${password} ]]; then
    export password=$(get_sudo_pass)
  fi
  echo ${password} | sudo -S ${cmd}
}

function mk_user_dir() {
  mkdir -p ${MY_BIN}
  mkdir -p ${DEV_HOME}
  mkdir -p ${GO_DEV}
  mkdir -p ${IMPORTANT_PATH}
}

# sys dir need super-priviledge
function mk_sys_dir() {
  super "mkdir -p ${OPT_BIN}"
}

function file_exists() {
  [[ -f $1 ]] && return 1 || return 0
}

function is_package_installed() {
  if [[ ! $(command -v $1) ]]; then
    return 0
  else
    echo "$1 has been installed."
    return 1
  fi
}

function install_env_check() {
  if [[ -z ${INSTALL_KIT} ]]; then
    echo "env not set, please set INSTALL_KIT to yum,apt-get..."
    exit 1
  fi
}

# install packages using system package manage kit
function install_package() {
  install_env_check
  pkgs=$@
  for pkg in ${pkgs}; do
    is_package_installed ${pkg}
    if [[ $? -eq 0 ]]; then
      case ${INSTALL_KIT} in
        "apt-get" | "apt" | "yum")
          super "${INSTALL_KIT} install -y ${pkg}"
          ;;
        "pacman")
          super "${INSTALL_KIT} -S --noconfirm ${pkg}"
          ;;
        *)
          echo "${INSTALL_KIT} is not support."
          ;;
      esac
    fi
  done
}

# install 3rd party package
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
        if [[ -f ${OPT_BIN}/${install_flag} ]]; then
          echo "${file} has been installed."
          echo "force re-install by removing ${OPT_BIN}/${install_flag}"
        else
          super "tar xzf $file -C ${OPT_BIN}"
          sudo -S touch ${OPT_BIN}/${install_flag}
        fi
        ;;
      TYPE_INSTALL_KIT)
        super "${INSTALL_KIT} install -y ${file}"
        ;;
      PACMAN)
        super "pacman -S -y ${file}"
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
  install_opt_package tar CLion-2019.3.2.tar.gz
}

function install_intelij() {
  install_opt_package tar ideaIC-2019.3.1.tar.gz
}

function install_goland() {
  install_opt_package tar goland-2019.3.4.tar.gz
}

function install_pycharm() {
  install_opt_package tar pycharm-community-2019.3.3.tar.gz
}

function install_docker() {
  case ${INSTALL_KIT} in
    "apt-get")
      install_opt_package TYPE_INSTALL_KIT docker-ce_18.06.3_ce_3-0_ubuntu_amd64.deb
      ;;
    "yum")
      install_opt_package TYPE_INSTALL_KIT docker-ce-18.06.3.ce-3.el7.x86_64.rpm
      ;;
    "pacman")
      echo "skip install docker."
      ;;
    *)
      echo "not support KIT: ${INSTALL_KIT}"
      exit 1
      ;;
  esac
  if [ $? -eq 1 ]; then
    super "usermod -aG docker ${USER}"
  fi
}

function install_chrome() {
  is_package_installed "google-chrome-stable"
  if [[ $? -eq 0 ]]; then
    case ${INSTALL_KIT} in
      "apt-get")
        install_opt_package TYPE_INSTALL_KIT google-chrome-stable_current_x86_64.deb
        ;;
      "yum")
        install_opt_package TYPE_INSTALL_KIT google-chrome-stable_current_x86_64.rpm
        ;;
      "pacman")
        install_package google-chrome
        ;;
      *)
        echo "not support KIT: ${INSTALL_KIT}"
        exit 1
        ;;
    esac
  fi
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
  is_package_installed "code"
  if [[ $? -eq 0 ]]; then
    case ${INSTALL_KIT} in
      "apt-get" | "apt")
        echo ${password} | curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >/tmp/packages.microsoft.gpg
        super "install -o root -g root -m 644 /tmp/packages.microsoft.gpg /usr/share/keyrings/"
        super "sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'"
        super "apt-get install apt-transport-https"
        super "apt-get update"
        super "apt-get install code"
        ;;
      "yum")
        super "rpm --import https://packages.microsoft.com/keys/microsoft.asc"
        super "sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'"
        super "yum check-update"
        super "yum install code"
        ;;
      "pacmac")
        install_package "code"
        ;;
      *)
        echo "not support KIT: ${INSTALL_KIT}"
        exit 1
        ;;
    esac
  fi
}

function install_zsh() {
  is_package_installed "zsh"
  if [[ $? -eq 0 ]]; then
    install_package zsh
  fi
  if [[ ! -d ~/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --skip-chsh"
  else
    echo "oh-my-zsh has been installed."
  fi
}

function install_tmux_dependencies() {
  install_env_check
  case ${INSTALL_KIT} in
    "apt-get" | "apt")
      super "apt-get install -y libncurses-dev libevent-dev"
      ;;
    "yum")
      super "yum install -y ncurses-devel libevent libevent-devel"
      ;;
    "pacman")
      echo "pacman dont need tmux dependencies"
      ;;
    *)
      echo "not support KIT: ${INSTALL_KIT}"
      exit 1
      ;;
  esac
}

function install_tmux() {
  is_package_installed "tmux"
  if [[ $? -eq 0 ]]; then
    install_tmux_dependencies
    cd ${DEV_HOME}
    git clone https://github.com/tmux/tmux.git
    cd tmux
    sh autogen.sh
    ./configure && make -j 2
    super "make install"
  fi
  if [[ ! -d ~/.tmux ]]; then
    cd ${HOME}
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
  else
    echo "tmux has been configured."
  fi
}

function lndotfile() {
  cd ${HOME}
  ln -sf ${DEV_HOME}/${PROJECT}/dotfile/.zshrc
  ln -sf ${DEV_HOME}/${PROJECT}/dotfile/.zshrc.darwin
  ln -sf ${DEV_HOME}/${PROJECT}/dotfile/.zshrc.linux
  ln -sf ${DEV_HOME}/${PROJECT}/dotfile/.tmuxinator.zsh
  ln -sf ${DEV_HOME}/${PROJECT}/dotfile/.aliases
  ln -sf ${DEV_HOME}/${PROJECT}/dotfile/.vimrc
  ln -sf ${DEV_HOME}/${PROJECT}/dotfile/.gitconfig
  ln -sf ${DEV_HOME}/${PROJECT}/dotfile/.tmux.conf.local
}

function lnmybin() {
  cd ${MY_BIN}
  ln -sf ${DEV_HOME}/${PROJECT}/bin/myproxy
}

function new_linux() {
  install_package curl vim automake autoconf make flex bison pkg-config
  install_rbenv
  install_zsh
  install_tmux
  install_chrome
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
}

function backup() {
  for file in $@; do
    file_exists ${file}
    if [[ $? -eq 1 ]]; then
      mv ${file} ${file}.$(date +%s)
    fi
  done
}

function backupdotfile() {
  cd ${HOME}
  backup ".bashrc" ".vimrc" ".gitconfig" ".zshrc"
}

# main_quick quick enable some config
function main_quick() {
  ln -sf ${DEV_HOME}/${PROJECT}/dotfile/.vimrc
}

function main_linux() {
  source /etc/os-release
  echo "your distribution is ${ID}."
  case $ID in
    debian | ubuntu | devuan)
      export INSTALL_KIT="apt-get"
      ;;
    centos | fedora | rhel)
      export INSTALL_KIT="yum"
      ;;
    manjaro | arch)
      export INSTALL_KIT="pacman"
      ;;
    *)
      echo "${ID} is not support now."
      exit 1
      ;;
  esac
  new_linux
  lndotfile
  lnmybin
}

# macOs using brew as kit
# now only support link some files
function main_darwin() {
  lndotfile
  lnmybin
}

function main() {
  mk_user_dir
  mk_sys_dir
  backupdotfile
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
  echo "Your computer is successfully installed."
  echo "all finished."
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
