//
//  VRPlayer.m
//  VRPlayer
//
//  Created by chengshenggen on 7/19/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "VRPlayer.h"
#import "AAPLEAGLLayer.h"
#import "VRPlayerHeader.h"
#import "KBPlayerEnumHeaders.h"
#import <VideoToolbox/VideoToolbox.h>

@protocol H264HwDecoderImplDelegate <NSObject>

- (void)displayDecodedFrame:(CVImageBufferRef )imageBuffer;


@end

@interface VRPlayer ()<H264HwDecoderImplDelegate>{
    FILE *_file;
    
    uint8_t *_sps;
    NSInteger _spsSize;
    uint8_t *_pps;
    NSInteger _ppsSize;
    VTDecompressionSessionRef _deocderSession;
    CMVideoFormatDescriptionRef _decoderFormatDescription;
    
    
    int i_frame_counter;
}

@property(nonatomic,strong)AAPLEAGLLayer *appleGLLayer;

@property(nonatomic,copy)NSString *urlStr;

@property(nonatomic,assign)VideoState *is;
@property(nonatomic,strong)NSThread *read_tid;
@property(nonatomic,strong)NSThread *videoThread;
@property(nonatomic,strong)NSThread *audioThread;
@property(nonatomic,assign)KBPlayerPlayingState playingState;  //播放状态
@property(nonatomic,strong)NSTimer *timer;


@end


@implementation VRPlayer

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.appleGLLayer];
    }
    return self;
}

-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
}


#pragma mark - player manager
-(void)preparePlay{
    _urlStr = [[NSBundle mainBundle] pathForResource:@"cuc_ieschool" ofType:@"flv"];
    _is = malloc(sizeof(VideoState));
    pthread_mutex_init(&_is->pictq_mutex, NULL);
    pthread_cond_init(&_is->pictq_cond, NULL);
    [self schedule_refresh:70];
    _read_tid = [[NSThread alloc] initWithTarget:self selector:@selector(read_thread) object:nil];
    _read_tid.name = @"com.3glasses.vrshow.read";
    [_read_tid start];
}

-(void)play{
    
}

-(void)pause{
    
}

#pragma mark - read thread
-(void)read_thread{
    
    _is->audio_stream = -1;
    _is->video_stream = -1;
    
    _file = fopen([_urlStr UTF8String], "rb");
    FLV_HEADER flv_header = [self flv_prob];
    //存在音频
    if (flv_header.Flags>>2 == 1) {
        
        if ((flv_header.Flags&0x01) == 1) {
            //存在视频
            _is->audio_stream = TAG_TYPE_AUDIO;
            _is->video_stream = TAG_TYPE_VIDEO;
        }else{
            printf("Flags: Audio \n");
            _is->audio_stream = TAG_TYPE_AUDIO;
        }
    }
    if (_is->video_stream>=0) {
        [self video_stream_component_open];
    }
    AVPacket *packet;
    packet=(AVPacket *)malloc(sizeof(AVPacket));
    
    fseek(_file, CFSwapInt32BigToHost(flv_header.DataOffset), SEEK_SET);
    VideoPicture *vp = malloc(sizeof(VideoPicture));
    
    _is->pictq[0] = *vp;
    _is->pictq_windex = 0;
    _is->pictq_rindex = 0;
    _is->pictq_size = 0;
    
    for (; ; ) {
        if (_is->videoq.size > MAX_VIDEOQ_SIZE) {
            printf(" videoq.size %d\n",_is->videoq.size);
            usleep(10*1000);
            continue;
        }
        if ([self av_read_frame:packet]>=0) {
            if (packet->stream_index == _is->video_stream) {
//                printf(" video.pts %lld\n",packet->pts);
                packet_queue_put(&_is->videoq, packet);
            }else if (packet->stream_index == _is->audio_stream){
//                printf(" audio.size %d\n",packet->size);
//                packet_queue_put(&_is->audioq, packet);
            }
        }else{
            break;
        }
    }
    
}

