//
//  LINKLISTVC.m
//  BaseSkillDemo
//
//  Created by HUN on 16/8/27.
//  Copyright © 2016年 com.zeustel.zssdk. All rights reserved.
//

#import "LINKLISTVC.h"
#import <ContactsUI/ContactsUI.h>
@interface LINKLISTVC ()<CNContactPickerDelegate>

@end

@implementation LINKLISTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
 其中需要说明的是,选择某个联系人和选择某个属性,还是跟之前一样的效果
 
 实现选择某个联系人,点击某个联系人之后,就会往下退出,不会再进入详细界面
 实现选择某个属性方法之后,点击电话,不会再自动拨出
 多出来的两个多选,是下图的这种效果,也就是左边出现多选的勾选框而已

 
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CNContactPickerViewController *cpvc = [[CNContactPickerViewController alloc]init];
    cpvc.delegate = self;
    [self presentViewController:cpvc animated:YES completion:nil];
}

#pragma mark - 代理方法
//选择了某个联系人
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
//{
//    
//}

//选择了某些联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact *> *)contacts
{
    
}

//选择了某个属性
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    
}

//选择了某些属性
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperties:(NSArray<CNContactProperty *> *)contactProperties
{
    
}

//点击了取消
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    
}

#pragma mark - 代理方法
//选择了某个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    //姓(就是家族的名字咯)
    NSString *familyName = contact.familyName;
    //名(就是家里人给你given取的名字咯)
    NSString *givenName = contact.givenName;
    NSLog(@"姓名是:%@",[NSString stringWithFormat:@"%@%@",familyName,givenName]);
    //电话号码的数组
    NSArray *phoneNumbers = contact.phoneNumbers;
    //遍历数组
    for (NSInteger i = 0; i<phoneNumbers.count; i++) {
        CNLabeledValue *value = phoneNumbers[i];
        NSString *label = value.label;
        CNPhoneNumber *number = value.value;
        NSLog(@"label:%@ number:%@",label,number.stringValue);
    }
}

@end
