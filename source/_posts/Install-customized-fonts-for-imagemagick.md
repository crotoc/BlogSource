---
title: Install customized fonts for imagemagick
date: 2018-09-28 23:46:24
categories: '小技巧'
tags: ['图片处理']	
#  tags: ['计划','建站','Hexo']
keywords:
- 'imagemagick'
#  - hexo
#  - '建站'
clearReading: true  # 在文章页隐藏侧栏，以更好地阅读。
#  thumbnailImage: http://upyun.geekap.com/gitblog-img/car-6-140.jpg  //首页文章列表显示的缩略图
thumbnailImage: https://images.pexels.com/photos/7314/nature-sunset-flowers-silhouette.jpg?auto=compress&cs=tinysrgb&dpr=1&w=500  # 首页文章列表显示的缩略图	
thumbnailImagePosition: left  # 缩略图显示的位置，上下左右都可以
autoThumbnailImage: true  #  开启后如果没有设置缩略图，会自动设置为图片画廊里的第一张，或者其他文章的图。
metaAlignment: center  # 文章页图片上的文字居中显示
coverImage: https://images.pexels.com/photos/7314/nature-sunset-flowers-silhouette.jpg?auto=compress&cs=tinysrgb&dpr=1&w=500  # 文章页最上面的那个大图
# coverImage: http://upyun.geekap.com/gitblog-img/cover-v1.2.0.jpg  # 文章页最上面的那个大图
coverCaption: "Hexo建站分享"  # 大图下面的小标题
coverMeta: in  # 图片上的文字显示在图片上，或者显示在图片外面
coverSize: full  # 大图显示的尺寸，full是全屏展示
comments: true  # 评论功能是否开启
---


Install customized fonts for imagemagick
<!-- excerpt -->

[//]: # <!-- more -->

# Install customized fonts for imagemagick

<!-- toc -->

1. Download the font, for example, Roboto 

		wget https://fonts.google.com/download?family=Roboto

2. Download the processing script for fonts

		wget http://imagemagick.org/Usage/scripts/imagick_type_gen
		chmod +x imagick_type_gen

3. According to the documents of imagemagick 7 (https://imagemagick.org/script/resources.php), ImageMagick is able to load raw TrueType and Postscript font files. It searches for the font configuration file, type.xml, in the following order, and loads them if found:

		\$MAGICK_CONFIGURE_PATH
		\$MAGICK_HOME/etc/ImageMagick/-7.0.8
		\$MAGICK_HOME/share/ImageMagick-7.0.8
		\$XDG_CACHE_HOME/ImageMagick
		\$HOME/.config/ImageMagick
		<client path>/etc/ImageMagick
		\$MAGICK_FONT_PATH$

So create a dir ~/.config/ImageMagick

	mkdir ~/.config/ImageMagick

4. According the description section  in the script imageick_type_gen, create a xml for your fonts using the processing script:

		find /dir/to/font/ -type f -name '*.ttf' | imagick_type_gen -f - > ~/.ImageMagick/type-myfonts.xml


5. Include the xml in main xml file:

		cat <<\EOF >>~/.magick/type.xml
		<typemap>
		<include file="type-myfonts.xml" />
		</typemap>
		EOF

6. Check font using the command:

		convert -list font
		
