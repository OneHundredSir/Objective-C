//
//  ZS_APPDelegate.h
//  ZS_SDKDemo
//
//  Created by HUN on 16/8/16.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSSDKProtocol.h"

@interface ZS_APPDelegate : UIResponder<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


/*
 
 以下两个方法在
 **
 *  @author wujunyang, 16-07-07 16:07:25
 *
 *  @brief  处理个推消息
 *
 *  @param notificationObject 传过来的属性
 *
 -(void)gtNotification:(NSObject *)notificationObject
 
 
 **
 *  @author wujunyang, 16-07-07 16:07:40
 *
 *  @brief  处理远程苹果通知
 *
 *  @param notificationObject 远程通知,目前个推有接口但是后台没有发送
 *  -(void)receiveRemoteNotification:(NSObject *)notificationObject
 
 */
@property(nonatomic,weak)id<ZS_SDKDelegate> delegate;

@property(nonatomic,weak)id<ZS_GTDatasoure> datasource;
@end


