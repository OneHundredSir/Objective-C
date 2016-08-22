//
//  MultiThreadFileWriter.m
//  DownloadDemo
//
//  Created by qingjie on 10/2/15.
//  Copyright © 2015 qingjie. All rights reserved.
//

#import "MultiThreadFileWriter.h"


@implementation MultiThreadFileWriter


- (id)initWithOutputPath:(NSString *)aFilePath
{
    self = [super init];
    if (self) {
        i_fileLock = [[NSLock alloc] init];
        i_outputFile = fopen([aFilePath UTF8String], "w");
        if (!i_outputFile || !i_fileLock) {
            self = nil;
        }
    }
    return self;
}


- (BOOL)writeBytes:(const void *)bytes ofLength:(size_t)length toFileOffset:(off_t)offset
{
    BOOL success;
    
    [i_fileLock lock];
    success = i_outputFile != NULL
    && fseeko(i_outputFile, offset, SEEK_SET) == 0
    && fwrite(bytes, length, 1, i_outputFile) == 1;
    [i_fileLock unlock];
    return success;
}

- (BOOL)writeData:(NSData *)data toFileOffset:(off_t)offset
{
    return [self writeBytes:[data bytes] ofLength:[data length] toFileOffset:offset];
}

- (void)close
{
    [i_fileLock lock];
    if (i_outputFile) {
        fclose(i_outputFile);
        i_outputFile = NULL;
    }
    [i_fileLock unlock];
}

@end