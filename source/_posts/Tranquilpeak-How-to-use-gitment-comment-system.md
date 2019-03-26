---
title: "Tranquilpeak中使用gitment评论系统"
date: 2019-03-26 10:51:05
categories: '博客'
tags: ['主题配置']	
#  tags: ['计划','建站','Hexo']
keywords:
- 'tranquipeak'
- hexo
- '建站'
clearReading: true  # 在文章页隐藏侧栏，以更好地阅读。
#  thumbnailImage: http://upyun.geekap.com/gitblog-img/car-6-140.jpg  //首页文章列表显示的缩略图
thumbnailImage: https://data.1freewallpapers.com/download/water-bungalow-bora-bora-st-regis.jpg   # 首页文章列表显示的缩略图	
thumbnailImagePosition: left  # 缩略图显示的位置，上下左右都可以
autoThumbnailImage: true  #  开启后如果没有设置缩略图，会自动设置为图片画廊里的第一张，或者其他文章的图。
metaAlignment: center  # 文章页图片上的文字居中显示
coverImage: https://data.1freewallpapers.com/download/water-bungalow-bora-bora-st-regis.jpg  # 文章页最上面的那个大图
# coverImage: http://upyun.geekap.com/gitblog-img/cover-v1.2.0.jpg  # 文章页最上面的那个大图
coverCaption: "Hexo建站分享"  # 大图下面的小标题
coverMeta: in  # 图片上的文字显示在图片上，或者显示在图片外面
coverSize: full  # 大图显示的尺寸，full是全屏展示
comments: true  # 评论功能是否开启
---


"Tranquilpeak中使用gitment评论系统"
<!-- excerpt -->

[//]: # <!-- more -->

# "Tranquilpeak中使用gitment评论系统"

<!-- toc -->

## 设置OAuth app授权

要使用github的gitment评论系统，需要一个repository和一个访问github的授权应用。在Personal setting->Developer settings->OAuth Apps->New OAuth Appp。

1. Application name：app的名字，随便写

2. Homepage URL：填写自己的主页地址即可

3. Application description：随便填

4. Authorization callback URL：这一步最重要，也是填写自己的博客地址，这里要注意到底是http与https，填写的一定要与自己的博客使用的一致。github会使用callback url回调传你一个code参数。

建立完成之后就可以看到其中的client_id和client_secret了。

## 配置文件设置

Tranquilpeak主题中已经集成了gitment的评论系统，所以直接修改这部分代码：

	gitment:
		# Switch
		enable: true
		# Your Github ID (Github username):
		github_id: crotoc
		# The repo to store comments:
		repo: crotoc.github.io
		# Your client ID:
		client_id: **********
		# Your client secret:
		client_secret: **********


## 问题

### object ProgressEvent

因为gitment开发者的一些原因，到这里使用的时候会出现object ProgressEvent的错误，需要修改tranquilpeak\layout\_partial\scripts.ejs中的两处地方:

	gc.src = '//imsun.github.io/gitment/dist/gitment.browser.js';
	gcs.href = '//imsun.github.io/gitment/style/default.css';

修改成

	gc.src = '//jjeejj.github.io/js/gitment.js';
	gcs.href = '//jjeejj.github.io/css/gitment.css';
	
### Comments Not Initialized、

这一般是Authorization callback URL配置错误或者在这一个评论区没有登录github账号。

### validation failed

这是由于github issue的Label的长度限制小于50字符，我们可以将tranquilpeak\layout\_partial\scripts.ejs的id由post.permalink改为post.date：

	function render() {
		new Gitment({
		id: '<%= post.permalink %>'
		owner: '<%- theme.gitment.github_id %>',
		repo: '<%- theme.gitment.repo %>',
		oauth: {
		client_id: '<%- theme.gitment.client_id %>',
		client_secret: '<%- theme.gitment.client_secret %>',
		}
		}).render('gitment');
	}

改成

	function render() {
		new Gitment({
		id: '<%= post.date %>'
		owner: '<%- theme.gitment.github_id %>',
		repo: '<%- theme.gitment.repo %>',
		oauth: {
		client_id: '<%- theme.gitment.client_id %>',
		client_secret: '<%- theme.gitment.client_secret %>',
		}
		}).render('gitment');
	}



## 参考链接

https://blog.csdn.net/du_milestone/article/details/83048444
https://blog.csdn.net/yen_csdn/article/details/80142392
https://github.com/imsun/gitment/issues/170
