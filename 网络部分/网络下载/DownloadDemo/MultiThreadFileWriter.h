//
//  MultiThreadFileWriter.h
//  DownloadDemo
//
//  Created by qingjie on 10/2/15.
//  Copyright © 2015 qingjie. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MultiThreadFileWriter : NSObject
{
@private
    FILE * i_outputFile;
    NSLock * i_fileLock;
}
- (id)initWithOutputPath:(NSString *)aFilePath;
- (BOOL)writeBytes:(const void *)bytes ofLength:(size_t)length toFileOffset:(off_t)offset;
- (BOOL)writeData:(NSData *)data toFileOffset:(off_t)offset;
- (void)close;

@end