//
//  downloadOperation.h
//  downLoadTest
//
//  Created by HUN on 16/8/11.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface downloadOperation : NSOperation



+ (instancetype)downloadWith:(NSURL *)url progressBlock:(void (^)(CGFloat progress))progressBlock complete:(void (^)(NSString *path,NSError *error))complete;




- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void)cancleDown;

@end
