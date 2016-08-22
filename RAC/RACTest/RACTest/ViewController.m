//
//  ViewController.m
//  RACTest
//
//  Created by HUN on 16/8/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RedView.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameFeild;
@property(nonatomic,strong)Model *myModel;


@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property(nonatomic,weak)RedView *myRedV;
@property (nonatomic, assign) int age;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //实例化
    RedView *redV = [RedView redView];
    //中心
    redV.center = self.view.center;
    //UI添加视图
    [self.view addSubview:redV];
    _myRedV = redV;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMyAction:)];
    [self.view addGestureRecognizer:pan];
    
    // 1.代替代理
    // 需求：自定义redView,监听红色view中按钮点击
    // 之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
    // 这里表示只要redV调用btnClick:,就会发出信号，订阅就好了。
    [[redV rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"点击红色按钮");
    }];
    
    // 2.KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
    [[redV rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];

    // 3.监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮被点击了");
        
    }];
    
    // 4.代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        
        NSLog(@"键盘弹出");
        
    }];
    
    // 5.监听文本框的文字改变
    [_textField.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"文字改变了%@",x);
        
    }];
    
    
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        
        return nil;
        
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
    
}
// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.age = self.age + 1;
}

-(void)panMyAction:(UIGestureRecognizer *)gesture
{
    CGPoint pointCenter = [gesture locationInView:self.view];
    _myRedV.center = pointCenter;
}

#if 0
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    __weak typeof(self) weakSelf = self;
    //绑定RAC
    RAC(_myModel,userName) = [_userNameFeild rac_textSignal];
    
    RAC(_userNameFeild,backgroundColor) = [_userNameFeild.rac_textSignal map:^id(id value) {
        return weakSelf.myModel.isUserNameValid?[UIColor whiteColor]:[UIColor redColor];
    }];

    [_userNameFeild.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text isEqualToString:@"asdfgh"]) {
        _myModel.isUserNameValid = YES;
        

    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"--->");
    
}


/*
 //将ViewModel中的属性和控件中的属性绑定到一起
 RAC(_userViewModel,userName) = [_userNameFeild rac_textSignal];
 RAC(_userNameFeild,backgroundColor) = [_userNameFeild.rac_textSignal
 map:^id(NSString *password) {
 return weakSelf.userViewModel.isUserNameValid ? [UIColor whiteColor] : [UIColor redColor];
 }];
 
 */
#endif
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