-(void)caulatePts:(AVPacket *)packet{
    uint8_t *buf = packet->data;
    int dataSize = packet->size;
    
    int FrameType = (buf[0]>>4)&0x0f;
    if (FrameType == 1) {
        //key frame;
        i_frame_counter = 0;
        printf("%d I key frame \n",i_frame_counter);
        
    }else{
        i_frame_counter++;
        printf("%d B/P frame \n",i_frame_counter);
        
    }
    
    
}

-(int)av_read_frame:(AVPacket *)packet{
    uint previoustagsize = 0;
    previoustagsize =  CFSwapInt32BigToHost(getw(_file));
    
    TAG_HEADER tagheader;
    fread((void *)&tagheader,sizeof(TAG_HEADER),1,_file);
    int tagheader_datasize=tagheader.DataSize[0]*65536+tagheader.DataSize[1]*256+tagheader.DataSize[2];
//    int tagheader_timestamp=tagheader.Timestamp[0]*65536+tagheader.Timestamp[1]*256+tagheader.Timestamp[2];
    packet->stream_index = tagheader.TagType;
    
    packet->data = malloc(tagheader_datasize);
    size_t read_size = fread(packet->data, sizeof(uint8_t), tagheader_datasize, _file);
    packet->size = read_size;
    packet->pts = ((tagheader.Timestamp[0]<<8|tagheader.Timestamp[1])<<8|tagheader.Timestamp[2])|tagheader.TimestampExtended<<24;
    if (read_size == tagheader_datasize) {
        
    }else if (read_size<=0){
        if (feof(_file)) {
            //读流结束
            return -1;
        }
    }
    if (tagheader.TagType == TAG_TYPE_AUDIO) {
        //音频
        
    }else if (tagheader.TagType == TAG_TYPE_VIDEO) {
        //视频
        
    }else if (tagheader.TagType == TAG_TYPE_SCRIPT) {
        //SCRIPT
        
    }else{
        
        printf("UNKNOWN\n");
    }
    
    
    return 0;
}

-(void)video_stream_component_open{
    packet_queue_init(&_is->videoq);
    _videoThread = [[NSThread alloc] initWithTarget:self selector:@selector(playVideoThread) object:nil];
    _videoThread.name = @"com.3glasses.vrshow.video";
    [_videoThread start];

}

-(void)audio_stream_component_open{
    packet_queue_init(&_is->audioq);
    _audioThread = [[NSThread alloc] initWithTarget:self selector:@selector(playAudioThread) object:nil];
    _audioThread.name = @"com.3glasses.vrshow.audio";
    [_audioThread start];
}

-(void)playVideoThread{
    
    AVPacket pkt1, *packet = &pkt1;
    
    for (; ; ) {
        if (packet_queue_get(&_is->videoq, packet, 1) < 0) {
            // means we quit getting packets
            continue;
        }
        
        if (_deocderSession) {
            CVPixelBufferRef pixel = [self decode:packet];
//            [self queue_picture:pixel];
        }else{
            [self initH264Decoder:packet];
        }
        
        
    }
    
}



-(void)playAudioThread{
    
}

-(int)queue_picture:(CVPixelBufferRef)pixel{
    VideoPicture *vp;
    vp = &_is->pictq[_is->pictq_windex];
    pthread_mutex_lock(&_is->pictq_mutex);
    while (_is->pictq_size>=VIDEO_PICTURE_QUEUE_SIZE) {
        pthread_cond_wait(&_is->pictq_cond, &_is->pictq_mutex);
    }
    pthread_mutex_unlock(&_is->pictq_mutex);
    if (++_is->pictq_windex == VIDEO_PICTURE_QUEUE_SIZE) {
        _is->pictq_windex = 0;
    }
    vp->pixel = pixel;
    pthread_mutex_lock(&_is->pictq_mutex);
    _is->pictq_size++;
    pthread_mutex_unlock(&_is->pictq_mutex);
    return 0;
}

