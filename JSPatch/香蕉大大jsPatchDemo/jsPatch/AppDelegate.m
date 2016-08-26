//
//  AppDelegate.m
//  JSpatchDemo
//
//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "AppDelegate.h"
#import <JSPatch/JSPatch.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

static NSString *JSPatchKey = @"20e5c016a6b9f7bc";
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //JSPatchKey是创建App获得的AppKey
//    [JSPatch startWithAppKey:JSPatchKey];
        [JSPatch testScriptInBundle];
#ifdef DEBUG
    [JSPatch setupDevelopment];
#endif
    [JSPatch sync];
    return YES;
}


@end
