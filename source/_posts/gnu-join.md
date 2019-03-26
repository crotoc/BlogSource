---
title: Gnu join - join two files by specified field
date: 2018-08-10 12:36:45
categories: '小技巧'
tags: ['linux']	
#  tags: ['计划','建站','Hexo']
keywords:
- 'join'
#  - hexo
#  - '建站'
clearReading: true  # 在文章页隐藏侧栏，以更好地阅读。
#  thumbnailImage: http://upyun.geekap.com/gitblog-img/car-6-140.jpg  //首页文章列表显示的缩略图
thumbnailImage: https://img1.quimg.com/upload/201712/1513834333388.jpg  # 首页文章列表显示的缩略图	
thumbnailImagePosition: left  # 缩略图显示的位置，上下左右都可以
autoThumbnailImage: true  #  开启后如果没有设置缩略图，会自动设置为图片画廊里的第一张，或者其他文章的图。
metaAlignment: center  # 文章页图片上的文字居中显示
coverImage: https://img1.quimg.com/upload/201712/1513834333388.jpg  # 文章页最上面的那个大图
# coverImage: http://upyun.geekap.com/gitblog-img/cover-v1.2.0.jpg  # 文章页最上面的那个大图
coverCaption: "Hexo建站分享"  # 大图下面的小标题
coverMeta: in  # 图片上的文字显示在图片上，或者显示在图片外面
coverSize: full  # 大图显示的尺寸，full是全屏展示
comments: true  # 评论功能是否开启
---


Gnu join - join two files by specified field
<!-- excerpt -->

[//]: # <!-- more -->

# Gnu join - join two files by specified field

<!-- toc -->



## Basic usage

Create two files with *TAB* delimiter

file1:
	
	a    1
	b   1
	d       1
	e       1
	g       1
	
	
file2:

	a   2
	b   2
	c   2
	e   2
	f   2

Join them use join:
   
    join -1 1 -2 1 file1 file2

Output:

	a 1 2
	d 1 2
	e 1 2
	

## The very useful options for GNU join

### -a1 - print unmatched lines in file1;

	join -1 1 -1 1 file1 file2 -a1
	
Output:

	a 1 2
	b 1
	d 1 2
	e 1 2
	g 1

### -a2 - print unmatched lines in file2
	
	join -1 1 -1 1 file1 file2 -a2
	
Output:

	a 1 2
	c 2
	d 1 2
	e 1 2
	f 2

### -a1 -a2 - print unmatched lines in both file1 and file2

	join  -1 1 -1 1 file1 file2 -a1 -a2

Output:

	a 1 2
	b 1
	c 2
	d 1 2
	e 1 2
	f 2
	g 1


*Be careful that tab is not aligned well.*

### -o - To align the output in table format, use the option to custome the output

	join  -1 1 -1 1 file1 file2 -a1 -a2 -o 0,1.2,2.2

*0*  means the joined column.
*1.2* means print the column 2 in file1;
*2.2* means print the column 2 in file2;

Output:

	a 1 2
	b 1 
	c  2
	d 1 2
	e 1 2
	f  2
	g 1 

If file1 and files have more than 2 columns, modify the -o string

### -t - To use the *TAB* as output delimiter

	join  -1 1 -1 1 file1 file2 -a1 -a2 -o 0,1.2,2.2 -t$'\t'
	
Output:

	a       1       2
	b       1
	c               2
	d       1       2
	e       1       2
	f               2
	g       1
	

### --check-order -  join requires the input file sorted, if join with 1st column, please sort the input files using 1st columns before use join. And to make sure there is no problem, use this option to check.

	join  -1 1 -1 1 file1 file2 -a1 -a2 -o 0,1.2,2.2 -t$'\t' --check-order

Output:

	a       1       2
	b       1
	c               2
	d       1       2
	e       1       2
	f               2
	g       1
	
Create non-sorted file3:

	a       3
	d       3
	c       3
	e       3
	f       3
	
join file1 and file3:

	join  -1 1 -1 1 file1 file3 -a1 -a2 -o 0,1.2,2.2 -t$'\t' --check-order


Output with error message:

	a       1       3
	b       1
	join: file3:3: is not sorted: c 3



### -e -  To make the output format more strict and use this option to fill missing columns. This helps greatly if you need to process the file in the downstreaming analysis.

	join  -1 1 -1 1 file1 file2 -a1 -a2 -o 0,1.2,2.2 -t$'\t' --check-order -eNULL
	
Output:

	a       1       2
	b       1       NULL
	c       NULL    2
	d       1       2
	e       1       2
	f       NULL    2
	g       1       NULL

Output is a very tidy table.

