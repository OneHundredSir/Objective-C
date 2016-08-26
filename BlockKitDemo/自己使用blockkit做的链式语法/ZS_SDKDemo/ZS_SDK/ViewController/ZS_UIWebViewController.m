//
//  ZSWebViewController.m
//  JS_OC_MessageHandler
//
//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "ZS_UIWebViewController.h"
@interface ZS_UIWebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic)   UIWebView     *webView;

@end
@implementation ZS_UIWebViewController

//页面加载H5
-(void)setRequestStr:(NSString *)requestStr
{
    _requestStr = requestStr;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestStr]]];
}

-(UIWebView *)webView
{
    [self _initWebView];
    return _webView;
}

-(void)_initWebView
{
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat refleshH = 30;
    UIWebView *web = [[UIWebView alloc]initWithFrame:(CGRect){0,0,screenW,screenH-refleshH}];
    web.backgroundColor = [UIColor redColor];
    [self.view addSubview:web];
    _webView = web;
    _webView.scrollView.bounces = NO;
    web.delegate = self;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){0,0,30,44}];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(backToView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *reFleshBtn = [[UIButton alloc]initWithFrame:(CGRect){0,screenH-refleshH,screenW,refleshH}];
    [reFleshBtn setBackgroundColor:[UIColor lightGrayColor]];
    reFleshBtn.alpha = 0.7;
    [reFleshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [reFleshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:reFleshBtn];
    
    
    
}


-(void)setJsCommandStr:(NSString *)jsCommandStr
{
    _jsCommandStr = jsCommandStr;
    if (_webView) {
        [_webView stringByEvaluatingJavaScriptFromString:jsCommandStr];
    }
}


//返回按钮
-(void)backToView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark delegate


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.loadWebJSBlock) {
        self.loadWebJSBlock(webView);
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    if (self.feedBackBlock) {
        self.feedBackBlock(url,webView);
    }
    
    return YES;
}


@end
