//
//  DISTANCEVC.m
//  BaseSkillDemo
//
//  Created by HUN on 16/8/27.
//  Copyright © 2016年 com.zeustel.zssdk. All rights reserved.
//

#import "DISTANCEVC.h"

@implementation DISTANCEVC
//物体传感器
-(void)viewDidLoad
{
    //开启距离传感器
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    //添加通知监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(proximityStateDidChanged) name:UIDeviceProximityStateDidChangeNotification object:nil];
}

-(void)proximityStateDidChanged
{
    if ([[UIDevice currentDevice] proximityState]) {
        NSLog(@"有物体靠近");
    }else {
        NSLog(@"物体远离");
    }
}



@end
