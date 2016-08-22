//
//  ViewController.m
//  RedPacketDemo
//
//  Created by lll on 16/3/1.
//  Copyright © 2016年 llliu. All rights reserved.
//

#import "ViewController.h"
#import "RewardInfo.h"
#import "UIViewController+RedPacket.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)btnGetRedPacket:(id)sender {
    RewardInfo *info = [[RewardInfo alloc] init];
    info.money = 100.0;
    info.rewardName = @"示例红包";
    info.rewardContent = @"恭喜你得到红包~";
    info.rewardStatus = 0;
    
    //[self initRedPacketWindowNeedOpen:info];
    
    [self initRedPacketWindow:info];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
