---
title: new article
date: 2018-08-09 13:15:20
tags: [Network, linux]
---

This is my first post!

## Installation

How to install npm in linux;
	
	conda create --prefix=/your/nodejs/dir -c conda-forge nodejs

Put the /your/nodejs/dir/bin in your path by:

	export PATH=/your/nodejs/dir/bin:$PATH
	
Then install hexo:

	npm install --prefix=/your/nodejs_module/dir/ hexo-cli -g


## Use hexo generate a page

Then generate a dir including your blog:

	hexo init /your/blog/dir/
	cd /your/blog/dir/
	
Set the deployer in _yml_config:

	

	
