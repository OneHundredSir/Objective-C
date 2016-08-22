//
//  downloadManager.m
//  downLoadTest
//
//  Created by HUN on 16/8/11.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "downloadManager.h"

#import "NSString+Path.h"
#import "downloadOperation.h"


@interface downloadManager()

/**
 *  下载操作缓存,以url为key，防止多次下载
 */
@property (nonatomic,strong)NSMutableDictionary *downloadCache;

/**
 *  下载队列,可以控制并发数
 */
@property (nonatomic,strong)NSOperationQueue *downloadQueue;
@end

@implementation downloadManager

/**
 *  下载管理器单例
 *
 *  @return 返回唯一的实例
 */
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static downloadManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}
/**
 *  下载操作
 *
 *  @param url           要下载的url
 *  @param progressBlock 进度回调
 *  @param complete      完成回调
 */
- (void)downloadWith:(NSURL *)url pregressBlock:(void (^)(CGFloat progress))progressBlock complete:(void(^)(NSString *path,NSError *error))complete{
    //在开始下载之前，判断是否正在下载
    if ([self.downloadCache objectForKey:url]) {
        NSLog(@"正在下载");
        return;
    }
    //开始下载文件
    downloadOperation *download = [downloadOperation downloadWith:url progressBlock:progressBlock complete:^(NSString *path, NSError *error) {
        //下载完成
        //移除下载操作缓存
        [self.downloadCache removeObjectForKey:url];
        //调用控制器传过来的完成回调
        complete(path,error);
    }];
    //把下载操作保存起来
    [self.downloadCache setObject:download forKey:url];
    //把操作发到队列中
    [self.downloadQueue addOperation:download];
}




//移除保存

- (void)cancelDownload:(NSURL *)url{
    //从字典中取出下载操作
    downloadOperation *down = [self.downloadCache objectForKey:url];
    [down cancleDown];
    //从字典中移除
    [self.downloadCache removeObjectForKey:url];
}
#pragma mark -数据懒加载
- (NSMutableDictionary *)downloadCache{
    if (_downloadCache == nil) {
        _downloadCache = [NSMutableDictionary dictionary];
    }
    return _downloadCache;
}

- (NSOperationQueue *)downloadQueue{
    if (_downloadQueue == nil) {
        _downloadQueue = [[NSOperationQueue alloc]init];
        //设置最大并发数
        _downloadQueue.maxConcurrentOperationCount = 3;
    }
    return _downloadQueue;
}
@end