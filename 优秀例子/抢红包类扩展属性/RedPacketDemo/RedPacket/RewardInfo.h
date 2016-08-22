//
//  RewardInfo.h
//  RedPacketDemo
//
//  Created by lll on 16/3/1.
//  Copyright © 2016年 llliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardInfo : NSObject
@property (nonatomic, assign) float     money;          //金额
@property (nonatomic, assign) NSInteger rewardStatus;   //红包状态  0.未领取 1.已领取 2.已过期 3.红包已领完
@property (nonatomic, copy  ) NSString  *rewardContent; //红包打开后提示内容
@property (nonatomic, copy  ) NSString  *rewardName;       //红包名称

@end
