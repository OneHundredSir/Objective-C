//
//  ViewController.m
//  ZS_SDKDemo
//
//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "ViewController.h"
//#import "ZS_UIWebViewController.h"
#import "ZSSDKManager.h"
@interface ViewController ()<ZS_SDKDatasoure,ZS_SDKDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self _initIcon];
}


-(void)_initIcon
{
    UIButton *btn =[ [UIButton alloc]initWithFrame:(CGRect){0,0,100,100}];
    btn.backgroundColor = [UIColor redColor];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


//SDK调用部分
static NSString *webUrl = @"http://www.baidu.com";
-(void)btnAction
{
    shareZSSDKManager().setDelegate(self).setDatasource(self).sendToWeb(webUrl);
}


#pragma mark delegate
-(void)zs_webFeedBackJSContent:(NSURL *)urlFromWeb
{
    NSString *jsString  = @"alert('Nihao');";
    shareZSSDKManager().sendJSCommandToWeb(jsString);
    NSLog(@"%@",urlFromWeb);
}


#pragma mark datasource
-(UIViewController *)zs_webPresentedWithRootViewcontroller
{
    
    return self;
}

@end
