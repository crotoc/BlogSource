---
title: Bugs when using the tranquilpeak hexo theme
date: 2019-03-16 01:48:20
tags: 
---

今天想将blog的主题从next 换成tranquilpeak,结果发现了很多的问题,这里记录一下:

1. 因为我使用travis自动在线部署,所以主题里面的node_modules不是必须的.

2. 这个主题的.gitignore文件中自动略去了assets文件夹,导致了网站看不到格式,只有文字.

3. 需要将主题中的package.json里面的dependencies拷贝到主目录的package.json才能在travis端自动安装.

4. 需要在主目录的_config.yml中设置language,不然出现的是德语.其中语言设置必须与主题中languages目录下的文件名对应.


## 标准调试过程

为了加快下一次的调试,经验如下:

### 第一步

本地安装包,找出依赖的问题:

	npm install
	
### 第二步

生成本地public目录:

	hexo clean
	hexo g
	hexo s
	
用本地浏览器打开确定本地显示是否出错:
	
	localhost:4000

如果本地没错可以将这个本地版本git到remote端,使用网页链接查看是否有错.

如果有错则核对两次commit之间的偏差,确定问题所在.

在本次调试过程中,主要问题是assets文件夹被主题目录中的.gitignore忽略,这样网页只有文字没有样式.

	
	
   

