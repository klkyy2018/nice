# onekeyenv
This project is mainly used to configure the development environment in the newly installed operating system.  
onekey will install: zsh oh-my-zsh tmux chrome vscode docker rbenv shfmt   
and some 3rd party softwares: jdk maven ant go intelij goland pycharm clion

The installation method of the third-party packages is not yet friendly. You need to put the following packages in the `${HOME}/.Important` directory to install normally:  
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
