//
//  ViewController.m
//  BaseSkillDemo
//
//  Created by HUN on 16/8/27.
//  Copyright © 2016年 com.zeustel.zssdk. All rights reserved.
//

#import "ViewController.h"



#define radColor arc4random_uniform(255)/255.0
typedef NS_ENUM(NSUInteger, BTNSTYLE) {
    BTN_STEPCALCULATOR = 0,//计步器
    BTN_MOTOR,//陀螺仪
    BTN_ACCELATOR,//加速器
    BTN_DISTANCE,//举例传感器
    BTN_GETMACHINE,//设备获取
    BTN_SCAN,//二维码扫描
    BTN_GENERATOR//二维码生成
};



@interface ViewController ()
@property(nonatomic,strong)NSArray *myVCName;
@property(nonatomic,strong)NSArray *vcName;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initIcon];
}

-(NSArray *)myVCName
{
    return @[@"STEPCALCULATORVC",
             @"MOTORVC",
             @"ACCELATORVC",
             @"DISTANCEVC",
             @"GETMACHINEVC",
             @"SCANVC",
             @"GENERATORVC",
             @"LINKLISTVC"];
}


-(NSArray *)vcName
{
    return @[@"1.计步器",
             @"2.陀螺仪",
             @"3.加速传感器",
             @"4.距离传感器",
             @"5.硬件信息获取",
             @"6.二维码扫描",
             @"7.二维码生成",
             @"8.打开通讯录"];
}
-(void)_initIcon
{
    CGFloat maginNavi = 64;
    CGFloat magin = 5;
    CGFloat BtnW = CGRectGetWidth(self.view.frame)*0.33;
    CGFloat BtnH = BtnW * 0.5;
    CGFloat BtnX = self.view.center.x - BtnW/2.0;
    for (int i = 0; i<self.vcName.count; i++)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){BtnX,maginNavi+magin+(magin+BtnH)*i,BtnW,BtnH}];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn setTitle:self.vcName[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:radColor green:radColor blue:radColor alpha:1.0];
        [self.view addSubview:btn];
    }
}


-(void)btnAction:(UIButton *)btn
{
    [self showVC:btn.tag];
}

-(void)showVC:(NSInteger)VCNum
{
    ViewController *vc = [[NSClassFromString(self.myVCName[VCNum]) alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = self.vcName[VCNum];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
