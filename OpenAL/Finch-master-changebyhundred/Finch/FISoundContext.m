//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微博:http://weibo.com/u/6013257513?is_all=1
//  QQ技术讨论交流群 : 365204530
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "FISoundContext.h"
#import "FISoundDevice.h"
#import "FIError.h"

@implementation FISoundContext

#pragma mark Initialization

- (id) initWithDevice: (FISoundDevice*) device error: (NSError**) error
{
    self = [super init];

    if (!device) {
        return nil;
    }

    alClearError();
    _device = device;
    _handle = alcCreateContext([device handle], 0);
    FI_INIT_ERROR_IF_NULL(error);
    if (!_handle) {
        *error = [FIError errorWithMessage:@"Can’t create OpenAL context"
            code:FIErrorCannotCreateContext OpenALCode:alGetError()];
        return nil;
    }

    return self;
}

+ (id) contextForDevice: (FISoundDevice*) device error: (NSError**) error
{
    return [(FISoundContext*) [self alloc] initWithDevice:device error:error];
}

- (void) dealloc
{
    if (_handle) {
        if ([self isCurrent]) {
            [self setCurrent:NO];
        }
        alcDestroyContext(_handle);
        _handle = 0;
    }
}

#pragma mark Switching

- (BOOL) isCurrent
{
    return (alcGetCurrentContext() == _handle);
}

- (void) setCurrent: (BOOL) flag
{
    alcMakeContextCurrent(flag ? _handle : NULL);
}

#pragma mark Suspending

- (void) setSuspended: (BOOL) flag
{
    if (flag != _suspended) {
        if (flag) {
            alcSuspendContext(_handle);
            _suspended = YES;
        } else {
            alcProcessContext(_handle);
            _suspended = NO;
        }
    }
}

@end
