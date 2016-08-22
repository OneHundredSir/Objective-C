//
//  ViewController.m
//  DownloadDemo
//
//  Created by qingjie on 10/2/15.
//  Copyright © 2015 qingjie. All rights reserved.
//

#import "ViewController.h"
#import "MultiThreadFileWriter.h"


@interface ViewController (){
  
}

@end


@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startToDownloadTapped:(id)sender {
NSLog( @"srt path is %@" , [[NSBundle mainBundle] bundlePath] );
//    [self downloadFile];
    [self downloadLargeFile];
    //[self downloadFileWithNSURLSession];
    
   
    
    
}

-(void)downloadFile{
    NSString *stringURL = @"http://cs7-media.s3.amazonaws.com/algebra_101_training_knowledge_app_2497/rt_movies/upload/msa_algebra_poly4_multiplying_es.xml";;
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString  *fileName = [NSString stringWithFormat:@"%@/%@", cachePath,@"213.srt"];

    //NSString *fileName=[cachePath stringByAppendingPathComponent:@"213.srt"];
    [urlData writeToFile:fileName atomically:YES];
    
    NSLog(@"fileName,%@",fileName);
    
    /*
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.srt"];
         NSLog(@"filePath,%@",filePath);
        [urlData writeToFile:filePath atomically:YES];
    }
     */
}


-(void)downloadLargeFile{
    //download the file in a seperate thread.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Downloading Started");
        NSString *urlToDownload = @"http://cs7-media.s3.amazonaws.com/algebra_101_training_knowledge_app_2497/rt_movies/upload/msa_algebra_poly4_multiplying_es.xml";
        NSURL  *url = [NSURL URLWithString:urlToDownload];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename_large.srt"];
            NSLog(@"filePath,%@",filePath);
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePath atomically:YES];
                NSLog(@"File Saved !");
            });
        }
        
    });

}

-(void)downloadFileWithNSURLSession{
    
    
    NSString *urlStr=@"http://cs7-media.s3.amazonaws.com/algebra_101_training_knowledge_app_2497/rt_movies/upload/msa_algebra_poly4_multiplying_es.xml";
    
//    urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr =[urlStr stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSURL *url=[NSURL URLWithString:urlStr];
    //2.创建请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    //3.创建会话（这里使用了一个全局会话）并且启动任务
    NSURLSession *session=[NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downloadTask=[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error) {
            //注意location是下载后的临时保存路径,需要将它移动到需要保存的位置
            
            NSError *saveError;
            NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            
            NSLog(@"----cachePath----,%@",cachePath);
    
            
            NSString *savePath=[cachePath stringByAppendingPathComponent:@"test.srt"];
            
            
            NSLog(@"----savePath----,%@",savePath);
            
            
            NSURL *saveUrl=[NSURL fileURLWithPath:savePath];
            [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveUrl error:&saveError];
            if (!saveError) {
                NSLog(@"save sucess.");
            }else{
                NSLog(@"error is :%@",saveError.localizedDescription);
            }
            
        }else{
            NSLog(@"error is :%@",error.localizedDescription);
        }
    }];
    
    [downloadTask resume];
}


@end
