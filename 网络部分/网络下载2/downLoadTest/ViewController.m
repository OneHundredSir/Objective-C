//
//  ViewController.m
//  downLoadTest
//
//  Created by HUN on 16/8/10.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "ViewController.h"
#import "downloadManager.h"


#define downLoadUrl @"https://www.baidu.com/link?url=Nnh84-f7YoBiwzYGRMyi6CnquLzwC5_9uDlZ_9a8TqfpjTTSH9KbKglgdxmAjCYMdXXlGfcTDNistNRUXuDnHkawhlVPnadLe3SlNGMumyi&wd=&eqid=cbbd6ad0000abc570000000657aa7f4e"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (IBAction)downloadBegin:(UIButton *)sender
{
    //要下载的文件的URL
    NSURL *url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/2a/25677/QQ_V4.1.1.1456905733.dmg"];
    if ((sender.selected=!sender.selected)) {
        
        
        
        //通过下载管理器单例执行下载
        [[downloadManager sharedManager] downloadWith:url pregressBlock:^(CGFloat progress) {
            //进度回调，返回下载进度
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程刷新进度提醒
                self.progress.progress = progress;
                NSLog(@"进度%f",progress);
            });
        } complete:^(NSString *path, NSError *error) {
            //完成回调，返回文件路径或者失败信息
            NSLog(@"下载完成%@",path);
        }];
    }else
    {
        [[downloadManager sharedManager] cancelDownload:url];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
