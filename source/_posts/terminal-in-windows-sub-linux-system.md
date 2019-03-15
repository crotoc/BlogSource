---
title: "Windows 10下面最好的terminal (WSL)"
date: 2019-01-22 10:16:24
tags: setup
---

# Windows 10下面最好的terminal (WSL)

## 介绍

我主要的工作都在linux的服务器上,所以有个好用的终端非常重要.我使用过的终端非常多,包括了最简单的putty,稍微复杂一些的cygwin,然后是基于cmder的Conmu.他们各有个的优点:
1. Putty贵在简单,只要能连上服务器就行,但是问题在于有的时候没有服务器我没法运行linux命令.
2. cygwin是个很好的windows下面的linux系统,也有很多的插件可以开发,但是终端实在太难看了.我尝试过使用mintty作为前端,但是用过一两年之后还是弃用了,因为它对linux的原生命令支持的不好.
3. ConEmu是我最满意的终端系统之一,但是后来出现了一个bug毁掉一切.那就是连到服务器上的时候,我使用emacs的分屏功能,中间的分隔会是不是的抽风,将一切变成乱码.作为一个常年使用emacs的人,这也是接受不能.
4. 其他.

后来Windows 10系统集成了Windows sublinux系统实在太符合我的胃口了.作为一个使用过ubuntu系统作为主系统的人,简直对在windows上面运行ubuntu的诱惑无法抵御,于是我掉坑里了.

## 安装WSL

这不是重点,贴个链接在此.[WSL的安装和使用](https://www.cnblogs.com/JettTang/p/8186315.html)

## 安装X windows

WSL可以使用windows的powershell,但是对于这个终端我实在无爱,所以后来我选中了ubuntu的里面的原生linux终端terminator.那么首要的问题是如何在windows上面运行x windows的应用.这里有两个选择,一个是[VcXsrv](https://sourceforge.net/projects/vcxsrv/),一个是[Xming](https://sourceforge.net/projects/xming/). 

我选择了XcXsrv, 大体步骤就是下载安装文件安装,这里不详述.

## 配置terminator

安装了xwindows之后就可以打开WSL,安装terminator:

	sudo apt-get install terminator

## 命令行启动

打开命令行工具,然后输入下面命令:

	bash -c -l "DISPLAY=:0 terminator &"
	
## 快捷方式启动

为了让terminator看起来像个程序一样启动,还需要一些其他的工作.

首先在ubuntu里面写一个脚本叫做[terminator.sh](./terminal-in-windows-sub-linux-system/terminator.sh).这个脚本主要为了实现自动检测打开x window服务器:

	#!/bin/sh
	cd ~
	
	## 检查windows系统当前的进程里面是否有vcxsrv.exe.如果有代表x windows已经开启,如果没有则开启
	x=`/mnt/c/Windows/System32/tasklist.exe /FI "IMAGENAME eq vcxsrv.exe" | grep vcxsrv.exe`;

	if [[ ! \$x ]];then
  
	"/mnt/c/Program Files/VcXsrv/vcxsrv.exe" :0 -ac -terminate -lesspointer -multiwindow -clipboard -wgl -dpi auto 2> /dev/null & 
	fi
	##将x windows的显示定在本地.
	export DISPLAY=:0.0

	##启动 terminator
	terminator

然后在windows下面边写一个快捷方式脚本[startTerminator,vbs](./terminal-in-windows-sub-linux-system/startTerminator.vbs),这个脚本主要用于实现建立快捷方式打开terminator:

	' 将运行服务器上的terminator.sh脚本存成一个参数变量
	args = "-c" & " -l " & """bash ~/SHscript/terminator.sh"""


	' windows自动运行脚本，用上面的arg作为参数
	WScript.CreateObject("Shell.Application").ShellExecute "bash", args, "", "open", 0

然后在桌面建立一个快捷方式,在目标里面写上C:\Users\chenr6\Downloads\startTerminator.vbs,图标改成自己喜欢的样子.双击就可以打开了.

# 如何使用中文输入法

首先我选择搜狗输入法,因为我想使用双拼,而且我在windows下面的输入法就是搜狗.

## 安装fcitx框架

搜狗输入法的linux版本输入法需要fcitx框架,所以首先安装框架:

	sudo apt-get update
	sudo apt-get install fcitx
	sudo apt-get install fcitx-config-gtk
	sudo apt-get install fcitx-table-all
	sudo apt-get install im-switch

然后下载[搜狗linux最新版deb包](https://pinyin.sogou.com/linux/?r=pinyin),并且安装:

	sudo dpkg -i sogouxxx.deb
	
如果需要输入法设置软件的界面中文,生成中文locale:

	sudo locale-gen zh_CN.UTF-8

将下列

在wsl的.bashrc文件中加入下面的设置:
	
	export XMODIFIERS=@im=fcitx
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    
    if [ \$(ps -ax | grep dbus-daemon | wc -l) -eq 1 ]; then
		eval 'dbus-launch > /dev/null 2>&1'
    fi
	

打开fcitx设置程序:

	fcitx-configtool

在里面加入搜狗拼音,并且最好将全局设置中的输入法热键修改一下.重新打开wsl,愉快的使用吧

## 参考
[terminator参考](https://blog.ropnop.com/configuring-a-pretty-and-usable-terminal-emulator-for-wsl/)

[搜狗输入法参考](https://pinyin.sogou.com/linux/?r=pinyin)
