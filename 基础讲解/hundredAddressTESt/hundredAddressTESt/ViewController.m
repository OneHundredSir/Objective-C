//
//  ViewController.m
//  hundredAddressTESt
//
//  Created by ZEUS on 16/9/18.
//  Copyright © 2016年 ZEUS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

static long long passAdress = NULL;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){0,0,80,44}];
    [btn setTitle:@"你好" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    passAdress = btn;
    NSLog(@"原来地址%p,%llx",btn,passAdress);

}

#define randColor arc4random_uniform(255)/255.0
- (IBAction)changeBtn:(id)sender
{
    UIButton *btn = (UIButton *)passAdress;
//    NSObject *p = passAdress;
    btn.backgroundColor = [UIColor colorWithRed:randColor green:randColor blue:randColor alpha:1];
    
    
    
}


@end
