//
//  RedView.m
//  ReactiveCocoa
//
//  Created by yz on 15/9/25.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "RedView.h"

@implementation RedView
+ (instancetype)redView
{
    return [[NSBundle mainBundle] loadNibNamed:@"RedView" owner:nil options:nil][0];
}
- (IBAction)btnClick:(id)sender {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
