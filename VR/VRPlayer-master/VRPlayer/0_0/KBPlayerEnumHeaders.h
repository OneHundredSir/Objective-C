//
//  KBPlayerEnumHeaders.h
//  KBPlayer
//
//  Created by chengshenggen on 5/23/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#ifndef KBPlayerEnumHeaders_h
#define KBPlayerEnumHeaders_h

typedef enum : NSUInteger {
    KBPlayerStateDefault = 10,  //默认读取正常
    KBPlayerStateReadError = 20, //读取数据错误，不在继续读取
    KBPlayerStateReadingNetWeak = 30,  //正在读取数据，网络状态不好
    KBPlayerStateParseFinshed = 40,  //解码完成。
    KBPlayerStateUserBack = 50,  //用户返回。
    
} KBPlayerState;


typedef enum : NSUInteger {
    KBPlayerPlayingStatePlaying = 10,  //正在播放
    KBPlayerPlayingStatePause = 20, //暂停
    
} KBPlayerPlayingState;

typedef enum : NSUInteger {
    KBPlayerNetTypeNetwork = 10,  //网络视频
    KBPlayerNetTypeLocal = 20, //本地视频
    KBPlayerNetTypeLive = 30,  //直播
} KBPlayerNetType;

typedef enum : NSUInteger {
    KBPlayerVideoTypeNormal = 10,  //普通视频
    KBPlayerVideoTypePanorama = 20, //全景视频
    KBPlayerVideoTypePanoramaUpAndDown = 30,  //上下全景
    
} KBPlayerVideoType;

#endif /* KBPlayerEnumHeaders_h */
