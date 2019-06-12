---
title: How to install v2ray service on R7800
date: 2019-03-22 10:22:30
tags: [科学上网] 
categories: '网络技术'
#  tags: ['计划','建站','Hexo']
keywords:
- 'r7800'
#  - hexo
#  - '建站'
clearReading: true  # 在文章页隐藏侧栏，以更好地阅读。
#  thumbnailImage: http://upyun.geekap.com/gitblog-img/car-6-140.jpg  //首页文章列表显示的缩略图
thumbnailImage: https://images.pexels.com/photos/371633/pexels-photo-371633.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260  # 首页文章列表显示的缩略图	
thumbnailImagePosition: left  # 缩略图显示的位置，上下左右都可以
autoThumbnailImage: true  #  开启后如果没有设置缩略图，会自动设置为图片画廊里的第一张，或者其他文章的图。
metaAlignment: center  # 文章页图片上的文字居中显示
coverImage: https://images.pexels.com/photos/371633/pexels-photo-371633.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260  # 文章页最上面的那个大图
#  coverImage:   //文章页最上面的那个大图	
coverCaption: "Hexo建站分享"  # 大图下面的小标题
coverMeta: in  # 图片上的文字显示在图片上，或者显示在图片外面
coverSize: full  # 大图显示的尺寸，full是全屏展示
comments: true  # 评论功能是否开启
---

如何在netgear R7800上面安装v2ray服务
<!-- excerpt -->

# 如何在netgear R7800上面安装v2ray服务

