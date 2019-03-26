---
title: Unblock Youku on a openWRT Router
date: 2018-09-14 10:18:12
categories: '网络技术'
tags: ['科学上网'，'openWRT']	
#  tags: ['计划','建站','Hexo']
keywords:
- 'unblock youku'
#  - hexo
#  - '建站'
clearReading: true  # 在文章页隐藏侧栏，以更好地阅读。
#  thumbnailImage: http://upyun.geekap.com/gitblog-img/car-6-140.jpg  //首页文章列表显示的缩略图
thumbnailImage: https://www.nationalgeographic.com/content/dam/photography/PROOF/2017/April/epic-landscapes/24-9007740_uploadsmember798135yourshot-798135-9007740jpg_ci6qt7qzhqldf4ex35to2j2as7p3eflutfvvbpyjwjhzlmh4iziq_3066x1725.jpg  # 首页文章列表显示的缩略图	
thumbnailImagePosition: left  # 缩略图显示的位置，上下左右都可以
autoThumbnailImage: true  #  开启后如果没有设置缩略图，会自动设置为图片画廊里的第一张，或者其他文章的图。
metaAlignment: center  # 文章页图片上的文字居中显示
coverImage: https://www.nationalgeographic.com/content/dam/photography/PROOF/2017/April/epic-landscapes/24-9007740_uploadsmember798135yourshot-798135-9007740jpg_ci6qt7qzhqldf4ex35to2j2as7p3eflutfvvbpyjwjhzlmh4iziq_3066x1725.jpg  # 文章页最上面的那个大图
# coverImage: http://upyun.geekap.com/gitblog-img/cover-v1.2.0.jpg  # 文章页最上面的那个大图
coverCaption: "Hexo建站分享"  # 大图下面的小标题
coverMeta: in  # 图片上的文字显示在图片上，或者显示在图片外面
coverSize: full  # 大图显示的尺寸，full是全屏展示
comments: true  # 评论功能是否开启
---


Unblock Youku on a openWRT Router
<!-- excerpt -->

[//]: # <!-- more -->

# Unblock Youku on a openWRT Router

<!-- toc -->


To watched videos from China apps like youku, tencent, sogou, we have to unblock the restrictions put on these website.

I applied this method to two models of routers: NETGEAR WNDR3700 ($20 on ebay) and R7800 ($160 on ebay) and they perform well enough.


## Prerequisites

1. A router that can install openWRT.
2. A list of urls needed to be unblocked.
3. A shadowsocks proxy (let me know if you don't have)
4. Plenty of time

## Installation of openWRT

The openWRT is a open-source system that can be installed on routers, which can bring many great new functions. It is actively developed and maintained.

For R7800, we need to flash openWRT through tftp.

1) Download the firmware from https://openwrt.org/toh/hwdata/netgear/netgear_r7800. Remember the right file is with suffix of ".img"

	wget http://downloads.openwrt.org/releases/18.06.1/targets/ipq806x/generic/openwrt-18.06.1-ipq806x-netgear_r7800-squashfs-factory.img

2) Install tftp on the computer(Ubuntu).

	sudo apt-get install tftp

3) Let the router enter into recovery mode.

	a. Power off the router
	b. Keep pressing the reset button using a pin and turn on the router.
	c. Release the reset button until the light blink white. The light of router will blink orange first and then after for a few seconds blink white. 


4) Connect the computer with router to one of the lan ports and mannually set the ip to 192.168.1.2. Because the router's ip is 192.168.1.1, don't use this ip for the computer.

	IP: 192.168.1.2
	MASK: 255.255.255.0
	Gateway: 192.168.1.1
	DNS: 192.168.1.1 (Not important)
	
5) Ping the router from the computer to make sure everthing is all right.

	ping 192.168.1.1

	## 64 bytes from 192.168.1.1: icmp_seq=1 ttl=47 time=80.3 ms
	## 64 bytes from 192.168.1.1: icmp_seq=2 ttl=47 time=80.3 ms
	## 64 bytes from 192.168.1.1: icmp_seq=3 ttl=47 time=80.3 ms
	## 64 bytes from 192.168.1.1: icmp_seq=4 ttl=47 time=80.2 ms
	

6) Connect to the router using tftp and upload the openWRT image.

	tftp 192.168.1.1

	tftp> ?
	Commands may be abbreviated.  Commands are:

	connect connect to remote tftp
	mode    set file transfer mode
	put     send file
	get     receive file
	quit    exit tftp
	verbose toggle verbose mode
	trace   toggle packet tracing
	status  show current status
	binary  set mode to octet
	ascii   set mode to netascii
	rexmt   set per-packet retransmission timeout
	timeout set total retransmission timeout
	?       print help information

   Change to binary mode. This step is necessary. 
	
	tftp> binary

   Upload the openWRT img file.
   
	tftp> put openwrt-18.06.1-ipq806x-netgear_r7800-squashfs-factory.img

   It will show the size uploaded.

   Quit tftp.
   
	tftp> quit
	
