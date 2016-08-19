//
//  UnitTestTests.m
//  UnitTestTests
//
//  作者:香蕉  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import <XCTest/XCTest.h>
#import "Person.h"
@interface UnitTestTests : XCTestCase

@end

@implementation UnitTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        
        NSTimeInterval start = CACurrentMediaTime();
        
        // 测试用例，循环10000次，为了演示效果
        for (NSInteger i = 0; i < 10000; i++) {
            [Person personWithDict:@{@"name":@"zhang",@"age":@20}];
        }
        
        // 传统测试代码耗时方法
        NSLog(@"%lf,我是香蕉大大",CACurrentMediaTime() - start);
        
        
    }];
}

//这里用Command+U运行
// 测试异步加载person
- (void)testLoadPersonAsync {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"异步加载 Person"];
    
    [Person loadPersonAsync:^(Person *person) {
        //        NSLog(@"%@",person);
        
        XCTAssertNotNil(person.name, @"名字不能为空");
        XCTAssert(person.age > 0, @"年龄不正确");
        
        // 标注预期达成
        [expectation fulfill];
    }];
    
    // 等待 5s 期望预期达成
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
@end
