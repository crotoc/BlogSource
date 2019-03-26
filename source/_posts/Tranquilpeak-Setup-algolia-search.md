---
title: Tranquilpeak Setup algolia search
date: 2019-03-26 10:34:50
categories: '博客'
tags: ['主题配置']	
#  tags: ['计划','建站','Hexo']
keywords:
- 'tranquilpeak'
#  - hexo
#  - '建站'
clearReading: true  # 在文章页隐藏侧栏，以更好地阅读。
#  thumbnailImage: http://upyun.geekap.com/gitblog-img/car-6-140.jpg  //首页文章列表显示的缩略图
thumbnailImage: https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYi7FGA5FfpekOBRLFsOSCep_sIqCw38lX0HgueXz6shmKqCdl  # 首页文章列表显示的缩略图	
thumbnailImagePosition: left  # 缩略图显示的位置，上下左右都可以
autoThumbnailImage: true  #  开启后如果没有设置缩略图，会自动设置为图片画廊里的第一张，或者其他文章的图。
metaAlignment: center  # 文章页图片上的文字居中显示
coverImage: https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYi7FGA5FfpekOBRLFsOSCep_sIqCw38lX0HgueXz6shmKqCdl  # 文章页最上面的那个大图
# coverImage: http://upyun.geekap.com/gitblog-img/cover-v1.2.0.jpg  # 文章页最上面的那个大图
coverCaption: "Hexo建站分享"  # 大图下面的小标题
coverMeta: in  # 图片上的文字显示在图片上，或者显示在图片外面
coverSize: full  # 大图显示的尺寸，full是全屏展示
comments: true  # 评论功能是否开启
---


Tranquilpeak Setup algolia search
<!-- excerpt -->

[//]: # <!-- more -->

# Tranquilpeak Setup algolia search

<!-- toc -->


## 注册并获取相关帐号信息

到Algolia观望注册一个帐号，然后新建一个index，可以在algolia站点找到Application, Search-Only API Key, Admin API Key。点击ALL API KEYS 找到新建INDEX对应的key，编辑权限，在弹出框中找到ACL选择勾选Add records, Delete records, List indices, Delete index权限，点击update更新。

## 编辑站点配置文件

编辑hexo根目录下的_config.yml文件，加入下列行：
	
	Algolia setting
	algolia:
	appId: "**************"
	apiKey: "**********"
	adminApiKey: "************"
	chunkSize: 5000
	indexName: "Blog"
	fields:
		- content:strip:truncate,0,500
		- excerpt:strip
		- gallery
		- permalink
		- photos
		- slug
		- tags
		- title


将文件中设置部分打开：

	algolia_search:
		enable: true
		hits:
			per_page: 10
		labels:
			input_placeholder: Search for Posts
			hits_empty: "We didn't find any results for the search: `${query}"
			hits_stats: "`${hits} results found in `${time} ms"
			
## 如何使用

每一次添加新的文章到要做一次：

	export HEXO_ALGOLIA_INDEXING_KEY=你的API Key
	hexo algolia

上面相当于建立搜索index上传到网上，这样静态网站就能访问index了


## 参考链接

https://www.zhihu.com/question/46822587
