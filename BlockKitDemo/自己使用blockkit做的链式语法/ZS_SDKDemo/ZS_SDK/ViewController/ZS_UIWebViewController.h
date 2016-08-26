//
//  ZSWebViewController.h
//  JS_OC_MessageHandler
//
//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import <UIKit/UIKit.h>

@interface ZS_UIWebViewController : UIViewController

//网络请求页面
@property(nonatomic,strong)NSString *requestStr;


@property(nonatomic,copy)NSString *jsCommandStr;
//传入的页面进入一开始调用JSblock
@property(nonatomic,copy)void(^loadWebJSBlock)(UIWebView *webview);

//返回的网页数据
@property(nonatomic,copy)void(^feedBackBlock)(NSURL *urlFromWeb,UIWebView *webview);


@end
