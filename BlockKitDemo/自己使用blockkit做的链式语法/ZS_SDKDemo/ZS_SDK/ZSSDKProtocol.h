//
//  ZSSDKProtocol.h
//  ZS_SDKDemo
//
//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@protocol ZS_SDKDelegate <NSObject>

#pragma mark  数据回调,H5交互,webview返回的JS数据
-(void)zs_webFeedBackJSContent:(NSURL *)urlFromWeb;

@end


#pragma mark 数据源方法
@protocol ZS_SDKDatasoure <NSObject>
@required
-(UIViewController *)zs_webPresentedWithRootViewcontroller;
@end

#pragma mark 个推的数据源方法
@protocol ZS_GTDatasoure <NSObject>
@required
-(UIViewController *)zs_GTPresentedWithRootViewcontroller;
@end
