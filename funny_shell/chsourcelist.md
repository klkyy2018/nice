一般情况下，将 /etc/apt/sources.list 文件中 Ubuntu 默认的源地址 http://archive.ubuntu.com/ 替换为 http://mirrors.ustc.edu.cn 即可。

可以使用如下命令：
sudo sed -i".tp" 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

小技巧:
如果你在安装时选择的语言不是英语，默认的源地址通常不是 http://archive.ubuntu.com/ ，
而是 http://<country-code>.archive.ubuntu.com/ubuntu/ ，如 http://cn.archive.ubuntu.com/ubuntu/ ， 此时只需将上面的命令进行相应的替换即可，即 sudo sed -i".tp" 's/cn.archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list 。
