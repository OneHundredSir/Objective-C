//
//  ZSSDKCenterManager.m
//  ZS_SDKDemo
//
//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "ZSSDKCenterManager.h"

#import "ZS_UIWebViewController.h"

@interface ZSSDKCenterManager ()

@property(nonatomic,weak)id<ZS_SDKDelegate> delegate;

@property(nonatomic,strong)dispatch_queue_t queue;

@end

@implementation ZSSDKCenterManager
{
    UIViewController *managerVC;
    ZS_UIWebViewController *nowWebVC;
}

-(instancetype)init
{
    return nil;
}

-(instancetype)initWithDelegate:(id<ZS_SDKDelegate>)delegate
                       andQueue:(dispatch_queue_t )queue
{
    if (self = [super init])
    {
        self.delegate = delegate;
        self.queue = queue;
    }
    return self;
}


-(void)setDatasource:(id<ZS_SDKDatasoure>)datasource
{
    _datasource = datasource;
    if ([_datasource respondsToSelector:@selector(zs_webPresentedWithRootViewcontroller)])
    {
        managerVC = [_datasource zs_webPresentedWithRootViewcontroller];
    }
}
#pragma mark 对外的方法

//页面弹出加载H5
-(void)managerConfigWithWebUrl:(NSString *)webUrl
{
    if (managerVC) {
        ZS_UIWebViewController *webVC = [[ZS_UIWebViewController alloc]init];
        webVC.requestStr = webUrl;
        
        if ([self.delegate respondsToSelector:@selector(zs_webFeedBackJSContent:)]) {
            webVC.feedBackBlock = ^(NSURL *url,UIWebView *webView){
                [self.delegate zs_webFeedBackJSContent:url];
            };
        }
        
        [managerVC presentViewController:webVC animated:YES completion:nil];
        nowWebVC = webVC;
    }
}


-(void)sendToWebWithJSCommand:(NSString *)JSCommand
{
    nowWebVC.jsCommandStr = JSCommand;
}


@end
