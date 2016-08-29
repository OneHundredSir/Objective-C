//
//  SCANVC.m
//  BaseSkillDemo
//
//  Created by HUN on 16/8/27.
//  Copyright © 2016年 com.zeustel.zssdk. All rights reserved.
//

#import "SCANVC.h"
#import <AVFoundation/AVFoundation.h>


@interface SCANVC () <AVCaptureMetadataOutputObjectsDelegate>
/** session*/
@property (nonatomic, weak) AVCaptureSession *session;
/** layer*/
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *layer;

@end
@implementation SCANVC


-(void)viewDidLoad
{
    //创建捕捉会话
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    //添加输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:deviceInput];
    //添加输出数据
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [session addOutput:output];
    //设置元数据类型
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    //设置代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //添加预览图层
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.frame = CGRectMake(100, 100, 100, 100);
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    //开始扫描
    [session startRunning];
}


#pragma mark - 实现output的代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count) {
        //获取扫描结果
        AVMetadataMachineReadableCodeObject *last = metadataObjects.lastObject;
        NSLog(@"%@",last.stringValue);
        //停止扫描
        [self.session stopRunning];
        //移除图层
        [self.layer removeFromSuperlayer];
    }else{
        NSLog(@"未扫描到内容");
    }
}

//针对检测到的内容,可以做进一步的处理.比如检测到http开头的,直接用一个webview来加载对应的网址

@end
