//
//  ViewController.m
//  webtest
//
//  作者:香蕉  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import <MBProgressHUD.h>

#define ZSUrl @"www.baidu.com"
@interface ViewController ()

@end

@implementation ViewController
{
    //必须采用全局的，不然监听就会失效！，千万不可以放在局部是创建对象，这样对象消失了监听就没有了！
    Reachability *r;
    Reachability *inter;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self CheckConnectWithNetworkStand];
}



- (IBAction)btn:(id)sender
{
//    [self isConnectionAvailable];
    
}


-(BOOL)CheckConnectWithNetwork
{
    r = [Reachability reachabilityWithHostName:ZSUrl];
    BOOL isSuccess = r.currentReachabilityStatus == NotReachable?0:1;
    [self alertActionWithTitle:isSuccess?@"成功连接网络":@"不能连接网络"];
    return isSuccess;
}

/**
 *  实时监听连接网络对象，看对方需要，是否要暴露直接让客户自己设置监听
 *  有一个弊端，由于设置单例所以只有进程挂了才会释放.
 *  @param observer 传入的监听对象，但是行为是由监听对象实现的
 */
-(void)CheckConnectWithNetworkStand
{
    // 设置网络检测的站点
     r = [Reachability reachabilityWithHostName:ZSUrl];
     inter = [Reachability reachabilityForInternetConnection];
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    [r startNotifier];
    [inter startNotifier];
}


- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSLog(@"Reachability:%@",curReach);
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    BOOL isExistenceNetwork = YES;
    switch (status) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    NSArray *arrType = @[@"NotReachable",
                         @"ReachableViaWiFi",
                         @"ReachableViaWWAN"];
    if (!isExistenceNetwork) {
        [self alertActionWithTitle:@"没有网络"];
    }else
        [self alertActionWithTitle:[NSString stringWithFormat:@"有网络，网络类型为：%@",arrType[status]]];
}


-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    NSArray *arrType = @[@"NotReachable",
                         @"ReachableViaWiFi",
                         @"ReachableViaWWAN"];
    if (!isExistenceNetwork) {
        [self alertActionWithTitle:@"没有网络"];
        return NO;
    }else
        [self alertActionWithTitle:[NSString stringWithFormat:@"有网络，网络类型为：%@",arrType[[reach currentReachabilityStatus]]]];
    return isExistenceNetwork;
}

-(void)alertActionWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];//<span style="font-family: Arial, Helvetica, sans-serif;">MBProgressHUD为第三方库，不需要可以省略或使用AlertView</span>
    hud.removeFromSuperViewOnHide =YES;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(title, nil);//这里使用的是国际化语言
    hud.minSize = CGSizeMake(132.f, 108.0f);
    [hud hide:YES afterDelay:3];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
