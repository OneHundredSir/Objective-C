//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微博:http://weibo.com/u/6013257513?is_all=1
//  QQ技术讨论交流群 : 365204530
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "FISoundEngine.h"
#import "FISoundContext.h"
#import "FISoundDevice.h"

@interface FISoundEngine ()
@property(strong) FISoundDevice *soundDevice;
@property(strong) FISoundContext *soundContext;
@end

@implementation FISoundEngine

#pragma mark Initialization

- (id) init
{
    self = [super init];

    _soundDevice = [FISoundDevice defaultSoundDevice];
    _soundContext = [FISoundContext contextForDevice:_soundDevice error:NULL];
    if (!_soundContext) {
        return nil;
    }

    [self setSoundBundle:[NSBundle bundleForClass:[self class]]];
    [_soundContext setCurrent:YES];

    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (id) sharedEngine
{
#if 1
    static dispatch_once_t once;
    static FISoundEngine *sharedEngine = nil;
    dispatch_once(&once, ^{
        sharedEngine = [[self alloc] init];
    });
#else
    static FISoundEngine *sharedEngine = nil;
    sharedEngine = [[self alloc] init];
#endif
    return sharedEngine;
}

#pragma mark Sound Loading

- (FISound*) soundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices error: (NSError**) error
{
    return [[FISound alloc]
        initWithPath:[_soundBundle pathForResource:soundName ofType:nil]
        maxPolyphony:voices error:error];
}

- (FISound*) soundNamed: (NSString*) soundName error: (NSError**) error
{
    return [self soundNamed:soundName maxPolyphony:1 error:error];
}

#pragma mark Interruption Handling

// TODO: Resume may fail here, and in that case
// we would like to keep _suspended at YES.
- (void) setSuspended: (BOOL) newValue
{
    if (newValue != _suspended) {
        _suspended = newValue;
        if (_suspended) {
            [_soundContext setCurrent:NO];
            [_soundContext setSuspended:YES];
        } else {
            [_soundContext setCurrent:YES];
            [_soundContext setSuspended:NO];
        }
    }
}

@end
