//
//  ViewController.m
//  RACTestDemo
//
//  Created by justinjing on 15/1/9.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RWDummySignInService.h"

@interface ViewController ()

@property (strong, nonatomic)  UITextField *usernameTextField;
@property (strong, nonatomic)  UITextField *passwordTextField;
@property (strong, nonatomic)  UIButton *signInButton;
@property (strong, nonatomic)  UILabel *signInFailureText;
@property (strong, nonatomic)  UILabel *timeLabel;

@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.signInService = [RWDummySignInService new];
    // Do any additional setup after loading the view, typically from a nib.
     _usernameTextField= [[UITextField alloc]initWithFrame:CGRectMake(45, 100, 230, 30)];
    _usernameTextField.placeholder=@"淘宝账户/手机号码";
    [_usernameTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_usernameTextField];
    
     _passwordTextField= [[UITextField alloc]initWithFrame:CGRectMake(45,CGRectGetMaxY(_usernameTextField.frame)+20, 230, 30)];
    _passwordTextField.placeholder=@"密码";
    [_passwordTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_passwordTextField];
    

    _signInFailureText=[[UILabel alloc]initWithFrame:CGRectMake(45, CGRectGetMaxY(_passwordTextField.frame)+20, 100, 30)];
    _signInFailureText.text=@"验证失败";
    _signInFailureText.hidden = YES;
    [self.view addSubview:_signInFailureText];
    
    
    _signInButton= [UIButton buttonWithType:UIButtonTypeSystem];
    _signInButton.titleLabel.font = [UIFont systemFontOfSize: 22.0];
    [_signInButton setTitle:@"登录" forState:UIControlStateNormal];
    [_signInButton setTitle:@"登录" forState:UIControlStateHighlighted];
    
    _signInButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-100,CGRectGetMaxY(_passwordTextField.frame)+20, 80, 40);
    [self.view addSubview:_signInButton];
    
//    时钟label
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(45, CGRectGetMaxY(_signInButton.frame)+80, 100, 30)];
    [self.view addSubview:_timeLabel];
    
    RACSignal *validUsernameSignal = [self.usernameTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];
    
    [[self.usernameTextField.rac_textSignal
      filter:^BOOL(id value) {
          NSString *text = value;
          _signInFailureText.hidden = YES;
          return text.length > 3;
      }]
     subscribeNext:^(id x) {
         NSLog(@"%@", x);
     }];
    
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];
 

    __block unsigned subscriptions = 0;
    
    RACSignal *loggingSignal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        subscriptions++;
        [subscriber sendCompleted];
        [subscriber sendNext:self];
        return nil;
    }];
    
    // 不会输出任何东西
    loggingSignal = [loggingSignal doCompleted:^{
        NSLog(@"about to complete subscription %u", subscriptions);
    }];
    loggingSignal = [loggingSignal doError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    loggingSignal = [loggingSignal doNext:^(id x) {
        
        NSLog(@"asdfas ");
    }];
    // 输出:
    // about to complete subscription 1
    // subscription 1
    [loggingSignal subscribeCompleted:^{
        NSLog(@"subscription %u", subscriptions);
    }];

    [loggingSignal subscribeNext:^(NSNumber* subscriptions) {
        NSLog(@"asdf===%@",subscriptions);
    }];
    
    
    RAC(self.usernameTextField,backgroundColor) = [validUsernameSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    RAC(self.passwordTextField,backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];

    
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validPasswordSignal,validUsernameSignal]
                                     reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
                                          return @([usernameValid boolValue] && [passwordValid boolValue]);
                                     }];
    
    [signUpActiveSignal  subscribeNext:^(NSNumber *signupActive) {
        self.signInButton.enabled = [signupActive boolValue];
    }];
    
   [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x) {
           self.signInButton.enabled = NO;
           self.signInFailureText.hidden = YES;
       }]
    flattenMap:^id(id x) {
        return [self signInSignal];
    }]
    
    subscribeNext:^(NSNumber *signedIn) {
        self.signInButton.enabled = YES;
        BOOL success = [signedIn boolValue];
        self.signInFailureText.hidden = success;
        if (success) {
            [self performSegueWithIdentifier:@"signinsuccess" sender:self];
        }
    }];
    
    
    //史上最简单的时钟显示方法。
    RAC(self, timeLabel.text) = [[[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] startWith:[NSDate date]] map:^id (NSDate *value) {
        NSLog(@"value:%@", value);
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit |
                                            NSMinuteCalendarUnit |
                                            NSSecondCalendarUnit fromDate:value];
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
    }];
    
    RACSequence *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
    
    // Contains: AA BB CC DD EE FF GG HH II
    RACSequence *mapped = [letters map:^(NSString *value) {
    
        return [value stringByAppendingString:value];
    }];


}
- (BOOL)isValidUsername:(NSString *)username {
  
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.signInService
         signInWithUsername:self.usernameTextField.text
         password:self.passwordTextField.text
         complete:^(BOOL success) {
             [subscriber sendNext:@(success)];
             [subscriber sendCompleted];
         }];
        return nil;
    }];
}

@end
