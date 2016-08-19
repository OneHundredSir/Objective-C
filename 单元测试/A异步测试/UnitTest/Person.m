//
//  Person.m
//  UnitTest
//
//  作者:香蕉  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "Person.h"

@implementation Person
+(instancetype)personWithDict:(NSDictionary *)dic
{
    NSString *str1;
    for (NSString *str in dic) {
        str1 = [str stringByAppendingString:str];
    }
    str1 = nil;
    Person *one = [[self alloc]init];
    return one;
}

/** 异步加载个人记录 */
+ (void)loadPersonAsync:(void (^)(Person *))completion {
    
    // 异步 子线程执行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 模拟网络延迟 2s
        [NSThread sleepForTimeInterval:2.0];
        
        Person *person = [Person personWithDict:@{@"name":@"zhang", @"age":@25}];
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(person);
            }
        });
    });
}
@end
