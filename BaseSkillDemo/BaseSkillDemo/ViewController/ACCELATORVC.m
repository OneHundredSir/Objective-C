//
//  ACCELATORVC.m
//  BaseSkillDemo
//
//  Created by HUN on 16/8/27.
//  Copyright © 2016年 com.zeustel.zssdk. All rights reserved.
//

#import "ACCELATORVC.h"
#import <CoreMotion/CoreMotion.h>
@interface ACCELATORVC ()<UIAccelerometerDelegate>

//5.0以前的方法()不需要导入头文件
@property(nonatomic,strong)UIAccelerometer *accelerometer;



/** 运动管理者 需要导入头文件*/
@property (nonatomic, strong) CMMotionManager *mgr;
@end


@implementation ACCELATORVC
#pragma mark 加速度传感器
#pragma mark 5.0以前
#if 0
-(void)viewDidLoad
{
    //获得单例
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    //设置代理
    accelerometer.delegate = self;
    //设置采样频率
    accelerometer.updateInterval = 0.3;
}
#pragma mark - 代理方法
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    //x方向加速度
    UIAccelerationValue x = acceleration.x;
    //y方向加速度
    UIAccelerationValue y = acceleration.y;
    //z方向加速度
    UIAccelerationValue z = acceleration.z;
    NSLog(@"x:%f y:%f z:%f",x,y,z);
}
#endif


#pragma mark 5.0以后

- (CMMotionManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CMMotionManager alloc]init];
    }
    return _mgr;
}


#if 0
//push采样
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建运动管理者
    //判断加速计是否可用
    if (!self.mgr.isAccelerometerAvailable) {
        NSLog(@"加速计不可用");
        return;
    }
    //设置采样间隔
    self.mgr.accelerometerUpdateInterval = 0.3;
    //push采样
    [self.mgr startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        //当采样到加速计信息就会执行这个block
        if (error) {
            NSLog(@"采样出错");
            return ;
        }
        CMAcceleration acceleration = accelerometerData.acceleration;
        NSLog(@"x:%f y:%f z:%f",acceleration.x,acceleration.y,acceleration.z);
    }];
}

#else
//pull采样
- (void)viewDidLoad {
    [super viewDidLoad];
    //判断加速计是否可用
    if (!self.mgr.isAccelerometerAvailable) {
        NSLog(@"加速计不可用");
        return;
    }
    //开始采样
    [self.mgr startAccelerometerUpdates];
    //获取采样数据
    CMAcceleration acceleration = self.mgr.accelerometerData.acceleration;
    NSLog(@"x:%f y:%f z:%f",acceleration.x,acceleration.y,acceleration.z);
}

#endif


@end
