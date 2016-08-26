//
//  ZSWebViewController.m
//  ZS_SDKDemo
//
//  Created by HUN on 16/8/24.
//  Copyright © 2016年 com.zeustel.zssdk. All rights reserved.
//

#import "ZSWebViewController.h"
#import <WebKit/WebKit.h>
@interface ZSWebViewController ()<WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *webView;

@end

@implementation ZSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initWeb];
    
}


-(void)setWebUrlStr:(NSString *)webUrlStr
{
    _webUrlStr = webUrlStr;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrlStr]]];
}

-(void)_initWeb
{
    //进行配置控制器
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //实例化对象
    configuration.userContentController = [WKUserContentController new];
    
    
    _webView = [[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_webView];
    _webView.UIDelegate = self;
}


#pragma mark - WKUIDelegate
//当把JS返回给控制器,然后弹窗就是这样设计的
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WKScriptMessageHandler
//点击返回的数据
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //    message.body  --  Allowed types are NSNumber, NSString, NSDate, NSArray,NSDictionary, and NSNull.
    NSLog(@"body:%@",message.body);
    if ([message.name isEqualToString:@"ScanAction"]) {
    
    }

}
@end
