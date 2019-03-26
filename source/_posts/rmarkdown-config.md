---
title: Setup rmarkdown on server without Rstudio
date: 2018-09-11 14:03:45
categories: '电脑设置'
tags: ['工作']	
#  tags: ['计划','建站','Hexo']
keywords:
- 'rmarkdown'
#  - hexo
#  - '建站'
clearReading: true  # 在文章页隐藏侧栏，以更好地阅读。
#  thumbnailImage: http://upyun.geekap.com/gitblog-img/car-6-140.jpg  //首页文章列表显示的缩略图
thumbnailImage: http://www.cncd8.com/uploads/allimg/120308/1-12030R10R7.jpg  # 首页文章列表显示的缩略图	
thumbnailImagePosition: left  # 缩略图显示的位置，上下左右都可以
autoThumbnailImage: true  #  开启后如果没有设置缩略图，会自动设置为图片画廊里的第一张，或者其他文章的图。
metaAlignment: center  # 文章页图片上的文字居中显示
coverImage: http://www.cncd8.com/uploads/allimg/120308/1-12030R10R7.jpg  # 文章页最上面的那个大图
# coverImage: http://upyun.geekap.com/gitblog-img/cover-v1.2.0.jpg  # 文章页最上面的那个大图
coverCaption: "Hexo建站分享"  # 大图下面的小标题
coverMeta: in  # 图片上的文字显示在图片上，或者显示在图片外面
coverSize: full  # 大图显示的尺寸，full是全屏展示
comments: true  # 评论功能是否开启
---


Setup rmarkdown on server without Rstudio
<!-- excerpt -->

[//]: # <!-- more -->

# Setup rmarkdown on server without Rstudio

<!-- toc -->


## Install texlive

Because the server is centos6 and the glibc is too old to support texlive 2018, I downloaded texlive 2017 from a website.

	wget http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2017/texlive2017-20170524.iso

Mount the iso and then cp the files to a dir, cd to the dir and them install a minimal distribute using the command:

	cd ~/chenr6/download/texlive
	./install-tl --gui=text

If you want to install to a specific dir:

	export TEXLIVE_INSTALL_PREFIX=/your/dir/


Input capital S to select scheme and input lower case d to select basic scheme:


	Select scheme:

	a [ ] full scheme (everything)
	b [ ] medium scheme (small + more packages and languages)
	c [ ] small scheme (basic + xetex, metapost, a few languages)
	d [X] basic scheme (plain and latex)
	e [ ] minimal scheme (plain only)
	f [ ] ConTeXt scheme
	g [ ] GUST TeX Live scheme
	h [ ] infrastructure-only scheme (no TeX at all)
	i [ ] teTeX scheme (more than medium, but nowhere near full)
	j [ ] custom selection of collections
	
	Actions: (disk space required: 157 MB)
	<R> return to main menu
	<Q> quit

	Enter letter to select scheme: d

Input R to return

Input O to ignore the installation of document:

	Options customization:

	<P> use letter size instead of A4 by default: [ ]
	<E> execution of restricted list of programs: [X]
	<F> create format files:                      [X]
	<D> install font/macro doc tree:              [ ]
	<S> install font/macro source tree:           [ ]
	<L> create symlinks in standard directories:  [ ]
	binaries to: 
	manpages to: 
	info to: 
	<Y> after installation, get package updates from CTAN: [X]

	Actions: (disk space required: 157 MB)
	<R> return to main menu
	<Q> quit

	Enter command: 

Input R to return and Input I to begin the installation

## Setup texlive

After installation, put the binary dir to your PATH:

	export PATH=$PATH:/your/dir/to/bin/

To avoide to use the local repository, which is default, set a online repository:

	tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet

Install the missing packages by using the command:

	tlmgr list ecrm2074
	
		Packages containing files matching crm2074':
		ec:
			texmf-dist/fonts/source/jknappen/ec/ecrm2074.mf
			texmf-dist/fonts/tfm/jknappen/ec/ecrm2074.tfm
		
The package including ecrm2074 is ec, so use the command:

	tlmgr install ec

If you want to install the package to a specific dir:

	export TEXMFHOME=/your/dir/
	


## 

Test your installation by compile a pdf using:

	pdflatex your.tex
