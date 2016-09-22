//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微博:http://weibo.com/u/6013257513?is_all=1
//  QQ技术讨论交流群 : 365204530
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "FISoundDevice.h"

@implementation FISoundDevice

#pragma mark Initialization

- (id) initWithName: (NSString*) deviceName
{
    self = [super init];
    _handle = alcOpenDevice([deviceName cStringUsingEncoding:NSUTF8StringEncoding]);
    return (_handle ? self : nil);
}

- (void) dealloc
{
    if (_handle) {
        alcCloseDevice(_handle);
        _handle = 0;
    }
}

#pragma mark Convenience Initializers

+ (id) deviceNamed: (NSString*) deviceName
{
    return [[self alloc] initWithName:deviceName];
}

// TODO: We should cache the device instances using the device name,
// but at the same time we should make it possible for the device to
// get deallocated. The current implementation keeps the default device
// alive forever.
+ (id) defaultSoundDevice
{
    static dispatch_once_t once;
    static FISoundDevice *defaultDevice = nil;
    dispatch_once(&once, ^{
        defaultDevice = [self deviceNamed:nil];
    });
    return defaultDevice;
}

@end
