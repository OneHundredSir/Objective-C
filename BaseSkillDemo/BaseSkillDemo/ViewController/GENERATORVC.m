//
//  GENERATORVC.m
//  BaseSkillDemo
//
//  Created by HUN on 16/8/27.
//  Copyright © 2016年 com.zeustel.zssdk. All rights reserved.
//

#import "GENERATORVC.h"
#import <CoreImage/CoreImage.h>

@interface GENERATORVC ()
@property(nonatomic,strong)UIImageView *imageView;
@end
@implementation GENERATORVC


-(void)viewDidLoad
{
    [self _initIcon];
    //创建过滤器 QuickResponse Code 二维码  Generator生成
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复默认设置
    [filter setDefaults];
    //给过滤器添加数据
    NSString *inputString = @"http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles";
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    //输出图片
    CIImage *outputImage = [filter outputImage];
    self.imageView.image = [UIImage imageWithCIImage:outputImage];
}


-(void)_initIcon
{
    CGFloat LBwidth = 80;
    CGFloat LBheight = LBwidth ;
    
    _imageView = [[UIImageView alloc]initWithFrame:(CGRect){0,0,LBwidth,LBheight}];
    _imageView.backgroundColor = [UIColor yellowColor];
    _imageView.center = self.view.center;
    [self.view addSubview:_imageView];
    
    
}


@end
