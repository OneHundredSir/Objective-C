    //
//  downloadOperation.m
//  downLoadTest
//
//  Created by HUN on 16/8/11.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "downloadOperation.h"

#import "NSString+Path.h"


@interface downloadOperation()
/**
 *  文件总大小
 */
@property (nonatomic,assign) long long expectLength;
/**
 *  已经下载的大小
 */
@property (nonatomic,assign)long long downloadLength;

/**
 *  文件输出流
 */
@property (nonatomic,strong)NSOutputStream *outPut;

/**
 *  下载连接
 */
@property (nonatomic,strong)NSURLConnection *connection;

/**
 *  进度回调block
 */
@property (nonatomic,copy)void (^progressBlock)(CGFloat);

/**
 *  完成回调block
 */
@property (nonatomic,copy)void (^complete)(NSString *,NSError *);

/**
 *  文件保存的路径
 */
@property (nonatomic,copy)NSString *targetPath;
/**
 *  网址
 */
@property (nonatomic,strong)NSURL *url;
@end

@implementation downloadOperation

+ (instancetype)downloadWith:(NSURL *)url progressBlock:(void (^)(CGFloat progress))progressBlock complete:(void (^)(NSString *path,NSError *error))complete{
    downloadOperation *down = [[self alloc]init];
    //把block保存起来
    down.progressBlock = progressBlock;
    down.complete = complete;
    //拼接文件保存的路径
    down.targetPath = [url.path appendCaches];
    
    down.url = url;
    //调用下载方法
    //[down download:url];
    return down;
}

- (void)main{
    @autoreleasepool {
        [self download];
    }
}
- (void)download{
    
    NSURL *url = self.url;
    //断点下载，如果完全相同，不下载。否则，从fileSize开始下载
    long long fileSize = [self checkServerFileSize:url];
    if (fileSize == self.expectLength) {
        return ;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //断点续传必须设置range请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%lld-",fileSize];
    //下载进度就是本地文件的大小
    self.downloadLength = fileSize;
    //设置请求头
    [request setValue:range forHTTPHeaderField:@"range"];
    
    //开始下载,通过遵守代理协议，回调下载过程
    [NSURLConnection connectionWithRequest:request delegate:self];
    //如果子线程在执行完当前代码后需要一直保持的，需要把runloop跑起来
    [[NSRunLoop currentRunLoop] run];
    
}
//检查服务器上文件的大小
- (long long)checkServerFileSize:(NSURL *)url{
    //要下载文件的url
    //NSURL *url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/2a/25677/QQ_V4.1.1.1456905733.dmg"];
    //创建获取文件大小的请求
    NSMutableURLRequest *headRequest = [NSMutableURLRequest requestWithURL:url];
    //请求方法
    headRequest.HTTPMethod = @"HEAD";
    //创建一个响应头
    NSURLResponse *headResponse;
    [NSURLConnection sendSynchronousRequest:headRequest returningResponse:&headResponse error:nil];
    long long serverSize = headResponse.expectedContentLength;
    //记录服务器文件的大小，用于计算进度
    self.expectLength = serverSize;
    //拼接文件路径
    NSString *path = [headResponse.suggestedFilename appendCaches];
    //判断服务器文件大小跟本地文件大小的关系
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        NSLog(@"不存在，从头开始下载");
        return 0;
    }
    //获取文件的属性
    NSDictionary *dict = [manager attributesOfItemAtPath:path error:nil];
    //获取本地文件的大小
    long long fileSize = dict.fileSize;
    if (fileSize > serverSize) {
        //文件出错，删除文件
        [manager removeItemAtPath:path error:nil];
        NSLog(@"从头开始");
        return 0;
    }else if(fileSize < serverSize){
        NSLog(@"从本地文件大小开始下载");
        return fileSize;
    }else{
        NSLog(@"已经下载完毕");
        return fileSize;
    }
}

#pragma mark -下载回调
//获得相应,响应头中包含了文件总大小的信息
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //    //设置文件总大小
    //    self.expectLength = response.expectedContentLength;
    NSString *path = self.targetPath;
    //不需要手动去创建，如果文件不存在，自动创建
    self.outPut = [NSOutputStream outputStreamToFileAtPath:path append:YES];
    //在入文件之前，先打开文件
    [self.outPut open];
}
//接收到数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //分多次接收数据，加起来就是总数据
    self.downloadLength += data.length;
    //计算当前下载进度
    CGFloat progress = self.downloadLength *1.0 / self.expectLength;
    //NSLog(@"当前进度%f",progress);
    
    //进度回调调用的频率非常高，我们可以在子线程回调。用户是否要刷新UI，由自己决定
    if (self.progressBlock) {
        self.progressBlock(progress);
    }
    
    //保存每次接收到的数据
    //#warning 每次的数据都保存在内存中，消耗大量内存
    //    [self.data appendData:data];
    //解决方法：使用文件句柄
    
    [self.outPut write:data.bytes maxLength:data.length];
    
}
//下载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //关闭文件
    [self.outPut close];
    //下载完成后，自动回到主线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.complete(self.targetPath,nil);
    });
}
//取消下载
- (void)cancleDown{
    [self.connection cancel];
}
@end
