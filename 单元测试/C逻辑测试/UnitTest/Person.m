//
//  Person.m
//  UnitTest
//
//  作者:香蕉  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "Person.h"

@implementation Person


+ (instancetype)personWithDict:(NSDictionary *)dict {
    Person *obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    // 预防处理age超限
    if (obj.age <= 0 || obj.age >= 130) {
        obj.age = 0;
    }
    
    return obj;
}

// 预防处理没有找到的key
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
@end
