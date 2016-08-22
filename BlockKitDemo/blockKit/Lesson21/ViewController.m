//
//  ViewController.m
//  Lesson21
//
//  Created by Azat Almeev on 11.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

#import "ViewController.h"
#import <BlocksKit+MessageUI.h>
#import <BlocksKit+UIKit.h>

@interface NSNumber (Extended)
- (NSArray *)take;
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *input = [@5 take];
//    NSLog(@"%@", [self incrementArrayBy1:input]);
//    NSLog(@"%@", [input bk_select:^BOOL(NSNumber *obj) {
//        return obj.integerValue % 2 == 0;
//    }]);
//    NSLog(@"%@", [input bk_reduce:@0 withBlock:^id(NSNumber *sum, NSNumber *obj) {
//        return @([sum integerValue] + [obj integerValue]);
//    }]);
//    NSLog(@"%@", [input bk_reduce:@"" withBlock:^id(id sum, id obj) {
//        return [NSString stringWithFormat:@"%@%@", sum, obj];
//    }]);
//    NSDictionary *keyValues = @{ @"key1" : @1, @"key2" : @2, @"key3" : @3 };
//    NSLog(@"%@", [[keyValues bk_map:^id(id key, id obj) {
//        return @([obj integerValue] * 2);
//    }] bk_select:^BOOL(id key, id obj) {
//        return [obj integerValue] > 5;
//    }]);
    
    
    NSArray *buttons = [input bk_map:^id(id obj) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:[NSString stringWithFormat:@"Btn %@", obj] forState:UIControlStateNormal];
        NSInteger index = [obj integerValue] - 1;
        button.frame = CGRectMake(index * 100 + 20, 40, 90, 35);
//        button.tag = index;
//        [button addTarget:self action:@selector(buttonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [button bk_addEventHandler:^(UIButton *sender) {
            NSLog(@"%@", @(index));
        } forControlEvents:UIControlEventTouchUpInside];
        [button bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        [button bk_addEventHandler:^(UIButton *sender) {
            NSLog(@"%@", @(index * 2));
        } forControlEvents:UIControlEventTouchUpInside];
        return button;
    }];
    [buttons bk_each:^(id obj) {
        [self.view addSubview:obj];
    }];
}

- (IBAction)buttonDidTap:(UIButton *)sender {
    NSLog(@"%@", @(sender.tag));
}

- (NSArray <NSNumber *>*)incrementArrayBy1:(NSArray <NSNumber *>*)input {
    return [input bk_map:^id(NSNumber *obj) {
        return @(obj.integerValue + 1);
    }];
}

- (NSArray <NSNumber *>*)getLengthsOfElements:(NSArray <NSString *>*)input {
    return [input bk_map:^id(NSString *obj) {
        return @(obj.length);
    }];
}

@end

@implementation NSNumber (Extended)

- (NSArray *)take {
    NSMutableArray *res = [NSMutableArray new];
    for (int i = 1; i <= self.integerValue; i++)
        [res addObject:@(i)];
    return res.copy;
}

@end


