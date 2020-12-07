
title: How to get push notification in eufy/ring/alro/twitter/gmail/etc on huawei mate30/mate40/p30/p40
date: 2020-12-06 20:53:01
#  categories: 小技巧
#  tags: ['linux']
keywords:
- 'push notification'
#  - '建站'
clearReading: true  # 在文章页隐藏侧栏，以更好地阅读。
thumbnailImage: https://images.pexels.com/photos/1323550/pexels-photo-1323550.jpeg?cs=srgb&dl=pexels-simon-matzinger-1323550.jpg&fm=jpg   # 首页文章列表显示的缩略图	
thumbnailImagePosition: left   # 缩略图显示的位置，上下左右都可以
autoThumbnailImage: true   #  开启后如果没有设置缩略图，会自动设置为图片画廊里的第一张，或者其他文章的图。
metaAlignment: center   # 文章页图片上的文字居中显示
coverImage: https://images.pexels.com/photos/1323550/pexels-photo-1323550.jpeg?cs=srgb&dl=pexels-simon-matzinger-1323550.jpg&fm=jpg  # 文章页最上面的那个大图
coverCaption: "在美国用华为太不容易了"   # 大图下面的小标题
coverMeta: in   # 图片上的文字显示在图片上，或者显示在图片外面
coverSize: full   # 大图显示的尺寸，full是全屏展示
comments: true   # 评论功能是否开启
---

How to get push notification in eufy/ring/alro/twitter/gmail/etc on huawei mate30/mate40/p30/p40
<!-- excerpt -->

# <!-- more -->

# How to get push notification in eufy/ring/alro/twitter/gmail/etc on huawei mate30/mate40/p30/p40
<!-- toc -->


# install gms

A lot of tutorials focus on this, I just skip this

# Fress GMS

The cause of no notification comes from the modified gms apk installed during last step. The firebase pushing message service of gms is not working right now. To overcome this, please do like following:

Getting Push Notificaion to work:

1. If everything went well, there are no errors and the market is working. Download Ice Box (developed by Ruoxin He) from the PlayStore. (Or use the one inside the Zip)
2. Delete the Applications "G", Google Accounts, Device Info.
3. Install Minimal ADB on PC
4. HiSuit must be installed on the PC. You can download it from the official site. https://consumer.huawei.com/en/support/hisuite/
5. Launch IceBox
6. Click 2 times on the arrow in the lower right corner
7. In the proposed list, select line 3 "Simple ADB"
8. We connect the Phone to the PC where Minimal ADB and HiSuit are already installed.
9. Choose "data transfer" on the Popup on your Phone.
10. Go Settings - About the phone - click on the build number 5 times - see the message You have become a developer.
11. Next we go settings - System and updates - For developers, search for "USB Debugging" and turn it on. ATTENTION! Hisuit started on the computer and a code appears on the phone, just minimize the window that opens.
12. On your Phone allow the debugging connection in the popup window.
13. Launch IceBox again.
14. Launch Minimal ADB on the PC.
15. At the command prompt, enter: adb shell sh /sdcard/Android/data/com.catchingnow.icebox/files/start.sh
Press Enter. "Success" should appear, if not, then you did something wrong.
16. In IceBox, double-click on the arrow, then select line 3 "Simple ADB"
17. Click "GOT IT", then go to the SYSTEM tab on top. On the Pop up a warning click "GOT IT". Then tap in the right upper corner on the Search Icon. Search for "FRAME". Select the Google Services Framework, click Frost in the menu below. Close the application, reboot the device.
18. After the restart install the AuroraStore.apk oder download it from the official site: https://auroraoss.com/
19. Launch AuroraStore and at startup, be sure to select an anonymous account!
20. Search for "Push Notification Tester" and install it.
21. Launch "Push Notification Tester" and press on Start. It should show check mark for all four test:
22. If "Register for Push Notification" has a red X, then go into Settings -> Apps -> Search for "google" -> Show System Apps -> Select "Google Service Framework" and hit "Activate".
23. Launch "Push Notification Tester" again and press on Start. If it looks like the picture above, then repeat Step 13. - 18.

24. After restart Launch "Push Notification Tester" and press on Start it should still look like the picture above.

Congratulations you have working Push Notifications.
If you open now the PlayStore , you will get a connection error.
The error will remain as long as "Google Service Framework" is frozen by IceBox.

As mentioned at the beginning. Only the Playstore or the Push Notification can work. Not both together!


Thank rayx0401 very much for supply this steps. I finally make Ring and eufy security work. Hooray!

Oringinal link: https://forum.xda-developers.com/t/p40-pro-with-gms-notifications-issues.4082843/page-4
