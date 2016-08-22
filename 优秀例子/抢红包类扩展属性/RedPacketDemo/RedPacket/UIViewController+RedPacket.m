//
//  UIViewController+RedPacket.m
//  RedPacketDemo
//
//  Created by lll on 16/3/1.
//  Copyright © 2016年 llliu. All rights reserved.
//

#import "UIViewController+RedPacket.h"
#import <objc/runtime.h>
#define RGBACOLOR(r,g,b,a)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
static const void *WindowUvKey = &WindowUvKey;
static const void *RewardInfoKey = &RewardInfoKey;
@implementation UIViewController (RedPacket)

@dynamic windowUv;
@dynamic rewardInfoForRedPacket;

- (UIView*)windowUv {
    return objc_getAssociatedObject(self, WindowUvKey);
}

- (void)setWindowUv:(UIWindow *)windowUv {
    objc_setAssociatedObject(self, WindowUvKey, windowUv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RewardInfo*)rewardInfoForRedPacket {
    return objc_getAssociatedObject(self, RewardInfoKey);
}

- (void)setRewardInfoForRedPacket:(RewardInfo *)rewardInfoForRedPacket {
    objc_setAssociatedObject(self, RewardInfoKey,rewardInfoForRedPacket,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma 
- (void)initRedPacketWindowNeedOpen:(RewardInfo*)rewardInfo{
    if (rewardInfo.rewardStatus == 3) {
        NSLog(@"红包已领完");
        //TODO 自定义提示方式
        return;
    }
    if (rewardInfo.rewardStatus == 1 || rewardInfo.rewardStatus == 2) {
        return;
    }
    CGFloat ratio = CGRectGetWidth(self.view.frame)/320;
    self.rewardInfoForRedPacket = rewardInfo;
    self.windowUv = [[UIView alloc] initWithFrame:self.view.frame];
    [self.windowUv setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    UIImageView* backGround = [[UIImageView alloc]initWithFrame:CGRectMake(20 * ratio , 80 * ratio, 280 * ratio, 400 * ratio)];
    backGround.image        = [UIImage imageNamed:@"img_reward_packet_open"];
    backGround.tag          = 10;
    [self.windowUv addSubview:backGround];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(110 * ratio, 150 * ratio, 110 * ratio, 20 * ratio)];
    label.font          = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor     = RGBACOLOR( 219 , 29 , 56 , 1);
    label.text          = @"恭喜获得";
    label.tag           = 11;

    [self.windowUv addSubview:label];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(110 * ratio, 175 * ratio, 110 * ratio, 20 * ratio)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor     = RGBACOLOR( 219 , 29 , 56 , 1);
    label.text          = [NSString stringWithFormat:@"%.2f元红包",self.rewardInfoForRedPacket.money];
    label.tag           = 12;
    [self.windowUv addSubview:label];
    
    label               = [[UILabel alloc]initWithFrame:CGRectMake(80 * ratio, 275 * ratio, 170 * ratio, 70 * ratio)];
    label.font          = [UIFont systemFontOfSize:17];
    label.textColor     = RGBACOLOR( 252 , 240 , 107 , 1);
    label.text          = self.rewardInfoForRedPacket.rewardContent;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 3;
    label.tag           = 14;
    [self.windowUv addSubview:label];
    
    UIButton* cancel = [[UIButton alloc] initWithFrame:CGRectMake(260 * ratio, 110 * ratio, 40 * ratio, 40 * ratio)];
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonClicked:)];
    [cancel addGestureRecognizer:tapGesture];
    [self.windowUv addSubview:cancel];
    
    UIButton* next = [[UIButton alloc] initWithFrame:CGRectMake(75 * ratio, 360 * ratio, 180 * ratio, 30 * ratio)];
    [next setBackgroundColor:RGBACOLOR( 252 , 240 , 107 , 1)];
    [next.layer setCornerRadius:next.frame.size.height/8];
    [next.layer setMasksToBounds:YES];
    NSString* title = @"已领取过红包";
    if (self.rewardInfoForRedPacket.rewardStatus == 1) {
        next.enabled = NO;
    } else {
        title = @"立即分享";
    }
    [next setTitle:title forState:UIControlStateNormal];

    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareButtonPress:)];
    [next setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    next.tag = 13;
    [next addGestureRecognizer:tapGesture];
    
    [self.windowUv addSubview:next];
    [self.view.window addSubview:self.windowUv];
}


