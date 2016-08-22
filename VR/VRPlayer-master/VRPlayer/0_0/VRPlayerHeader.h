//
//  VRPlayerHeader.h
//  VRPlayer
//
//  Created by chengshenggen on 7/19/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#ifndef VRPlayerHeader_h
#define VRPlayerHeader_h

#import <AVFoundation/AVFoundation.h>
#import <pthread.h>
#import <sys/time.h>

#define MAX_AUDIOQ_SIZE (5 * 16 * 1024)
#define MAX_VIDEOQ_SIZE (5 * 256 * 1024)

#define TAG_TYPE_SCRIPT 18
#define TAG_TYPE_AUDIO  8
#define TAG_TYPE_VIDEO  9

#define VIDEO_PICTURE_QUEUE_SIZE 1


//Important!
#pragma pack(1)

typedef struct AVPacket{
    int64_t pts;
    int64_t dts;
    uint8_t *data;
    int   size;
    int   stream_index;
}AVPacket;

typedef struct AVPacketList {
    AVPacket pkt;
    struct AVPacketList *next;
} AVPacketList;

typedef struct {
    Byte Signature[3];
    Byte Version;
    Byte Flags;
    uint DataOffset;
} FLV_HEADER;

typedef struct {
    Byte TagType;
    Byte DataSize[3];
    Byte Timestamp[3];
    Byte TimestampExtended;
    Byte Reserved[3];
} TAG_HEADER;

typedef struct PacketQueue{
    AVPacketList *first_pkt,*last_pkt;
    int nb_packets;
    int size;
    pthread_mutex_t mutex;
    pthread_cond_t cond;
}PacketQueue;

static void packet_queue_init(PacketQueue *q){
//    q = malloc(sizeof(PacketQueue));
    memset(q, 0, sizeof(PacketQueue));

    pthread_mutex_init(&q->mutex, NULL);
    pthread_cond_init(&q->cond, NULL);
}

static int packet_queue_put(PacketQueue *q,AVPacket *pkt){
    AVPacketList *pkt1;
    pkt1 = malloc(sizeof(AVPacketList));
    
    if (!pkt1) {
        return -1;
    }
    pkt1->pkt = *pkt;
    pkt1->next = NULL;
    pthread_mutex_lock(&q->mutex);
    if (!q->last_pkt) {
        q->first_pkt = pkt1;
    }else{
        q->last_pkt->next = pkt1;
    }
    q->last_pkt = pkt1;
    q->nb_packets++;
    q->size += pkt1->pkt.size;
    pthread_cond_signal(&q->cond);
    pthread_mutex_unlock(&q->mutex);
    
    return 0;
}

static int packet_queue_get(PacketQueue *q,AVPacket *pkt,int block){
    AVPacketList *pkt1;
    int ret;
    pthread_mutex_lock(&q->mutex);
    for (; ; ) {
        pkt1 = q->first_pkt;
        if (pkt1) {
            q->first_pkt = pkt1->next;
            if (!q->first_pkt) {
                q->last_pkt = NULL;
            }
            q->nb_packets--;
            q->size -= pkt1->pkt.size;
            *pkt = pkt1->pkt;
            free(pkt1);
            ret = 1;
            break;
        }else if (!block){
            ret = 0;
            break;
        }else{
            ret = -1;
            struct timeval now;
            struct timespec outtime;
            gettimeofday(&now, NULL);
            
            outtime.tv_sec = now.tv_sec + 10;
            outtime.tv_nsec = now.tv_usec * 1000;
            pthread_cond_timedwait(&q->cond, &q->mutex, &outtime);
//            pthread_cond_wait(&q->cond, &q->mutex);
            break;
        }
    }
    pthread_mutex_unlock(&q->mutex);

    return ret;
}

typedef struct VideoPicture{
    CVPixelBufferRef pixel;
    
}VideoPicture;

typedef struct VideoState{
    
    int video_stream;
    PacketQueue videoq;
    
    int audio_stream;
    PacketQueue audioq;
    
    int video_width,video_height;
    
    int pictq_size, pictq_rindex, pictq_windex;
    VideoPicture pictq[VIDEO_PICTURE_QUEUE_SIZE];
    
    pthread_mutex_t pictq_mutex;
    pthread_cond_t pictq_cond;
    
}VideoState;

//reverse_bytes - turn a BigEndian byte array into a LittleEndian integer
uint reverse_bytes(Byte *p, char c) {
    int r = 0;
    int i;
    for (i=0; i<c; i++)
        r |= ( *(p+i) << (((c-1)*8)-8*i));
    return r;
}

#endif /* VRPlayerHeader_h */
