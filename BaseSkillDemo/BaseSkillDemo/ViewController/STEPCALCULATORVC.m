//
//  STEPCALCULATORVC.m
//  BaseSkillDemo
//
//  Created by HUN on 16/8/27.
//  Copyright © 2016年 com.zeustel.zssdk. All rights reserved.
//

#import "STEPCALCULATORVC.h"
#import <CoreMotion/CoreMotion.h>

@interface STEPCALCULATORVC ()
@property (strong, nonatomic) UILabel *stepLabel;
/** counter 这是8.0以前*/
@property (nonatomic, strong) CMStepCounter *counter;
/** pedometer 8.0以后*/
@property (nonatomic, strong) CMPedometer *pedometer;
@end
@implementation STEPCALCULATORVC



-(void)_initIcon
{
    CGFloat LBwidth = 80;
    CGFloat LBheight = LBwidth *0.6;
    
    _stepLabel = [[UILabel alloc]initWithFrame:(CGRect){0,0,LBwidth,LBheight}];
    _stepLabel.backgroundColor = [UIColor yellowColor];
    _stepLabel.text=@"暂无数据";
    _stepLabel.textColor = [UIColor blackColor];
    _stepLabel.center = self.view.center;
    [self.view addSubview:_stepLabel];
    
    
}
#pragma mark 计步器
- (CMStepCounter *)counter
{
    if (!_counter) {
        _counter = [[CMStepCounter alloc]init];
    }
    return _counter;
}


#if 0
//8.0以前
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initIcon];
    //判断计步器是否可用
    if (![CMStepCounter isStepCountingAvailable]) return;
    //开始计步 第二个参数的意思是 每走5步就回调一次,但是回调的时候可能用户继续在走,所以返回的步数不一定是5的倍数
    [self.counter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue] updateOn:5 withHandler:^(NSInteger numberOfSteps, NSDate * _Nonnull timestamp, NSError * _Nullable error) {
        if (error) {
            NSLog(@"统计出错了");
            return ;
        }
        self.stepLabel.text = [NSString stringWithFormat:@"走了%ld步",numberOfSteps];
        //如果不是在主线程中 就不能向上面那样直接赋值
        //        self.stepLabel performSelector:<#(nonnull SEL)#> onThread:<#(nonnull NSThread *)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#>
    }];
}



#endif


//8.0以后
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initIcon];
    //判断计步器是否可用
    if (![CMPedometer isStepCountingAvailable]) {
        NSLog(@"计步器不可用");
        return;
    }
    //开始计步
    [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        if (error) {
            NSLog(@"出错了");
            return ;
        }
        self.stepLabel.text = pedometerData.numberOfSteps.stringValue;
    }];
}






@end