- (void)initRedPacketWindow:(RewardInfo*)rewardInfo {
    if (rewardInfo.rewardStatus == 3) {
        NSLog(@"红包已领完");
        //TODO 自定义提示方式
        return;
    }
    if (rewardInfo.rewardStatus == 1 || rewardInfo.rewardStatus == 2) {
        return;
    }
    CGFloat ratio = CGRectGetWidth(self.view.frame)/320;
    self.rewardInfoForRedPacket = rewardInfo;
    self.windowUv = [[UIView alloc] initWithFrame:self.view.frame];
    [self.windowUv setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    UIImageView* backGround = [[UIImageView alloc]initWithFrame:CGRectMake(20 * ratio , 80 * ratio, 280 * ratio, 400 * ratio)];
    backGround.image        = [UIImage imageNamed:@"img_reward_packet_closed"];
    backGround.tag          = 10;
    [self.windowUv addSubview:backGround];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(110 * ratio, 150 * ratio, 110 * ratio, 20 * ratio)];
    label.font          = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor     = RGBACOLOR( 219 , 29 , 56 , 1);
    label.text          = @"恭喜获得";
    label.tag           = 11;
    label.hidden        = YES;
    [self.windowUv addSubview:label];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(110 * ratio, 175 * ratio, 110 * ratio, 20 * ratio)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor     = RGBACOLOR( 219 , 29 , 56 , 1);
    label.text          = [NSString stringWithFormat:@"%.2f元红包",self.rewardInfoForRedPacket.money];
    label.tag           = 12;
    label.hidden        = YES;
    [self.windowUv addSubview:label];
    
    label               = [[UILabel alloc]initWithFrame:CGRectMake(80 * ratio, 275 * ratio, 170 * ratio, 70 * ratio)];
    label.font          = [UIFont systemFontOfSize:17];
    label.textColor     = RGBACOLOR( 252 , 240 , 107 , 1);
    label.text          = self.rewardInfoForRedPacket.rewardName;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 3;
    label.tag           = 14;
    [self.windowUv addSubview:label];
    
    UIButton* cancel = [[UIButton alloc] initWithFrame:CGRectMake(260 * ratio, 110 * ratio, 40 * ratio, 40 * ratio)];
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonClicked:)];
    [cancel addGestureRecognizer:tapGesture];
    [self.windowUv addSubview:cancel];
    
    UIButton* next = [[UIButton alloc] initWithFrame:CGRectMake(75 * ratio, 360 * ratio, 180 * ratio, 30 * ratio)];
    [next setBackgroundColor:RGBACOLOR( 252 , 240 , 107 , 1)];
    [next.layer setCornerRadius:next.frame.size.height/8];
    [next.layer setMasksToBounds:YES];
    [next setTitle:@"打开红包" forState:UIControlStateNormal];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextButtonClicked:)];
    [next setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    next.tag = 13;
    [next addGestureRecognizer:tapGesture];
    
    [self.windowUv addSubview:next];
    [self.view.window addSubview:self.windowUv];
}

- (void)nextButtonClicked:(id)sender {
    
    UIImageView* background = [self.windowUv viewWithTag:10];
    background.image        = [UIImage imageNamed:@"img_reward_packet_open"];
    UILabel* lable          = [self.windowUv viewWithTag:11];
    lable.hidden            = NO;
    lable                   = [self.windowUv viewWithTag:12];
    lable.hidden            = NO;
    UIButton* button        = [self.windowUv viewWithTag:13];
    NSString* title = @"已领取过红包";
    if (self.rewardInfoForRedPacket.rewardStatus == 1) {
        button.enabled = NO;
    } else {
        title = @"立即分享";
    }
    button.titleLabel.text = title;
    [button setTitle:title forState:UIControlStateNormal];
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareButtonPress:)];
    [button addGestureRecognizer:tapGesture];
    
    lable        = [self.windowUv viewWithTag:14];
    lable.hidden = NO;
    lable.text   = self.rewardInfoForRedPacket.rewardContent;
}

- (void)shareButtonPress:(id)sender {
    UIButton* button = sender;
    button.enabled   = NO;
    //TODO 自定义分享方式
}

- (void)cancelButtonClicked:(id)sender {
    self.windowUv.hidden = YES;
    self.windowUv        = nil;
}
@end
