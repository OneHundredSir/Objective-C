//
//  ZSSDKManager.m
//  ZS_SDKDemo
//
//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "ZSSDKManager.h"
#import "ZSSDKCenterManager.h"
#import <UIKit/UIKit.h>
static ZSSDKManager *_staticInstance;

inline ZSSDKManager *shareZSSDKManager() {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _staticInstance = [[ZSSDKManager alloc] init];
    });
    return _staticInstance;
}

@interface ZSSDKManager ()<ZS_SDKDelegate>

@property(nonatomic,strong)ZSSDKCenterManager *centerManager;

@property(nonatomic,weak)id<ZS_SDKDelegate> callbackDelegate;

@property(nonatomic,weak)id<ZS_SDKDatasoure> callbackDatasource;

@end

@implementation ZSSDKManager


//初始化
-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark 外接调用设置代理方法
-(ZSSDKManager* ((^)(id<ZS_SDKDelegate>)))setDelegate{
    //这里返回的不仅仅是一个BOOL,更应该是一个带着delegate的block,由SET方法传进去的!
    return ^(id<ZS_SDKDelegate> delegate){
        
        if ([delegate conformsToProtocol:@protocol(ZS_SDKDelegate)]) {
            shareZSSDKManager().setCallbackDelegate(delegate);
        }
        return self;
    };
}

#pragma mark == 设置代理动作(不对外暴露) ==
static char *queueName = "queue";
- (ZSSDKManager *(^)(id<ZS_SDKDelegate>))setCallbackDelegate {
    
    return ^(id <ZS_SDKDelegate> delegate){
        
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
            _callbackDelegate = delegate;
        dispatch_queue_t queue = dispatch_queue_create(queueName, DISPATCH_QUEUE_SERIAL);
        _centerManager = [[ZSSDKCenterManager alloc]initWithDelegate:delegate andQueue:queue];
//        });
        return self;
    };
}


#pragma mark 外接调用设置数据源方法
-(ZSSDKManager* ((^)(id<ZS_SDKDatasoure>)))setDatasource
{
    return ^(id<ZS_SDKDatasoure> mydatasource){
        if ([mydatasource conformsToProtocol:@protocol(ZS_SDKDatasoure)]) {
            shareZSSDKManager().setCallbackDataSource(mydatasource);
        }
        return self;
    };
}

#pragma mark == 设置数据源动作(不对外暴露) ==
- (ZSSDKManager *(^)(id<ZS_SDKDatasoure>))setCallbackDataSource
{
    return ^(id<ZS_SDKDatasoure> datasource)
    {
        _callbackDatasource = datasource;
        _centerManager.datasource = datasource;
        return self;
    };
}


#pragma mark 设置连接网页
-(ZSSDKManager *((^)(NSString *)))sendToWeb
{
    return ^(NSString *urlStr)
    {
        [_centerManager managerConfigWithWebUrl:urlStr];
        return self;
    };
}

#pragma mark 设置传JS调用数据
-(ZSSDKManager *((^)(NSString *)))sendJSCommandToWeb
{
    return ^(NSString *jsCommand)
    {
        [_centerManager sendToWebWithJSCommand:jsCommand];
        return self;
    };
}





@end
