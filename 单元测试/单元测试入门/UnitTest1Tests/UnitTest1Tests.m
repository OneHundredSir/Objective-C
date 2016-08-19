//
//  UnitTest1Tests.m
//  UnitTest1Tests
//
//  作者:香蕉  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import <XCTest/XCTest.h>
#import "ZYAudioManager.h"
@interface UnitTest1Tests : XCTestCase


@property (nonatomic, strong) AVAudioPlayer *player;


@end
static NSString *_fileName = @"10405520.mp3";
@implementation UnitTest1Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    //初始化的代码，在测试方法调用之前调用
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    // 释放测试用例的资源代码，这个方法会每个测试用例执行后调用
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // 测试用例的例子，注意测试用例一定要test开头
    NSLog(@"开始爱上单元测试的第一个单元测试测试");
    NSString *test = @"这是我的第一个单元测试";
//    XCTFail(@"asdhjk");
//    XCTAssertTrue([test isEqualToString:@"初来乍到，就想测试成功，没门"]);
    NSLog(@"自定义测试testExample");
    int  a= 3;
//    XCTAssertTrue(a == 0,"a 不能等于 0");
    XCTFail(@"是啊比了");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    // 测试性能例子，有Instrument调试工具之后，其实这个没毛用。
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        // 需要测试性能的代码
    }];
}


#pragma mark 真正开始
/**
 *  测试是否为单例，要在并发条件下测试
 */
- (void)testAudioManagerSingle
{
    NSMutableArray *managers = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZYAudioManager *tempManager = [[ZYAudioManager alloc] init];
        [managers addObject:tempManager];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZYAudioManager *tempManager = [[ZYAudioManager alloc] init];
        [managers addObject:tempManager];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZYAudioManager *tempManager = [ZYAudioManager defaultManager];
        [managers addObject:tempManager];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZYAudioManager *tempManager = [ZYAudioManager defaultManager];
        [managers addObject:tempManager];
    });
    
    ZYAudioManager *managerOne = [ZYAudioManager defaultManager];
    //这里是判断数组中的对象是否一致!
    [managers enumerateObjectsUsingBlock:^(ZYAudioManager *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssertEqual(managerOne, obj, @"ZYAudioManager is not single");
        XCTAssertNotEqual(managerOne, obj,@"lalala就是不一样");
    }];
}

/**
 *  测试是否可以正常播放音乐
 */
- (void)testPlayingMusic
{
    self.player = [[ZYAudioManager defaultManager] playingMusic:_fileName];
    XCTAssertTrue(self.player.playing, @"ZYAudioManager is not PlayingMusic");
}

/**
 *  测试是否可以正常停止音乐
 */
- (void)testStopMusic
{
    if (self.player == nil) {
        self.player = [[ZYAudioManager defaultManager] playingMusic:_fileName];
    }
    
    if (self.player.playing == NO) [self.player play];
    
    [[ZYAudioManager defaultManager] stopMusic:_fileName];
    XCTAssertFalse(self.player.playing, @"ZYAudioManager is not StopMusic");
}

/**
 *  测试是否可以正常暂停音乐
 */
- (void)testPauseMusic
{
    if (self.player == nil) {
        self.player = [[ZYAudioManager defaultManager] playingMusic:_fileName];
    }
    if (self.player.playing == NO) [self.player play];
    [[ZYAudioManager defaultManager] pauseMusic:_fileName];
    XCTAssertFalse(self.player.playing, @"ZYAudioManager is not pauseMusic");
}

@end






