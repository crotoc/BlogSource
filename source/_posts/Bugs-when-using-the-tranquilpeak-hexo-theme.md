---
title: Bugs when using the tranquilpeak hexo theme
date: 2019-03-16 01:48:20
categories: ''
[//]: #  tags: ['博客']	
[//]: #  tags: ['计划','建站','Hexo']
keywords:
- '博客'
- '主题'
[//]: #  - hexo
[//]: #  - '建站'
clearReading: true  [//]: # 在文章页隐藏侧栏，以更好地阅读。
[//]: #  thumbnailImage: http://upyun.geekap.com/gitblog-img/car-6-140.jpg  //首页文章列表显示的缩略图
thumbnailImage: https://static.photocdn.pt/images/articles/2017_1/iStock-545347988.jpg  [//]: # 首页文章列表显示的缩略图	
thumbnailImagePosition: left  [//]: # 缩略图显示的位置，上下左右都可以
autoThumbnailImage: true  [//]: #  开启后如果没有设置缩略图，会自动设置为图片画廊里的第一张，或者其他文章的图。
metaAlignment: center  [//]: # 文章页图片上的文字居中显示
coverImage: https://static.photocdn.pt/images/articles/2017_1/iStock-545347988.jpg  [//]: # 文章页最上面的那个大图
[//]: #  coverImage:   //文章页最上面的那个大图	
coverCaption: "Hexo建站分享"  [//]: # 大图下面的小标题
coverMeta: in  [//]: # 图片上的文字显示在图片上，或者显示在图片外面
coverSize: full  [//]: # 大图显示的尺寸，full是全屏展示
comments: true  [//]: # 评论功能是否开启
---

Bugs when using the tranquilpeak hexo theme
<!-- excerpt -->

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

	
	
   

