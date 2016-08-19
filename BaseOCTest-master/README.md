今天有幸看到了一篇文章主要讲解了一些GCD,NSTimer,以及隐式创建定时器取消定时器，我们常规使用的地方
最近刚好也准备研究一下pthread,今天简单 把我早上刚刚弄的demo稍微编辑一下

---
>##NSTimer

```
简单说一下NSTimer ，
NStimer启动的条件就是必须要使用runloop，主线程肯定有一个runloop，但是子线程也有，一般情况下默认都是关闭的，具体开启方法等有用到再讲解
启动的方法
方法一:（隐式创建法/暂停）
[self performSelectorOnMainThread:@selector(showSomeThing:) withObject:nil waitUntilDone:NO ];

取消定时器
[self canPerformUnwindSegueAction:@selector(showSomeThing:) fromViewController:self withSender:nil];


方法二:（创建自动启动）

这个方法可以直接启动定时器，但是定时器会自动假如当前主线程的runloop中，所以，如果对象调用了这个方法默认是不销毁的，dealloc打印一下就明白了
[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showSomeThing:) userInfo:nil repeats:YES];

常用的解决方法就是使用timer，接回返回值，并在控制器或者对象结束使用释放之前把
timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showSomeThing:) userInfo:nil repeats:YES];
[timer invalidate]

方法三:（创建手动启动）
self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(showSomeThing:) userInfo:@[@"你好",@"真的不知道"] repeats:YES];
// [self.timer fire];//这是销毁该功能，但是我在使用过程中发现没有假如runloop居然可以实现进入函数,暂时留着这个疑问，找到解决再补上
[[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

同理每次使用完都要销毁，最重要如果用同一个自己创建的属性前都需要记得释放

[self.timer invalidate];
[self begintime];//这个是把上面两行代码自己封装的方法


```

以下用一个demo展示一下dealloc的
>1、跳转在viewDidLoad的时候启动定时器

```

- (void)viewDidLoad {
    [super viewDidLoad];
    [self begintime];
//    NSLog(@"正式开始");
}

-(void)begintime
{
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(showSomeThing:) userInfo:@[@"你好",@"真的不知道"] repeats:YES];
    //    [self.timer fire];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [self.timer invalidate];
}


```

###Demo展示（跳转启动定时器，返回定时器销毁，没有点击重复创建的按钮）

![跳转启动定时.gif](http://upload-images.jianshu.io/upload_images/1730495-dec668f93226fcc8.gif?imageMogr2/auto-orient/strip)

>2、点击button的时候执行以下语句

```
- (IBAction)begin:(id)sender
{
    num++;
    [self begintime];
//    [self.timer invalidate];不在这里销毁
}
```
这里的timer没有销毁，只销毁了一次，因为这里的timer对象有两个
![点击了事件.gif](http://upload-images.jianshu.io/upload_images/1730495-f2f3c76934a21468.gif?imageMogr2/auto-orient/strip)


所以正确的使用方法如下
```
- (IBAction)begin:(id)sender
{
    [self.timer invalidate];//先销毁再使用可以保证每次都把定时器先关闭
    num++;
    [self begintime];

}
```
**[定时器测试  Demo](https://github.com/OneHundredSir/Flower_OC)**

项目仿写请勿用于商业～仅供学习交流，如有侵犯公司商业权益请联系我的微信:hundreda，我将及时处理相关信息

喜欢的朋友可以赏我2块大洋买糖吃～和我一样屌丝的朋友希望能给我点个赞～需要我录制视频的请直接给我糖。一起做一个乐于分享的人吧

