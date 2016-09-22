//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微博:http://weibo.com/u/6013257513?is_all=1
//  QQ技术讨论交流群 : 365204530
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "FITestCase.h"
#import "FISoundContext.h"
#import "FISoundDevice.h"

@implementation FITestCase

- (void) setUp
{
    [super setUp];
    _soundBundle = [NSBundle bundleForClass:[self class]];
    _soundContext = [FISoundContext contextForDevice:[FISoundDevice defaultSoundDevice] error:NULL];
    [_soundContext setCurrent:YES];
}

- (void) tearDown
{
    _soundBundle = nil;
    _soundContext = nil;
    [super tearDown];
}

@end
