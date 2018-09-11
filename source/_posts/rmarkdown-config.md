---
title: Setup rmarkdown on server without Rstudio
date: 2018-09-11 14:03:45
tags: [linux, GNU]
---


# How to Setup rmarkdown on server without Rstudio

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
