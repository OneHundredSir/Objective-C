//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微博:http://weibo.com/u/6013257513?is_all=1
//  QQ技术讨论交流群 : 365204530
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "Controller.h"
#import "FISound.h"
#import "FISoundEngine.h"
@implementation Controller

- (IBAction) playSound
{
    [_sound play];
}

- (IBAction) stopSound
{
    [_sound stop];
}

- (IBAction)New:(id)sender {
    
    [self setSound:[[FISoundEngine sharedEngine] soundNamed:@"finch.wav" maxPolyphony:4 error:NULL]];
    [_sound play];
    
}


- (IBAction) updateSoundPitchFrom: (UISlider*) slider
{
    NSLog(@"Setting pitch to %0.2f.", [slider value]);
    [_sound setPitch:[slider value]];
}



@end
