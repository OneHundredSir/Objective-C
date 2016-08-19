//
//  PersonTestS.m
//  UnitTest
//
//  Created by HUN on 16/8/19.
//  Copyright © 2016年 com.gongzonghao.iOSHundred. All rights reserved.
//

#import "PersonTestS.h"
//导入头文件
#import "Person.h"
@implementation PersonTestS
// 逻辑测试方法
//开始
- (void)testNewPerson {
    
    // 1.测试 name和age 是否一致
    [self checkPersonWithDict:@{@"name":@"zhou", @"age":@30}];
    
    /** 2.测试出 age 不符合实际，那么需要在字典转模型方法中对age加以判断：
     if (obj.age <= 0 || obj.age >= 130) {
     obj.age = 0;
     }
     */
    [self checkPersonWithDict:@{@"name":@"zhang",@"age":@200}];
    
    // 3.测试出 name 为nil的情况，因此在XCTAssert里添加条件：“person.name == nil“
    [self checkPersonWithDict:@{}];
    
    // 4.测试出 Person类中没有 title 这个key，在字典转模型方法中实现：- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
    [self checkPersonWithDict:@{@"name":@"zhou", @"age":@30, @"title":@"boss"}];
    
    // 5.总体再验证一遍，结果Build Succeeded，测试全部通过
    [self checkPersonWithDict:@{@"name":@"zhou", @"age":@-1, @"title":@"boss"}];
    
    // 到目前为止 Person 的 工厂方法测试完成！✅
}

// 根据字典检查新建的 person 信息
- (void)checkPersonWithDict:(NSDictionary *)dict {
    
    Person *person = [Person personWithDict:dict];
    
    NSLog(@"%@",person);
    
    // 获取字典中的信息
    NSString *name = dict[@"name"];
    NSInteger age = [dict[@"age"] integerValue];
    
    // 1.检查名字
    XCTAssert([name isEqualToString:person.name] || person.name == nil, @"姓名不一致");
    
    // 2.检查年龄
    if (person.age > 0 && person.age < 130) {
        XCTAssert(age == person.age, @"年龄不一致");
    } else {
        XCTAssert(person.age == 0, @"年龄超限");
    }
}
@end