-(CVPixelBufferRef)decode:(AVPacket *)packet{
    
    CVPixelBufferRef outputPixelBuffer = NULL;
    CMBlockBufferRef blockBuffer = NULL;
    
    uint8_t *buf = packet->data+5;
    int dataSize = packet->size - 5;
    
    OSStatus status  = CMBlockBufferCreateWithMemoryBlock(kCFAllocatorDefault, buf, dataSize, kCFAllocatorNull, NULL, 0,dataSize, 0, &blockBuffer);
    if(status == kCMBlockBufferNoErr) {
        CMSampleBufferRef sampleBuffer = NULL;
        const size_t sampleSizeArray[] = {dataSize};
        
        int32_t timeSpan = 1000;
        CMTime PTime = CMTimeMake(packet->pts, timeSpan);
        CMSampleTimingInfo timingInfo;
        timingInfo.presentationTimeStamp = PTime;
        timingInfo.duration =  kCMTimeZero;
        timingInfo.decodeTimeStamp = kCMTimeInvalid;
        
        status = CMSampleBufferCreateReady(kCFAllocatorDefault,
                                           blockBuffer,
                                           _decoderFormatDescription ,
                                           1, 1, &timingInfo, 1, sampleSizeArray,
                                           &sampleBuffer);
        
        if (status == kCMBlockBufferNoErr && sampleBuffer) {
            
            VTDecodeFrameFlags flags = 0;
            VTDecodeInfoFlags flagOut = 0;
            OSStatus decodeStatus = VTDecompressionSessionDecodeFrame(_deocderSession,
                                                                      sampleBuffer,
                                                                      flags,
                                                                      &outputPixelBuffer,
                                                                      &flagOut);
            
            if(decodeStatus == kVTInvalidSessionErr) {
                NSLog(@"IOS8VT: Invalid session, reset decoder session");
            } else if(decodeStatus == kVTVideoDecoderBadDataErr) {
                NSLog(@"IOS8VT: decode failed status=%d(Bad data)", decodeStatus);
            } else if(decodeStatus != noErr) {
                NSLog(@"IOS8VT: decode failed status=%d", decodeStatus);
            }
            
            CFRelease(sampleBuffer);
        }
        CFRelease(blockBuffer);
    }
    
    return outputPixelBuffer;
}

-(void)schedule_refresh:(int)delay{
    if (_timer) {
        [_timer invalidate];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:delay/1000.0 target:self selector:@selector(video_refresh_timer) userInfo:nil repeats:YES];
}

-(void)video_refresh_timer{
    VideoPicture *vp;
    vp = &_is->pictq[_is->pictq_rindex];
    if (_is->pictq_size>0) {
        [self video_display:vp];
        
        if (++_is->pictq_rindex == VIDEO_PICTURE_QUEUE_SIZE) {
            _is->pictq_rindex = 0;
        }
        pthread_mutex_lock(&_is->pictq_mutex);
        _is->pictq_size--;
        pthread_cond_signal(&_is->pictq_cond);
        pthread_mutex_unlock(&_is->pictq_mutex);
    }
}

-(void)video_display:(VideoPicture *)vp{
    _appleGLLayer.pixelBuffer = vp->pixel;
}

- (void)displayDecodedFrame:(CVImageBufferRef )imageBuffer{
    [self queue_picture:imageBuffer];
}

#pragma mark - decode h264
static void didDecompress( void *decompressionOutputRefCon, void *sourceFrameRefCon, OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef pixelBuffer, CMTime presentationTimeStamp, CMTime presentationDuration ){
    
    float videoDurationSeconds = CMTimeGetSeconds(presentationTimeStamp);
    float videoDurationDuration = CMTimeGetSeconds(presentationDuration);

    printf("videoDurationSeconds  %f   presentationDuration %f\n",videoDurationSeconds,videoDurationDuration);
    
    CVPixelBufferRef *outputPixelBuffer = (CVPixelBufferRef *)sourceFrameRefCon;
    *outputPixelBuffer = CVPixelBufferRetain(pixelBuffer);
    VRPlayer *decoder = (__bridge VRPlayer *)decompressionOutputRefCon;
    [decoder displayDecodedFrame:pixelBuffer];
}

