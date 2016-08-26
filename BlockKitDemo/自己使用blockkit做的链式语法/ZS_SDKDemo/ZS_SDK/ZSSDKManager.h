//
//  ZSSDKManager.h
//  ZS_SDKDemo
//
//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import <Foundation/Foundation.h>
#import "ZSSDKProtocol.h"
@interface ZSSDKManager : NSObject
#pragma mark == 管理单例对象 ==
extern ZSSDKManager *shareZSSDKManager();

#pragma mark == 设置委托对象 ==
/**
 *  设置委托 返回BOOL判断是否设置成功
 设置成功后才可使用中心管理器方法
 需保证委托对象被其他对象强持有且常驻内存
 否则被销毁后无法调用和再次设置委托
 
 委托对象需遵守两个协议： ZS_SDKDelegate，
 委托方法:
 updateStateWithCentralManager:
 */
@property (nonatomic,copy,readonly) ZSSDKManager* ((^setDelegate)(id <ZS_SDKDelegate> delegate));



#pragma mark == 设置数据源对象 ==
/**
 *  设置数据源 返回BOOL判断是否设置成功
 设置成功后才可使用推出去的页面控制器方法
 需保证委托对象被其他对象强持有且常驻内存
 否则被销毁后无法调用和再次设置数据源
 
 委托对象需遵守数据源： ZS_SDKDelegate，
 委托方法:
 updateStateWithCentralManager:
 */
@property (nonatomic,copy,readonly) ZSSDKManager* ((^setDatasource)(id <ZS_SDKDatasoure> datasource));



/**
 *  跳转页面
 */
@property(nonatomic,copy,readonly)ZSSDKManager* ((^sendToWeb)(NSString *urlStr));


@property(nonatomic,copy,readonly)ZSSDKManager* ((^sendJSCommandToWeb)(NSString *urlStr));

@end