!! 20190612 更新：本教程路由器作为客户端的设置部分比较复杂，涉及到直接修改luci包中的v2ray服务的脚本文件。设置的基础所涉及的luci-app-v2ray已经被从lean大的lede项目中移除了，所以有兴趣的去看我fork的分支项目[luci-apply-v2ray](https://github.com/crotoc/luci-app-v2ray)

<!-- toc -->

我在前面一篇博客里面写过如何安装ss的服务，由于常用的ss失效（端口被封，ss已经能够被特征识别），所以折腾了一下v2ray。这想这应该也是大势所趋吧。

## 要求

1. 一台安装了openWRT的路由器，本文使用r7800。
2. 一个可用的v2ray服务器，可以花钱买，也可以自己用虚拟机搭建一个。本文使用自己搭建。
3. 一个ubuntu系统用于编译相关的软件，使v2ray服务可以在router上面运行。
4. 如果部署过ss服务器和客户端，那就完美了
5. 懂一些linux

## 部署v2ray服务端

这一部分主要参看了这个[教程](https://toutyrater.github.io/prep/install.html)，在这里我只写下主要步骤。

登陆自己需要部署v2ray的服务器，如果是翻回国内就搞个有国内公网ip的虚拟机，如果科学上网，就弄个有国外ip虚拟机。然后下载脚本并且安装：

	wget https://install.direct/go.sh
	sudo bash go.sh
	
如果其中缺少什么依赖包，就自己安装好。


### v2ray服务器端配置文件

和ss服务器一样，需要针对v2ray写一个配置文件，这是我的{% asset_link "config.json" "[配置文件" %}。下面我来解释一下配置文件的内容:

	{
	//设置v2ray的log和orr文件；设置log的level
    "log": {
        "access": "/home/ruichen/v2ray/v2ray.log",
        "error": "/home/ruichen/v2ray/v2ray.err",
        "loglevel": "warning"
		},
	//服务器端入站包的配置，即代理服务器信息
    "inbounds":[//main port
	{
        "port": 18888,
	    "listen": "0.0.0.0",
	    "protocol": "vmess",
        "settings": {
		"clients": [
		    {
	//这里需要一个UUID，可以找网站生成一个，相当于ss的用户名。
			"id": "67ee3d0e-77c1-4776-8573-82ebc55176f9",
			"alterId": 64
		    }
		],
		//因为现在端口被查的厉害，所以我使用了一个随机端口的策略，避免长期使用一个端口容易被封。先建立一个绕行端口的通讯。
		"detour": { //绕行配置，即指示客户端使用 dynamicPort 的配置通信
		    "to": "dynamicPort"
		}
	    },
		//这里的流量协议，我使用简单的kcp，听说比tcp好些
	    "streamSettings": {
	        "network": "kcp"
		}
		},
	{
	//随机端口的配置
	    "protocol": "vmess",
	    "port": "18900-19000", // 端口范围
	    "tag": "dynamicPort",  // 与上面的 detour to 相同
	    "settings": {
	        "default": {
		    "alterId": 64
		}
	    },
		//如何分配随机端口
	    "allocate": {            // 分配模式
	        "strategy": "random",  // 随机开启
	        "concurrency": 2,      // 同时开放两个端口,这个值最大不能超过端口范围的 1/3
	        "refresh": 3           // 每三分钟刷新一次
	    },
	    "streamSettings": {
	        "network": "kcp"
	    }
	}
    ],
	//服务器端的出站包配置，这里使用freedom，意思就是自动处理进来包的类型
    "outbounds": [{
        "protocol": "freedom",
        "settings": {}
    }],
	//v2ray自带一个routing的功能，能够将设置的ip或者域名自动的routing。其中outboundTag有三种，这里使用blocked，意思是从这些ip来的通讯全部屏蔽掉，下面主要是本机的私有地址。
    "routing": {
        "strategy": "rules",
        "settings": {
	    "rules": [
	        {
		    "type": "field",
		    "ip": [
		        "0.0.0.0/8",
		        "10.0.0.0/8",
		        "100.64.0.0/10",
		        "127.0.0.0/8",
		        "169.254.0.0/16",
		        "172.16.0.0/12",
		        "192.0.0.0/24",
		        "192.0.2.0/24",
		        "192.168.0.0/16",
		        "198.18.0.0/15",
		        "198.51.100.0/24",
		        "203.0.113.0/24",
		        "::1/128",
		        "fc00::/7",
		        "fe80::/10"
		    ],
		    "outboundTag": "blocked"
		}
	    ]
	}
		}
	}


UUID可以使用[网站](https://www.uuidgenerator.net/)随机生成一个。


### 运行v2ray服务端

到这里我们就算配置完成了，首先使用下面命令测试一下config.json是否存在错误：

	/usr/bin/v2ray/v2ray -test -config /etc/v2ray/config.json
	
如果顺利通过，就可以运行服务器：
	
	/usr/bin/v2ray/v2ray -config /etc/v2ray/config.json
	
如果想使用systemctl来启动v2ray，需要用你的配置文件替换掉系统中/etc/v2ray/目录下的config.json文件。我这里使用软连接的方式，方便以后修改。

	rm /etc/v2ray/config.json
	ln -s ~/v2ray/config.json /etc/v2ray/config.json


## 客户端部署

v2ray比较神奇的地方在于客户端其实使用的是服务端的程序，只是配置文件不同。我这次需要将客户端安装到路由器上。

### openWRT的安装

直接参看前面的[如何在路由器上安装openwrt](https://crotoc.github.io/2018/09/14/Unblock-Youku-on-a-openWRT-Router/)

### 编译v2ray安装包

由于v2ray比较新，是ss被喝茶之后出现的，所以现在openwrt各版本并没有直接的安装包，我这里借用了[lean大的lede项目](https://github.com/coolsnowwolf/lede/tree/master/package/lean)中的v2ray源码包。这个lede项目集成了很多种架构的核心，希望大家的router都能在里面找到。

首先，安装一个ubuntu 64bit，然后lede项目克隆到本地：
	
	git clone https://github.com/coolsnowwolf/lede
	
接着，进入lede目录，更新并安装feeds：

	cd lede
	./scripts/feeds update -a
	./scripts/feeds install -a
	
再接着使用gui界面选择需要编译的路由：

	make menuconfig

在这个gui界面中，需要做如下选择：

1. Target System下面的Qualcomm Atheros IPQ806X，因为r7800的就是使用的这颗核心。
2. Network目录下的v2ray需要选上。
3. LuCI下面的Application下的Include V2ray需要选上。


然后编译：

	make -j1 V=s 
	
这一步时间很长，其实可以优化，就是在gui界面中吧不需要的东西全部不选。由于我也不知道那些是可以不用的，所以没有来得及研究，只去掉了一些看起来就不相关的东西。

等待这一步结束，使用find命令找到v2ray相关的ipk包：

	find ./ -name "*ipk" | grep v2r

将这些ipk包scp到路由器中：

	scp  ./bin/packages/arm_cortex-a15_neon-vfpv4/base/*v2ray*.ipk root@192.168.1.1:/root/
	scp ipset-lists_20181104-1_arm_cortex-a15_neon-vfpv4.ipk root@*.*.*.*:/root/

### 安装v2ray

这个时候可以ssh登陆路由器，然后安装这些包：

	opkg install v2ray_v4.17.0_arm_cortex-a15_neon-vfpv4.ipk
	opkg install luci-app-v2ray-pro_1.0-11_all.ipk
	opkg install luci-i18n-v2ray-pro-zh-cn_1.0-11_all.ipk

注意安装过程中会各种报错，主要就是依赖包问题，比如dnsmasq，ipset，ipset-list，pdnsd-alt等，这是可以直接使用路由器的源安装，如

	opkg install dnsmasq
	opkg install ipset

如果在源中找不到那么就从刚刚编译的里面找了之后安装：

	find ./ -name "*ipk" | grep ipset-list
	find ./ -name "*ipk" | grep pdnsd-alt

没有报错就算安装成功。

### 客户端配置

因为本文中安装了v2ray的luci版本，所以可以直接在luci界面的Service下找到V2Ray Pro，然后填写设置。

#### 填写server

把Server Setting中的服务器地址，端口，id（这里填上文服务器端配置中的uuid），alter ID ，都填上保存。

#### 翻回国内

把Base Setting中的proxy mode改成Overseas Users watch China...，这是进入到unbluck-youku模式。

比较遗憾的一点是luci中并没有可以定制unblock-youku站点的地方。所以我们可以通过修改配置文件或者自动更新配置文件的方式达成。

配置文件的路径是/etc/gfwlist/unblock-youku，可以把需要的网址和ip填在其中，这样重启客户端就可以正常使用了。

1. 手动添加方式

比如现在163音乐需要代理的网址是nos.netease.com，将这一条加入到/etc/gfwlist/unblock-youku文件中就可以了

2. 自动添加方式

做一个需要代理网址的的链接。我这里使用的是我常用的[链接](https://crotoc.github.io/2019/01/22/Unblock-region-restriction-of-musics-videos/unblock.rules.v2ray.dnsmasq.conf)，只对163音乐，qq音乐，腾讯视频和android tv端的云极光起作用。ipset的使用方法请自己找相关的文章。

然后修改/etc/init.d/v2ray。这个文件是主程序文件，里面写了如何调用ipset列表以及iptables的路由转发方式。我这里不详细的写了。在这个主程序文件的start函数中加入几行：
	
	case "$vt_proxy_mode" in
		M|V)
			awk '!/^$/&&!/^#/{printf("ipset=/%s/'"$vt_gfwlist"'\n",$0)}' \
				/etc/gfwlist/$vt_gfwlist > /var/etc/dnsmasq-go.d/02-ipset.conf
				
			##############################################################################
			#####这里开始插入。 意思就是说下载上面那个链接的conf文件然后放到dnsmasq的配置文件家中。
			echo "Coping my conf"
			wget https://crotoc.github.io/2019/01/22/Unblock-region-restriction-of-musics-videos/unblock.rules.v2ray.dnsmasq.conf \
				-O /var/etc/dnsmasq-go.d/unblock.rules.v2ray.dnsmasq.conf 2>/dev/null
			##############################################################################
	

这样每次启动服务的时候，程序会自动下载某一个链接，用于dnsmasq的配置。

3. 自动添加方式-其他的可能

上面修改v2ray脚本的方式比较暴力，其实这一步我们要实现的东西就是将需要代理的网址和ip放到ipset的unblock-youku中，这样dnsmasq回去自动处理它。所以只要是能达到这个目的的都可以。

#### 科学上网

在luci的base setting中选base on gfw-list模式，然后路由会自动调用/etc/gfwlist/china-banned文件中的地址。gfw代理模式可以很方便的在luci界面中自定义。这里不在多说。

#### 启动程序

现在全部设置好了就可以启动程序了：

	/etc/init.d/v2ray start
	
如果list有什么改动，那么就stop在start

如果v2ray启动中，luci里面会显示V2Ray Pro RUNNING


#### 其他

如果大家不愿意通过luci去设置v2ray的客户端，那么也可以直接ssh到路由器上面启动。大概的步骤是：
1. 写个客户端的config文件
2. 建立一个ipset的table
3. 写个iptables的链

这套流程里面最简单的方式可能是直接修改/etc/init.d/v2ray中的start程序中的启动行，将客户端config文件传进去即可。/etc/init.d/v2ray的主要任务就是我上面说的三条。任何一个任务都是可以修改的。


### 测试

在路由器是ping某一个在列表中的地址，比如：

	ping v.youku.com
	
然后使用ipset查看unblock-youku列表：

	ipset list
	
如果上面的ip出现在unblock-youku列表中，那么ipset正确识别了需要代理的链接。

然后在服务器端看日志，如果可以看到相关链接的日志，那么就大功告成。


## 参考链接

[V2Ray 配置指南|V2Ray 白话文教程](https://toutyrater.github.io/)
[lean大的lede项目](https://github.com/coolsnowwolf/lede)
