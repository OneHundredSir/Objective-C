文章最后附上本次讲解的Demo以及演示动态图：[GithubDemo](https://github.com/OneHundredSir/Objective-C/tree/master/webtest)
>1、说明

在网络应用中，需要对用户设备的网络状态进行实时监控，有两个目的：
（1）让用户了解自己的网络状态，防止一些误会（比如怪应用无能）
（2）根据用户的网络状态进行智能处理，节省用户流量，提高用户体验
　　  WIFI\3G网络：自动下载高清图片
　　  低速网络：只下载缩略图
　　  没有网络：只显示离线的缓存数据
iOS7以前苹果官方提供了一个叫Reachability的示例程序，便于开发者检测网络状态
连接:[官方演示连接](https://developer.apple.com/library/ios/samplecode/Reachability/Reachability.zip)
iOS7之后苹果提供了 <CoreTelephony/CTTelephonyNetworkInfo.h>可以获取当前的网络状态（但是没找到wifi）

>**二、监测网络状态**

Reachability的使用步骤
添加框架SystemConfiguration.framework
(1) 点击项目，选择"Build Phases"选项卡
(2) 展开"Link Binary With Libraries"并添加相应选项

![导入系统库](http://upload-images.jianshu.io/upload_images/1730495-d39d37683031e376.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


下载Reachability项目的压缩包，右击工程文件夹（注意不是总的那个项目文件）添加以下文件
添加Reachability.h 和 Reachability.m
在需要调用的m文件中包含相应头文件具体
#import "Reachability.h"

>具体实现的图文展示用了两个例子：


![demo1](http://upload-images.jianshu.io/upload_images/1730495-b23d96f667a26bea.gif?imageMogr2/auto-orient/strip)



![demo2](http://upload-images.jianshu.io/upload_images/1730495-2111288953c1d8b3.gif?imageMogr2/auto-orient/strip)






>自己思考的疑问点：

1、hostReachability与internetReachability的差异在哪？
```
hostReachability:主要指的是我们的移动网络,所以这里可以自己处理要移动网络还是不要

internetReachability：
只涵盖两种网络，
有线网络（WWAn）,无线网络(Wifi)
具体实现可以看我的demo
```

2、实现的时候注意，一定要把观察的对象作为属性，或者全局变量，不然使用完消失就观察不了（同样的例子适用于视频播放等等）


![注意点](http://upload-images.jianshu.io/upload_images/1730495-0ae25e6e93b3ecb4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


本次讲解的Demo：[GithubDemo](https://github.com/OneHundredSir/Objective-C/tree/master/webtest)

##赠人点赞，手留余香~~~~

![点赞图片](http://upload-images.jianshu.io/upload_images/1730495-1e47fa324e85fb46.gif?imageMogr2/auto-orient/strip)

>作者信息

如果有不足或者错误的地方还望各位读者批评指正，可以评论留言，笔者收到后第一时间回复。

|名称|具体信息|
|:--:|:--:|
|QQ/微信|hundreda |
|简书号连接|[iOS-香蕉大大](http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles)|
|GitHub个人开源主页|[GitHub连接](https://github.com/OneHundredSir)|
|好心人赏我个`赞`|`欢迎各位前来查看，star,感谢各位的阅读`|
|个人iOS开发QQ讨论群|**365204530**|
|`群内规矩`|`聊天扯淡，讨论技术都行，没有什么群规，不懂就问`|
|iOS开发类微信订阅号|**大大家的IOS说**|
|*微信扫一扫下面二维码* |`一起用碎片时间学习IOS吧`|


![微信个人技术订阅号](http://upload-images.jianshu.io/upload_images/1730495-755d908f00d77cf8.gif?imageMogr2/auto-orient/strip)
喜欢的朋友可以赏我2块大洋买糖吃～你的打赏是我前进的动力~一起做一个乐于分享的人吧~
