---
title: Modify the hotkey of Chinese-English language switching in Windows 10
date: 2018-09-25 11:51:49
categories: '电脑设置'
tags: ['hotkey']	
#  tags: ['计划','建站','Hexo']
keywords:
- 'hotkey'
#  - hexo
#  - '建站'
clearReading: true  # 在文章页隐藏侧栏，以更好地阅读。
#  thumbnailImage: http://upyun.geekap.com/gitblog-img/car-6-140.jpg  //首页文章列表显示的缩略图
thumbnailImage: https://static.boredpanda.com/blog/wp-content/uploads/2015/11/reflection-landscape-photography-jaewoon-u-fb.jpg  # 首页文章列表显示的缩略图	
thumbnailImagePosition: left  # 缩略图显示的位置，上下左右都可以
autoThumbnailImage: true  #  开启后如果没有设置缩略图，会自动设置为图片画廊里的第一张，或者其他文章的图。
metaAlignment: center  # 文章页图片上的文字居中显示
coverImage: https://static.boredpanda.com/blog/wp-content/uploads/2015/11/reflection-landscape-photography-jaewoon-u-fb.jpg  # 文章页最上面的那个大图
# coverImage: http://upyun.geekap.com/gitblog-img/cover-v1.2.0.jpg  # 文章页最上面的那个大图
coverCaption: "Hexo建站分享"  # 大图下面的小标题
coverMeta: in  # 图片上的文字显示在图片上，或者显示在图片外面
coverSize: full  # 大图显示的尺寸，full是全屏展示
comments: true  # 评论功能是否开启
---


Modify the hotkey of Chinese-English language switching in Windows 10
<!-- excerpt -->

[//]: # <!-- more -->

# Modify the hotkey of Chinese-English language switching in Windows 10

<!-- toc -->


The problem is very annoying because the hotkey ctrl+space has conflicted with others in emacs or other program. My thought is changing it to another combination ctrl+F1.

1. Open regedit
2. Navigate to HKEY_USER\.DEFAULT\Input Method\Hot Keys\00000010\
3. Modify the Key Modifiers and Virtual Key.
4. Only disable the hotkey is change the first two digits of the two keys in 00.
	
		Key Modifiers: 00 c0 00 00.
		Virtual Key: 00 00 00 00

5. For Key modifiers, the rules of the number are like:
   
		__00__ c0 00 00 : The underlining two digits indicate one of modifier keys.
				
		CTRL: 02
		ALT: 01
		SHIFT: 04
		Disable: 00
		
		00 __c0__ 00 00 : The underlining two digits indicate the left or right position on the keybord.
		
		Left: 80
		Right: 40
		Left or Right: 8+4=12=c0
	
6. For virtual key, the rules are like:

		__00__ 00 00 00 : The hex of ascii of a virtual key.
	
	Please see the reference: https://docs.microsoft.com/en-us/windows/desktop/inputdev/virtual-key-codes
	
	So if we want F1, the hex code is 70:
		
		__70__ 00 00 00 : The hex of ascii of F1.
		
7. Restart your computer.

For my case, I just need to modify virtual key to 70 00 00 00
