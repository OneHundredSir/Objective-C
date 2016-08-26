感谢JSpatch:[官网地址](http://jspatch.com/)
本篇只是一个介绍,具体实现请转到我的另一篇文章看具体操作:
[使用jspatch热更新(实用Demo篇)](http://www.jianshu.com/p/19d198dfccaf)
##JSPatch是什么
---
>**JSPatch**是一个开源项目，只需要在项目里引入极小的引擎文件，就可以使用 JavaScript 调用任何 Objective-C 的原生接口，替换任意 Objective-C 原生方法。目前主要用于下发 JS 脚本替换原生 Objective-C 代码，实时修复线上 bug.

##JSPatch接入
---
>注册

**1. 注册jspatch账号并登录.(http://www.jspatch.com).**
      添加应用,获取appKey

![登陆获取appkey](http://upload-images.jianshu.io/upload_images/1730495-2c48aa2e9670ec46.gif?imageMogr2/auto-orient/strip)

**2. 在"我的app"中添加新的app,未上线项目无需填写AppStoreID,添加完成后可以看到appKey.**
**3. 导入framework和相关类库**
在官网下载SDK,将解压得到的  `JSPatch.framework`  导入到项目,并添加依赖的类库:`libz.tbd`和`JavaScriptCore.framework`即可.

![添加libz.tbd和JavaScriptCore.framework](http://upload-images.jianshu.io/upload_images/1730495-9d5713b8ed321b9b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


**4. 测试补丁和发布补丁**
**本地测试**:新建一个main.js文件,在这个文件中编写js代码(用于替换oc代码的),这个main.js文件如果在项目中,通过`[JSPatch testScriptInBundle]`;

![本地测试](http://upload-images.jianshu.io/upload_images/1730495-b7d343fcb6f73c0d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**在线更新**:方法测试补丁,补丁测试通过后,可以将这个main.js文件上传到jspatch官网,通过``[JSPatch startWithAppKey:@"APPKey"]``;方法调用在线补丁,项目中的appDelega.m文件中的代理方法中写入这个方法,发布的app每次启动时会在线查找补丁,如果有版本号一致的补丁,则会下载这个补丁,用来替换相应的方法.

![在线热更性](http://upload-images.jianshu.io/upload_images/1730495-48ed042e9a926c8f.gif?imageMogr2/auto-orient/strip)

**5. 发布补丁包**
 在app管理中"新建版本",新建版本后,上传main.js文件再点击提交即可.需要注意的是新建版本中的版本,对应项目的版本号,app在线上寻找补丁时,版本号是一个筛选条件.

##具体例子请看
---
>[使用jspatch热更新(实用Demo篇)](http://www.jianshu.com/p/19d198dfccaf)

##安全问题
---
**传输安全**
JSPatch脚本的执行权限很高，若在传输过程中被中间人篡改，会带来很大的安全问题，为了防止这种情况出现，我们在传输过程中对JS文件进行了RSA签名加密，流程如下：
服务端：
计算 JS 文件 MD5 值。
用 RSA 私钥对 MD5 值进行加密，与JS文件一起下发给客户端。
客户端：
拿到加密数据，用 RSA 公钥解密出 MD5 值。
本地计算返回的 JS 文件 MD5 值。
对比上述的两个 MD5 值，若相等则校验通过，取 JS 文件保存到本地。
由于 RSA 是非对称加密，在没有私钥的情况下第三方无法加密对应的 MD5 值，也就无法伪造 JS 文件，杜绝了 JS 文件在传输过程被篡改的可能。

**本地存储**
本地存储的脚本被篡改的机会小很多，只在越狱机器上有点风险，对此 JSPatch SDK 在下载完脚本保存到本地时也进行了简单的对称加密，每次读取时解密。

##常见问题:发布补丁后不起作用
---
原因可能有:
1. APPKey写错了(好好检查).
`错误信息:JSPatch: request success {error = "Document not found";}`
2. 发布的版本号和项目的版本号不一致(一定要一致,1.2版本的项目只能用1.2版本的补丁包)
`错误信息:JSPatch: request success {error = "Document not found";}`
3. main.js文件错误,是否找对了"类"和"方法"(类名和方法名要是写错,补丁想起作用也做不到啊)
`错误信息:不会出现任何"JSPatch: request success {}"提示`
4. main.js文件语法错误(main.js文件中的js语法错误,或者是oc方法名错误都会导致编译不通过,从而不执行main.js方法,最可怕的是他还不报错,jspatch的原则是,js文件能用就用,不能用,我不告诉你,就是不用.)(一个很长的oc方法转写成js方法是,是没有提示的,一个字母写错了,整个js文件就废了,最关键的是,这些错误的是隐形的,不提示,难发觉,更难找,所以我建议两点,第一,写补丁时现在本地测试,在本地的main.js文件中写一行测试一行,保证每一行都是正确的.第二,把要改的oc代码,暂时copy到main.js文件中,这样,当你在js中写oc的方法名时,而这个方法名在你copy的那段代码中,xcode就会给提示.)
`错误信息:输出成功信息JSPatch: request success {v = 1;},但是依然执行oc代码而不是js代码`

>作者信息

如果有不足或者错误的地方还望各位读者批评指正，可以评论留言，笔者收到后第一时间回复。**允许转载,转载后请给在评论区留下转载地址,转载时请注明出处,否则保留追究权利~**

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
