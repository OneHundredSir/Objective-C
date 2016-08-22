//
//  RWDummySignInService.h
//  RWReactivePlayground
//
//  Created by Colin Eberhardt on 18/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RWSignInResponse)(BOOL);
typedef void (^MyTestRespone)(BOOL);

@interface RWDummySignInService : NSObject

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(MyTestRespone)completeBlock;

@end