-(BOOL)initH264Decoder:(AVPacket *)packet{
    
    if(_deocderSession) {
        //        [self clearH264Deocder];
        return YES;
    }
    
    uint8_t *buf = packet->data;
    uint8_t *buf2 = buf+5;
    if (buf[1] == 0) {
        // AVCDecoderConfigurationRecord（AVC sequence header）
        int naluLength = buf2[4]&0x03+1;
        int spsNum = buf2[5]&0x1F;
        int spsSize = buf2[7];
        uint8_t *sps = malloc(spsSize);
        memcpy(sps, buf2+8, spsSize);
        
        uint8_t *buf3 = buf2+8+spsSize;
        
        int ppsNum = buf3[0];
        int ppsSize = buf3[2];
        uint8_t *pps = malloc(ppsSize);
        memcpy(pps, buf3+3, ppsSize);
        
        const uint8_t* const parameterSetPointers[2] = { sps, pps };
        const size_t parameterSetSizes[2] = { spsSize, ppsSize };
        
        
        OSStatus status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault, 2,parameterSetPointers,parameterSetSizes, naluLength, &_decoderFormatDescription);
        if(status == noErr) {
            
            NSDictionary* destinationPixelBufferAttributes = @{
                                                               (id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange],
                                                               //硬解必须是 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
                                                               //                                                           或者是kCVPixelFormatType_420YpCbCr8Planar
                                                               //因为iOS是  nv12  其他是nv21  288  512
                                                               (id)kCVPixelBufferWidthKey : [NSNumber numberWithInt:512*2],
                                                               (id)kCVPixelBufferHeightKey : [NSNumber numberWithInt:288*2],
                                                               //这里款高和编码反的
                                                               (id)kCVPixelBufferOpenGLCompatibilityKey : [NSNumber numberWithBool:YES]
                                                               };
            VTDecompressionOutputCallbackRecord callBackRecord;
            callBackRecord.decompressionOutputCallback = didDecompress;
            callBackRecord.decompressionOutputRefCon = (__bridge void *)self;
            status = VTDecompressionSessionCreate(kCFAllocatorDefault,
                                                  _decoderFormatDescription,
                                                  NULL,
                                                  (__bridge CFDictionaryRef)destinationPixelBufferAttributes,
                                                  &callBackRecord,
                                                  &_deocderSession);
            VTSessionSetProperty(_deocderSession, kVTDecompressionPropertyKey_ThreadCount, (__bridge CFTypeRef)[NSNumber numberWithInt:1]);
            VTSessionSetProperty(_deocderSession, kVTDecompressionPropertyKey_RealTime, kCFBooleanTrue);

        } else {
            NSLog(@"IOS8VT: reset decoder session failed status=%d", status);
        }
        
        return YES;
        
    }else if (buf[1] == 1){
        // One or more NALUs
        
    }
    
    return YES;
}


#pragma mark - private methods
-(FLV_HEADER)flv_prob{
    FLV_HEADER flv_header;
    fseek(_file, 0, SEEK_SET);
    fread(&flv_header, 1, sizeof(FLV_HEADER), _file);
    
    if (flv_header.Signature[0] == 'F' && flv_header.Signature[1] == 'L' && flv_header.Signature[2] == 'V') {
        printf("Format: FLV\n");
    }
    printf("Version: %d\n",flv_header.Version);
    
    //存在音频
    if (flv_header.Flags>>2 == 1) {
        
        if ((flv_header.Flags&0x01) == 1) {
            //存在视频
            printf("Flags: Audio Video\n");
        }else{
            printf("Flags: Audio \n");
        }
    }else{
        printf("Flags: None \n");
    }
    printf("DataOffset: %d \n",CFSwapInt32BigToHost(flv_header.DataOffset));
    return flv_header;
}

#pragma mark - setters and getters
-(AAPLEAGLLayer *)appleGLLayer{
    if (_appleGLLayer == nil) {
        _appleGLLayer = [[AAPLEAGLLayer alloc] initWithFrame:self.bounds];
    }
    return _appleGLLayer;
}

@end
