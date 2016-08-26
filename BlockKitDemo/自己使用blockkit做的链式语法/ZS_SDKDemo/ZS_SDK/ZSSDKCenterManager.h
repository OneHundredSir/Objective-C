//
//  ZSSDKCenterManager.h
//  ZS_SDKDemo
//
//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import <Foundation/Foundation.h>
#import "ZSSDKProtocol.h"
@interface ZSSDKCenterManager : NSObject

// ----- for 属性
@property(nonatomic,weak)id<ZS_SDKDatasoure> datasource;




// ----- for 方法
-(instancetype)initWithDelegate:(id<ZS_SDKDelegate>)delegate
                       andQueue:(dispatch_queue_t )queue;


/**
 *  传值跳转页面值
 *
 *  @param webUrl 页面跳转访问
 */
-(void)managerConfigWithWebUrl:(NSString *)webUrl;


/**
 *  发送JS指令
 *
 *  @param JSCommand 发送指令
 */
-(void)sendToWebWithJSCommand:(NSString *)JSCommand;



@end
