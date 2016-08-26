//
//  ZS_APPDelegate.h
//  ZS_SDKDemo
//
//  Created by HUN on 16/8/16.
//  Copyright © 2016年 hundred Company. All rights reserved.
//


#import "ZS_APPDelegate.h"
#import "ZS_NotifyView.h"
#import "ZS_SDKCharacter.h"
@interface ZS_APPDelegate()

@end

@implementation ZS_APPDelegate
{
    UIViewController *viewController;
    ZS_NotifyView *alertView;
}


#pragma mark 代理设置
-(void)setDelegate:(id<ZS_SDKDelegate>)delegate
{
    _delegate =delegate;
    
}

-(void)setDatasource:(id<ZS_GTDatasoure>)datasource
{
    
    _datasource = datasource;
    if ([datasource respondsToSelector:@selector(zs_GTPresentedWithRootViewcontroller)]) {
        UIViewController *vc = [datasource zs_GTPresentedWithRootViewcontroller];
        CGFloat notiW = vc.view.frame.size.width * 0.8;
        CGFloat notiH = notiW * 0.6;
        ZS_NotifyView *notifyView = [[ZS_NotifyView alloc]initWithFrame:(CGRect){0,0,notiW,notiH}];
        notifyView.center = vc.view.center;
        notifyView.alpha = 0;
        [vc.view addSubview:notifyView];
        viewController = vc;
        alertView = notifyView;
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

-(void)dealloc
{
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
}


#pragma mark 这里都是自己写的一些方法,含有代理,这部分目前如果不用runtime用代理还是得在这里实现

//处理个推本地通知，判断是否存在gtNotification方法
- (void)geTuiMessageHandling:(NSNotification *)text{
    if (self.delegate) {
        if (viewController&&alertView)
        {
            [self viewDealWithText:text];
        }
        if ([self.delegate respondsToSelector:@selector(zs_gtreceiveRemoteNotification:)]) {
            [self.delegate zs_gtreceiveRemoteNotification:text];
        }
    }
}


//处理苹果远程通知，判断是否存在receiveRemoteNotification方法
- (void)receiveRemoteMessageHandling:(NSNotification *)text{
    
    if (self.delegate) {
        if (viewController&&alertView)
        {
            [self viewDealWithText:text];
        }
        if ([self.delegate respondsToSelector:@selector(zs_gtreceiveRemoteNotification:)]) {
            [self.delegate zs_gtreceiveRemoteNotification:text];
        }
    }
}


-(void)viewDealWithText:(NSObject *)noty
{
    NSNotification *curNotification=(NSNotification *)noty;
    NSString *infoStr = curNotification.userInfo[@"payload"];
    //目前后台没有核对要推送的数据类型,等具体确认了再做处理!
    NSDictionary *jsonDic= [self jsonTranslateToDicWithStr:infoStr];
    alertView.alpha = 1;
    alertView.imgUrlStr = @"http://www.huangyibiao.com/wp-content/uploads/2016/08/QQ20160818-6@2x.png";
    alertView.titleStr =@"标题";
    alertView.detailStr = @"这是内容部分";
    if ([self.delegate respondsToSelector:@selector(zs_gtNotificationWithAlertView:)]) {
        [self.delegate zs_gtNotificationWithAlertView:alertView];
    }
}

-(NSDictionary *)jsonTranslateToDicWithStr:(NSString *)str
{
    NSDictionary *dic= @{};
    return dic;
}


#pragma mark - 自己封装方法
-(void)delegateDictionaryForWebError:(ERROR_FORDIC)character
                              Domain:(NSString *)domain
                             andCode:(NSInteger)code
                   andDescriptionKey:(NSString *)descriptionKey
            andFailureReasonErrorKey:(NSString *)failureReasonErrorKey
       andRecoverySuggestionErrorKey:(NSString *)recoverySuggestionErrorKey
          andRecoveryOptionsErrorKey:(NSArray *)recoveryOptionsErrorKey
{
    NSError *error = [[NSError alloc] initWithDomain:domain
                                                code:code
                                            userInfo:@{NSLocalizedDescriptionKey:descriptionKey,
                                                       NSLocalizedFailureReasonErrorKey:failureReasonErrorKey,
                                                       NSLocalizedRecoverySuggestionErrorKey:recoverySuggestionErrorKey,
                                                       NSLocalizedRecoveryOptionsErrorKey:recoveryOptionsErrorKey}];
    
    if ([self.delegate respondsToSelector:@selector(zsDictionaryForWebError:andError:)]) {
        [self.delegate zsDictionaryForWebError:character andError:error];
    }
}
@end