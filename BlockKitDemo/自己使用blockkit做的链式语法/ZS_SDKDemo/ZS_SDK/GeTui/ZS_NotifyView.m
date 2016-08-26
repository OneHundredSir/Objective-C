//
//  ZS_NotifyView.m
//  GtSdkDemo
//
//  Created by HUN on 16/8/15.
//  Copyright © 2016年 赵伟. All rights reserved.
//

#import "ZS_NotifyView.h"

@interface ZS_NotifyView ()

@property(nonatomic,strong)UIImageView *tipImgV;

@property(nonatomic,strong)UILabel *tipTitleLB;

@property(nonatomic,strong)UILabel *tipDetailLB;

@end
@implementation ZS_NotifyView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame] ) {
        CGFloat totalW = frame.size.width;
        CGFloat totalH = frame.size.height;
        
        CGFloat imgH = totalH;
        CGFloat imgW = imgH;
        UIImageView *tipImg = [[UIImageView alloc]initWithFrame:(CGRect){0,0,imgW,imgH}];
        [self addSubview:tipImg];
        self.tipImgV = tipImg;
//        tipImg.backgroundColor = [UIColor whiteColor];
        
        CGFloat titleH = totalH*0.3;
        CGFloat titleW = totalW - imgW;
        UILabel *titleLB = [[UILabel alloc]initWithFrame:(CGRect){imgW,0,titleW,titleH}];
        titleLB.text = @"目前没有传入title值";
        titleLB.textAlignment = NSTextAlignmentCenter;
        
        titleLB.textColor = [UIColor blackColor];
        titleLB.font = [UIFont systemFontOfSize:12];
        [self addSubview:titleLB];
        self.tipTitleLB = titleLB;
//        titleLB.backgroundColor = [UIColor orangeColor];
        
        
        CGFloat detailH = totalH - titleH;
        CGFloat detailW = titleW;
        UILabel *detailLB = [[UILabel alloc]initWithFrame:(CGRect){imgW,titleH,detailW,detailH}];
        detailLB.textColor = [UIColor blackColor];
        detailLB.numberOfLines = 0;
        detailLB.text = @"目前没有传入detail值";
        detailLB.textAlignment = NSTextAlignmentCenter;
        detailLB.font = [UIFont systemFontOfSize:10];
        [self addSubview:detailLB];
        self.tipDetailLB = detailLB;
//        detailLB.backgroundColor = [UIColor yellowColor];

    }
    self.backgroundColor = [UIColor redColor];
    return self;
}



#pragma mark set大法
-(void)setImgUrlStr:(NSString *)imgUrlStr
{
    UIImage *img = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]]];
    self.tipImgV.image = img;
}


-(void)setTitleStr:(NSString *)titleStr
{
    self.tipTitleLB.text = titleStr;
}


-(void)setDetailStr:(NSString *)detailStr
{
    self.tipDetailLB.text = detailStr;
}


@end
