//
//  GETMACHINEVC.m
//  BaseSkillDemo
//
//  Created by HUN on 16/8/27.
//  Copyright © 2016年 com.zeustel.zssdk. All rights reserved.
//

#import "GETMACHINEVC.h"

@implementation GETMACHINEVC

#pragma mark 获取硬件
-(void)viewDidLoad
{
    //获取设备型号
    NSLog(@"设备型号:%@",[[UIDevice currentDevice] platformString]);
    
    //获取存储空间大小 字节
    NSNumber *freeDisk = [[UIDevice currentDevice] freeDiskSpace];
    CGFloat freeDiskF = freeDisk.floatValue;
    NSLog(@"未使用空间:%.2fG",((freeDiskF / 1024)/1024)/1024 );
    NSNumber *totalDisk = [[UIDevice currentDevice] totalDiskSpace];
    CGFloat totalDiskF = totalDisk.floatValue;
    NSLog(@"总的存储空间:%.2fG",((totalDiskF/1024)/1024)/1014);
//    NSLog(@"硬件信息:%@",[SSHardwareInfo systemDeviceTypeFormatted:YES])
}

@end
