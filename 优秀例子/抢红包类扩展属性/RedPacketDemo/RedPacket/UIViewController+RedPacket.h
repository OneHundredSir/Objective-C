//
//  UIViewController+RedPacket.h
//  RedPacketDemo
//
//  Created by lll on 16/3/1.
//  Copyright © 2016年 llliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardInfo.h"

@interface UIViewController (RedPacket)
@property (nonatomic, strong) UIView     *windowUv;
@property (nonatomic, strong) RewardInfo *rewardInfoForRedPacket;

/**
 *  初始化并直接显示红包金额
 *
 *  @param rewardInfo 红包信息
 */
- (void)initRedPacketWindow:(RewardInfo*)rewardInfo;

/**
 *  初始化并显示红包 需要打开操作
 *
 *  @param rewardInfo 红包信息
 */
- (void)initRedPacketWindowNeedOpen:(RewardInfo*)rewardInfo;
@end
