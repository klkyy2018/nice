#! /bin/bash
echo "开始配置vpn服务器..."

check_envir() {
  echo "正在检查环境..."
  ppp=$(yum list | grep ppp)

  if [[ $ppp =~ *ppp* ]]; then
    echo "未安装ppp，即将安装请等待..."
    set=$(yum install ppp)
    if [[$set | grep "没有可用软件包"]]; then
      echo "安装失败，请手动安装ppp"
      return 0
    fi
    echo "finished!"
  fi

  pptp=$(yum list | grep pptp)
  if [[ $pptp =~ *pptp* ]]; then
    echo "未安装pptp，即将安装请等待..."
    set=$(yum install pptp)
    if [[$set | grep "没有可用软件包"]]; then
      echo "安装失败，请手动安装pptp"
      return 0
    fi
    echo "finished!"
  fi

  pptpsetup=$(yum list | grep pptp-setup)
  if [[ $pptpsetup =~ *pptp-setup* ]]; then
    echo "未安装pptp-setup，即将安装请等待..."
    set=$(yum install pptp-setup)
    if [[$set | grep "没有可用软件包"]]; then
      echo "安装失败，请手动安装pptp-setup"
      return 0
    fi
    echo "finished!"
  fi
  cp /usr/share/doc/ppp-2.4.5/scripts/pon /usr/sbin/
  cp /usr/share/doc/ppp-2.4.5/scripts/poff /usr/sbin/
  chmod +x /usr/sbin/pon /usr/sbin/poff
  return 1
}

create_vpn() {
  read -p "请输入目标vpn服务器地址：" ip
  read -p "请为vpn创建名称：" vpnname
  read -p "请输入用户名：" username
  read -p "请输入密码：" password

  pptpsetup --create $vpnname --server $ip --username $username --password $password --encrypt
  echo "all have finished!"
}

create_vpn
