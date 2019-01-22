---
title: Install customized fonts for imagemagick
date: 2018-09-28 23:46:24
tags: [trick]
---

# Install customized fonts for imagemagick 7
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
		
