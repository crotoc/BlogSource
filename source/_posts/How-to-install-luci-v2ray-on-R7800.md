# 如何在openwrt 18.06.1中安装v2ray服务器和luci-v2ray

[这个项目](https://github.com/crotoc/luci-app-v2ray)是基于coolsnowwolf/lede项目，从中间提取了相关依赖包。针对海外党做了如下的改动：

1. 在luci中添加了修改用户自定义unbluck-youku列表的设置。
2. 针对一些app中不使用域名进行解析的问题，将自定义的列表分成域名和ip两部分。
3. 其中域名部分可以只使用用户自定义的列表，也可以下载网上的列表与自己的列表合并。网上的列表提取子coolsnowwolf/lede项目中的ipset-lists包。
4. ip部分使用ipset add命令添加。
5. 添加了重启，启动，停止的按钮，方便使用

水平有限，大家随意

## 要求

1. 一个安装openwrt的路由
2. 一颗折腾的心

## Compile

### 下载sdk并且解压缩

SDK可以用于制作openwrt可以使用的ipk包，每种路由器根据不同核心需要下载不同的sdk包，我的路由器是R7800,所以去openwrt下载了对应的[sdk](https://downloads.openwrt.org/releases/18.06.2/targets/),即ipq806x的sdk：

	wget https://downloads.openwrt.org/releases/18.06.1/targets/ipq806x/generic/openwrt-sdk-18.06.1-ipq806x_gcc-7.3.0_musl_eabi.Linux-x86_64.tar.xz
	tar xf openwrt-sdk-18.06.1-ipq806x_gcc-7.3.0_musl_eabi.Linux-x86_64.tar.xz


### 下载luci到sdk目录下的package文件夹

	git clone https://github.com/crotoc/luci-app-v2ray.git
	cd openwrt-sdk-18.06.1-ipq806x_gcc-7.3.0_musl_eabi.Linux-x86_64
	cp -R ../luci-app-v2ray/* package/
	rm -rf package/luci-app-v2ray-pro/
	cp -R ~/git_project/luci-app-v2ray/luci-app-v2ray-pro/ package/

### 更新sdk需要的安装包

	./script/feeds update -a

### 安装依赖包

	./scripts/feeds install iptables-mod-tproxy kmod-ipt-tproxy ip ipset-lists pdnsd-alt coreutils coreutils-base64 coreutils-nohup dnsmasq-full v2ray ca-certificates lua-cjson luci-base
	
### 制作ipk包

	make package/luci-app-v2ray-pro/{down,compile} -j8
	
生成的ipk文件会存放在./bin/packages/arm_cortex-a15_neon-vfpv4/base/中.

### 重新制作

如果修改部分代码之后需要重新制作:

	rm -rf package/luci-app-v2ray-pro/
	cp -R ~/git_project/luci-app-v2ray/luci-app-v2ray-pro/ package/
	make package/luci-app-v2ray-pro/{clean,compile} -j8
	
## 安装

将上面的ipset-lists，pdnsd-alt，v2ray和luci-app-v2ray-pro四个ipk文件传到路由器上，除上述四个依赖包意外，其他的依赖包可以直接在服务器上安装：

	opkg install iptables-mod-tproxy kmod-ipt-tproxy ip  coreutils coreutils-base64 coreutils-nohup  v2ray ca-certificates lua-cjson luci-base

这四个包单独安装:

	opkg install ipset-lists*ipk
	opkg install pdnsd-alt*ipk
	opkg install v2ray*ipk
	opkg install luci-app-v2ray-pro*ipk
	
如果安装过程中出现依赖包缺失的情况，就使用opkg安装。

## 一些调试

安装的过程中还会出现有些包已经存在的情况。例如dnsmasq需要移除才能安装dnsmasq-full。卸载dnsmasq的过程中会出现断网的情况：

	/etc/init.d/dnsmasq stop
	opkg remove dnsmasq
	opkg instlal dnsmasq-full

## 如何判断自己成功了（一些debug的技巧）

### 判断v2ray服务是否正确启动

通过luci打开v2ray之后，使用下面的命令查看v2ray是否正常启动：

	netstat -nlp | grep v2ray

正常情况会看到两个监听的程序，分别对应ipv4和ipv6

### 判断正确的加入了iptables转发

通过iptables可以查看相关的条目是否添加：

	iptables -t nat -L v2ray_pre

### 使用myip.ipip.net网站

将myip.ipip.net加入到对应列表：如果使用gf，就加入到gf列表，如果使用unblock，就加入到unblock列表，重启服务。然后从客户端中（非路由）运行：
	
	curl myip.ipip.net

如果发现自己的ip变成了代理ip表示成功，这是查看iptables中对应规则，可以看到有包被转发了：

	iptables -t nat -L v2ray_pre -vxn

上面那条命令在路由器上运行是，无论是否成功没法变成代理ip，原因是客户端发出的包通过prerouting链被转进了v2ray_pre链中可以正确的转发，但是路由器自己产生的包没有通过prerouting，所以不能正确别转发。为了在路由器上运行上述命令，我查看了包的路径：

	tcpdump -i eth0.2 '(dst port 80) and (dst 104.24.21.50)'

发现路由器上使用curl的时候，只能从eth0.2（我的WAN端口）上面抓到相关的包。

所以我使用了一条新的规则将wan端口到104.24.21.50包转发到v2ray_pre链中：

	iptables -t nat -A OUTPUT -d 104.24.21.50 -p tcp -j v2ray_pre

然后再运行curl，用下面命令查看OUTPUT链的确探测到了包：

	iptables -t nat -L OUTPUT -nvx

而v2ray_pre也能探测到包：

	iptables -t nat -L v2ray_pre -vxn

这样curl命令也返回了代理服务器的ip，成功。

然后使用下面命令查看刚添加的那一条iptable规则编号并删除，并确认：

	iptables -t nat -L OUTPUT --line-numbers
	iptables -t nat -L OUTPUT -D 1
	iptables -t nat -L OUTPUT -nvx
	
注意我刚刚添加的那一条规则在我的路由器OUTPUT链中的编号是1，如果是你们的则可能是其他的数字，千万别删错了。




## 参考链接

LUCI CBI维基： https://github.com/openwrt/luci/wiki/CBI

https://github.com/seamustuohy/luci_tutorials/blob/master/04-model-cbi.md

L大的项目：https://github.com/coolsnowwolf/lede/tree/master/package

http://dvblog.soabit.com/building-custom-openwrt-packages-an-hopefully-complete-guide/

https://oldwiki.archive.openwrt.org/doc/howto/obtain.firmware.sdk

iptables原理和用法：https://blog.51cto.com/wushank/1171768
