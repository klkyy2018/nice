# onekeyenv "一键环境"  
该项目主要是用在新装的操作系统中配置开发环境。  
onekey将会安装: zsh oh-my-zsh tmux chrome vscode docker rbenv shfmt  
以及第三方包: jdk maven ant go intelij goland pycharm clion

第三方包现在的安装方式还不太友好，需要将以下包放在${HOME}/.important目录下才能正常安装：  
 - jdk-8u201-linux-x64.tar.gz
 - apache-ant-1.10.6-bin.tar.gz
 - apache-maven-3.6.0-bin.tar.gz
 - go1.11.linux-amd64.tar.gz
 - CLion-2019.3.2.tar.gz
 - ideaIC-2019.3.1.tar.gz
 - goland-2019.3.4.tar.gz
 - pycharm-community-2019.3.3.tar.gz

## USAGE
```shell
mkdir -p ~/dev
cd ~/dev
git clone https://github.com/klkyy2018/onekeyenv.git
cd onekeyenv
./Run.sh
```

## QUICK MODE
quick mode config tools in a simple way. Usually, this mode is used when on servers or other people's computer.
```
cd onekeyenv
./Run.sh -q
```

## CONTRIBUTE
Source contribute.env before contributing to this Repo!
