//
//  MOTORVC.m
//  BaseSkillDemo
//
//  Created by HUN on 16/8/27.
//  Copyright © 2016年 com.zeustel.zssdk. All rights reserved.
//

#import "MOTORVC.h"
//必须导入
#import <CoreMotion/CoreMotion.h>


@interface MOTORVC ()
/** 运动管理者*/
@property (nonatomic, strong) CMMotionManager *mgr;
@end
@implementation MOTORVC

#pragma mark 陀螺仪
#if 0
//push采样
- (CMMotionManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CMMotionManager alloc]init];
    }
    return _mgr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //判断陀螺仪是否可用
    if (!self.mgr.isGyroAvailable) {
        NSLog(@"手机太旧啦");
        return;
    }
    //设置采样间隔
    self.mgr.gyroUpdateInterval = 0.3;
    //开始采样
    [self.mgr startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        if (error) {
            NSLog(@"采样发生错误");
            return;
        }
        CMRotationRate rotationRate = gyroData.rotationRate;
        NSLog(@"x:%f y:%f z:%f",rotationRate.x,rotationRate.y,rotationRate.z);
    }];
}
#else
//pull采样
- (CMMotionManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CMMotionManager alloc]init];
    }
    return _mgr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //判断陀螺仪是否可用
    if (!self.mgr.isGyroAvailable) {
        NSLog(@"手机太旧啦");
        return;
    }
    //开始采样
    [self.mgr startGyroUpdates];
    //获取采样数据
    CMGyroData *gyroData = self.mgr.gyroData;
    CMRotationRate rotationRate = gyroData.rotationRate;
    NSLog(@"x:%f y:%f z:%f",rotationRate.x,rotationRate.y,rotationRate.z);
}

#endif

@end