7) If everything goes well, the blinking white light will turn off and the router will restart with openWRT.


## Install shadowsocks packages

After restarting, the router is running openWRT and we can connect to the router using luci.

Input 192.168.1.1 in a browser and it will ask you to set a password. After this we can connect to the router using ssh with the password.

	ssh root@192.168.1.1

To install shdowsocks, we need use the package manager command. First refresh the package list by:

	opkg update
	
Then find all the packages related to shawdowsocks.
	
	opkg find "*shadowsocks*"
	opkg install shadowsocks-client
	
	## Must
	opkg install shadowsocks-libev-config
	
	## Not necessary
	opkg install shadowsocks-libev-ss-local
	
	## Redirect requests to shadowsocks server)
	opkg install shadowsocks-libev-ss-redir 
	
	## Build up rules to redirect)
	opkg install shadowsocks-libev-ss-rules 
	
	## ss server, not necessary
	opkg install shadowsocks-libev-ss-server
	
	## For DNS requests, not necessary in this case
	opkg install shadowsocks-libev-ss-tunnel

	##To simple your life
	opkg install luci-app-shadowsocks


This method needs dnsmasq and ipset to build a ip filter.

The dnsmasq installed by the image does not support ipset, so we need to install dnsmasq-full

	opkg remove dnsmasq
	opkg install dnsmasq-full
	
I believe ipset package is already installed with shadowsocks. We can validate it by:

	opkg install ipset
	

## Configurations of shadowsocks

I would like to configure shadowsocks using luci, which can save you a lot of time.

1. Add a ss proxy server.
2. Add a ss-redir service.
3. The key part is putting the url list to the place that is to be forward to ss proxy server.
4. Because the step 3 needs to add the url to the related ipset hash when starting the service, so it doesn't allow any bad urls. Or the service can not start. To overcome this flaw, I modified the /usr/bin/ss-rules by adding a new ipset hash set named "_unblock" and build a new iptable rules to this set.

If you don't want to revise the ss-rules, you can use the command bellow.


## configuratins of ipset and iptables

Initiate a new ipset

	ipset -N _unblock hash:ip
	
Add the following iptable rules to iptable:

	## Create shadowsocks router rules
	iptables -t nat -N shadowsocks
	iptables -t mangle -N shadowsocks
	
	iptables -t nat -A shadowsocks -d x.x.x.x -j RETURN 
	# x.x.x.x为shadowsocks服务器地址
	iptables -t nat -A shadowsocks -d 0.0.0.0/8 -j RETURN
	iptables -t nat -A shadowsocks -d 10.0.0.0/8 -j RETURN
	iptables -t nat -A shadowsocks -d 127.0.0.0/8 -j RETURN
	iptables -t nat -A shadowsocks -d 169.254.0.0/16 -j RETURN
	iptables -t nat -A shadowsocks -d 172.16.0.0/12 -j RETURN
	iptables -t nat -A shadowsocks -d 192.168.0.0/16 -j RETURN
	iptables -t nat -A shadowsocks -d 224.0.0.0/4 -j RETURN
	iptables -t nat -A shadowsocks -d 240.0.0.0/4 -j RETURN
	
	## TCP
	iptables -t nat -A shadowsocks -p tcp -m set --match-set _unblock_ dst -j REDIRECT --to-port 1080
	
	## UDP using TPROXY
	iptables -t mangle -A shadowsocks -p udp -m set --match-set redir dst ! --dport 53 -j TPROXY --on-port 1080 --tproxy-mark 0x01/0x01
	ip route add local default dev lo table 100
	ip rule add fwmark 0x01/0x01 lookup 100
	ip route list table 100
	

	iptables -t nat -A PREROUTING -p tcp -j shadowsocks
	iptables -t mangle -A PREROUTING -j shadowsocks
	
	iptables -t nat -A OUTPUT -p tcp -j shadowsocks
	iptables -t mangle -A OUTPUT -j shadowsocks
	
	
## Configuration of dnsmasq-full 
	
Add a conf dir to be loaded by dnsmasq

	echo "conf-dir=/etc/dnsmasq.d">>/etc/dnsmasq.conf
	mkdir /etc/dnsmasq.d
	cd /etc/dnsmasq.d
	touch redir_test.conf

Restart dnsmasq after revising config file every time

	/etc/init.d/dnsmasq restart
	

## Test

	netstat -nlp

	## listen to the port to see what kind of url 
	tcpdump -i br-lan host xxxxx
	
	## Test ipset
	ping xxxx
	ipset list
	

	
	

## reference

http://blog.kompaz.win/2017/03/24/OpenWRT%20Shadowsocks+GFWList%20%E6%B5%81%E9%87%8F%E8%87%AA%E5%8A%A8%E5%88%86%E6%B5%81/
