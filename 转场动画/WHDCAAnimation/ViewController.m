//
//  ViewController.m
//  CAAnimation
//
//  Created by HUN on 16/6/9.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "ViewController.h"
#import "DemoViewcontroller.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *myview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com/"]];
    [_webView loadRequest:request];
    
    UIButton *right=[[UIButton alloc]initWithFrame:(CGRect){0,0,50,50}];
    [right setTitle:@"翻页" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem=item;
    
    
    UIButton *left=[[UIButton alloc]initWithFrame:(CGRect){0,0,50,50}];
    [left setTitle:@"跳转" forState:UIControlStateNormal];
    [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(gotoOther) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem=item2;

}

#pragma mark 跳转到别的
-(void)gotoOther
{
    DemoViewcontroller *ve=[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"haha"];
    
    [self presentViewController:ve animated:YES completion:nil];
}

#pragma mark 跳转
-(void)show:(UIButton *)btn
{
    CATransition *animation=[CATransition animation];
    animation.duration=2;
    animation.type=@"rippleEffect";
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [_myview.layer addAnimation:animation forKey:@"animation"];
    if (_myview.alpha==1) {
        _myview.alpha=0;
    }else
        _myview.alpha=1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
