//
//  GetMAC.m
//  webtest
//
//  作者:香蕉  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "GetMAC.h"
#import "UUID.h"

@interface GetMAC ()
@property(nonatomic,readonly,retain) NSString *uniqueIdentifier __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_2_0,__IPHONE_5_0);
@end

@implementation GetMAC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

- (IBAction)getUUID:(id)sender
{
    //-----5.0获取方法-----//
//    [UIDevice currentDevice] uniqueIdentifier];
    
    //什么鬼，这个一直在改变..一直重启就会改变...
    [self uuid];
    NSLog(@"\nMAC UUID:%@",[self uuid]);
}

//这个方法生成的UUID一直都会改变，注意，最好不要用
-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

//这个方法绑定keychain的方法就是可以重装APP，这样可以做到最强的防御.
- (IBAction)getMAc:(id)sender
{
    NSString * uuid= [UUID getUUID];
    NSLog(@"\nMAC:%@",uuid);
}




- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

@end