//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微博:http://weibo.com/u/6013257513?is_all=1
//  QQ技术讨论交流群 : 365204530
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda

#import "FISampleBuffer.h"
#import "FIError.h"

@implementation FISampleBuffer

#pragma mark Initialization

- (id) initWithData: (NSData*) data sampleRate: (NSUInteger) sampleRate
    sampleFormat: (FISampleFormat) sampleFormat error: (NSError**) error
{
    self = [super init];

    if (data != nil) {
        _sampleFormat = sampleFormat;
        _sampleRate = sampleRate;
        _numberOfSamples = [data length] / [self bytesPerSample];
    } else {
        return nil;
    }

    FI_INIT_ERROR_IF_NULL(error);
    ALenum status = ALC_NO_ERROR;

    if (!alcGetCurrentContext()) {
        *error = [FIError errorWithMessage:@"No OpenAL context"
            code:FIErrorNoActiveContext];
        return nil;
    }

    alClearError();
    alGenBuffers(1, &_handle);
    status = alGetError();
    if (status) {
        *error = [FIError errorWithMessage:@"Failed to create OpenAL buffer"
            code:FIErrorCannotCreateBuffer OpenALCode:status];
        return nil;
    }

    alClearError();
    alBufferData(_handle, [self OpenALSampleFormat], [data bytes], (ALsizei)[data length], (ALsizei)sampleRate);
    status = alGetError();
    if (status) {
        *error = [FIError errorWithMessage:@"Failed to pass sample data to OpenAL"
            code:FIErrorCannotUploadData OpenALCode:status];
        return nil;
    }

    return self;
}

- (void) dealloc
{
    if (_handle) {
        alDeleteBuffers(1, &_handle);
        _handle = 0;
    }
}

#pragma mark Calculations

- (ALenum) OpenALSampleFormat
{
    switch (_sampleFormat) {
        case FISampleFormatMono8:
            return AL_FORMAT_MONO8;
        case FISampleFormatMono16:
            return AL_FORMAT_MONO16;
        case FISampleFormatStereo8:
            return AL_FORMAT_STEREO8;
        case FISampleFormatStereo16:
            return AL_FORMAT_STEREO16;
    }
}

- (NSUInteger) bytesPerSample
{
    switch (_sampleFormat) {
        case FISampleFormatMono8:
            return 1;
        case FISampleFormatMono16:
            return 2;
        case FISampleFormatStereo8:
            return 2;
        case FISampleFormatStereo16:
            return 4;
    }
}

- (NSTimeInterval) duration
{
    return (NSTimeInterval) _numberOfSamples / _sampleRate;
}

@end
