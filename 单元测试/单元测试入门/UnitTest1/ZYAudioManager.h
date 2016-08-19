//
//  ZYAudioManager.h
//  UnitTest1
//
//  作者:香蕉  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ZYAudioManager : NSObject


+ (instancetype)defaultManager;

//播放音乐
- (AVAudioPlayer *)playingMusic:(NSString *)filename;
- (void)pauseMusic:(NSString *)filename;
- (void)stopMusic:(NSString *)filename;

//播放音效
- (void)playSound:(NSString *)filename;
- (void)disposeSound:(NSString *)filename;



@end
