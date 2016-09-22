//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微博:http://weibo.com/u/6013257513?is_all=1
//  QQ技术讨论交流群 : 365204530
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize window;

- (UIWindow*) buildMainWindow
{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    UIWindow *win = [[UIWindow alloc] initWithFrame:screenFrame];
    [win setBackgroundColor:[UIColor whiteColor]];

    UILabel *label = [[UILabel alloc] init];
    [label setText:@"Running Tests…"];
    [label sizeToFit];

    [win addSubview:label];
    [label setCenter:CGPointMake(screenFrame.size.width/2, 100)];

    return win;
}

- (BOOL) application: (UIApplication*) application didFinishLaunchingWithOptions: (NSDictionary*) launchOptions
{
    [self setWindow:[self buildMainWindow]];
    [window makeKeyAndVisible];
    return YES;
}

@end
