//
//  VRPlayerTests.m
//  VRPlayerTests
//
//  Created by chengshenggen on 7/19/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface VRPlayerTests : XCTestCase

@end

@implementation VRPlayerTests

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
    
    uint8_t buf[2] = {0x00,0x19};
    printf("\n---------%d---------\n",buf[1]);
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
