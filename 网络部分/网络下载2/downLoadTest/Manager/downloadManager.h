//
//  downloadManager.h
//  downLoadTest
//
//  Created by HUN on 16/8/11.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface downloadManager : NSObject



+ (instancetype)sharedManager;


- (void)downloadWith:(NSURL *)url pregressBlock:(void (^)(CGFloat progress))progressBlock complete:(void(^)(NSString *path,NSError *error))complete;

- (void)cancelDownload:(NSURL *)url;

@end
