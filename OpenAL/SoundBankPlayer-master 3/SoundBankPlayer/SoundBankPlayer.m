//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微博:http://weibo.com/u/6013257513?is_all=1
//  QQ技术讨论交流群 : 365204530
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda





#import <AudioToolbox/AudioToolbox.h>
#import "SoundBankPlayer.h"
#import "OpenALSupport.h"

// How many Buffer objects we have. This limits the number of sound samples
// there can be in the sound bank.
#define MAX_BUFFERS 128

// How many Note objects we have. We can handle the entire MIDI range (0-127).
#define NUM_NOTES 128

// Describes a sound sample and connects it to an OpenAL buffer.
typedef struct
{
	float pitch;           // pitch of the note in the sound sample
	CFStringRef filename;  // name of the sound sample file
	ALuint bufferId;       // OpenAL buffer name
	void *data;            // the buffer sample data
}
Buffer;

// Tracks an OpenAL source.
typedef struct
{
	ALuint sourceId;      // OpenAL source name
	int noteIndex;        // which note is playing or -1 if idle
	bool queued;          // is this source queued to be played later?
	NSTimeInterval time;  // time at which this source was enqueued
}
Source;

// Describes a MIDI note and how it will be played.
typedef struct
{
	float pitch;      // pitch of the note
	int bufferIndex;  // which buffer is assigned to this note (-1 = none)
	float panning;    // < 0 is left, 0 is center, > 0 is right
}
Note;

@interface SoundBankPlayer ()
- (void)audioSessionBeginInterruption;
- (void)audioSessionEndInterruption;
@end

@implementation SoundBankPlayer
{
	BOOL _initialized;             // whether OpenAL is initialized
	int _numBuffers;               // the number of active Buffer objects
	int _sampleRate;               // the sample rate of the sound bank

	Buffer _buffers[MAX_BUFFERS];  // list of buffers, not all are active
	Source _sources[NUM_SOURCES];  // list of active sources
	Note _notes[NUM_NOTES];        // the notes indexed by MIDI note number

	ALCcontext *_context;          // OpenAL context
	ALCdevice *_device;            // OpenAL device

	NSString *_soundBankName;      // name of the current sound bank
}

static SoundBankPlayer *tmpSelf;
- (id)init
{
	if ((self = [super init]))
	{
		_initialized = NO;
		_soundBankName = @"";
		_loopNotes = NO;
        //初始化设置notes
		[self initNotes];
		[self setUpAudioSession];
        tmpSelf = self;
	}

	return self;
}

+(SoundBankPlayer *)resetWithDevice:(ALCdevice *)device andContext:(ALCcontext*)context AndPlaySoundName:(NSString *)name
{
    NSLog(@"清空前:这些数据声音缓存%p,note数据%p,声音源%p,内容%p,设备%p",tmpSelf->_buffers,tmpSelf->_notes,tmpSelf->_sources,tmpSelf->_context,tmpSelf->_device);
    if (tmpSelf) {
        [tmpSelf dealloc];
        tmpSelf = nil;
    }
    NSLog(@"这个是数据%p",tmpSelf);
    tmpSelf;
    globalDevice = device;
//    globalContext = context;
    SoundBankPlayer *some = [SoundBankPlayer new];
    NSLog(@"这些数据声音缓存%p,note数据%p,声音源%p,内容%p,设备%p",tmpSelf->_buffers,tmpSelf->_notes,tmpSelf->_sources,tmpSelf->_context,tmpSelf->_device);
    [some setSoundBank:@"Piano"];
    
    return some;
}


- (void)dealloc
{
	[self tearDownAudio];
	[self tearDownAudioSession];
}

- (void)setSoundBank:(NSString *)newSoundBankName
{
    //用来判断这个声音是否和上一个一样,一样就不处理~
	if (![newSoundBankName isEqualToString:_soundBankName])
	{
		_soundBankName = [newSoundBankName copy];

        //播放前先把声音释放了
		[self tearDownAudio];
        //把声音加载
		[self loadSoundBank:_soundBankName];
		[self setUpAudio];
	}
}



- (void)setUpAudio
{
	if (!_initialized)
	{
		[self setUpOpenAL];
		[self initBuffers];
		[self initSources];
		_initialized = YES;
            NSLog(@"这些数据声音缓存%p,note数据%p,声音源%p,内容%p,设备%p",tmpSelf->_buffers,tmpSelf->_notes,tmpSelf->_sources,tmpSelf->_context,tmpSelf->_device);
	}
}

- (void)tearDownAudio
{
	if (_initialized)
	{
        
//        关闭声音源
		[self freeSources];
//        关闭缓存数据
		[self freeBuffers];
		[self tearDownOpenAL];
		_initialized = NO;
	}
}

// 初始化结构体
- (void)initNotes
{
	// Initialize note pitches using equal temperament (12-TET)
	for (int t = 0; t < NUM_NOTES; ++t)
	{
		_notes[t].pitch = 440.0f * pow(2, (t - 69)/12.0);  // A4 = MIDI key 69
		_notes[t].bufferIndex = -1;
		_notes[t].panning = 0.0f;
	}

	// Panning ranges between C3 (-50%) to G5 (+50%)
	for (int t = 0; t < 48; ++t)
		_notes[t].panning = -50.0f;
	for (int t = 48; t < 80; ++t)
		_notes[t].panning = ((((t - 48.0f) / (79 - 48)) * 200.0f) - 100.f) / 2.0f;
	for (int t = 80; t < 128; ++t)
		_notes[t].panning = 50.0f;
}


-(void)loadsingleSoundBank:(NSString *)filename
{
    //路径
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    if (path == nil)
    {
        NSLog(@"path is square '%@'", path);
        return;
    }
    //设置声音的比率
    _sampleRate = 32000;
    
    _numBuffers = _numBuffers + 1;
    if (_numBuffers > MAX_BUFFERS)
        _numBuffers = MAX_BUFFERS;

    int midiStart = 0;
    //在数据最后家一条
    int t = _numBuffers-1;
    _buffers[t].filename = CFBridgingRetain(path);
    int midiEnd = 30;
    int rootKey = 30;
    _buffers[t].pitch = _notes[rootKey].pitch;
    
    if (t == _numBuffers - 1)
        midiEnd = 127;
    
    for (int n = midiStart; n <= midiEnd; ++n)
        _notes[n].bufferIndex = t;
    
    midiStart = midiEnd + 1;
}

- (void)loadSoundBank:(NSString *)filename
{
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    //把路径加载到数组内
	NSArray *array = [NSArray arrayWithContentsOfFile:path];
	if (array == nil)
	{
		NSLog(@"Could not load sound bank '%@'", path);
		return;
	}

	_sampleRate = [(NSString *)array[0] intValue];

	_numBuffers = (int)([array count] - 1) / 3;
	if (_numBuffers > MAX_BUFFERS)
		_numBuffers = MAX_BUFFERS;

	int midiStart = 0;
	for (int t = 0; t < _numBuffers; ++t)
	{
		_buffers[t].filename = CFBridgingRetain(array[1 + t*3]);
		int midiEnd = [(NSString *)array[1 + t*3 + 1] intValue];
		int rootKey = [(NSString *)array[1 + t*3 + 2] intValue];
		_buffers[t].pitch = _notes[rootKey].pitch;

		if (t == _numBuffers - 1)
			midiEnd = 127;

		for (int n = midiStart; n <= midiEnd; ++n)
			_notes[n].bufferIndex = t;

		midiStart = midiEnd + 1;
	}
}

#pragma mark - Audio Session

static void InterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
	SoundBankPlayer *player = (__bridge SoundBankPlayer *)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
		[player audioSessionBeginInterruption];
	else if (inInterruptionState == kAudioSessionEndInterruption)
		[player audioSessionEndInterruption];
}

//注册声音
- (void)registerAudioSessionCategory
{
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    //设置参数
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
}

- (void)setUpAudioSession
{
    //初始化
	AudioSessionInitialize(NULL, NULL, InterruptionListener, (__bridge void *)self);
    //注册声音
	[self registerAudioSessionCategory];
    //让声音有效
	AudioSessionSetActive(true);
}

/**
 *  让播放器声音失效
 */
- (void)tearDownAudioSession
{
	AudioSessionSetActive(false);
}


/**
 *  让打断播放器,有三个点,把活动性停止,清除错误,清楚
 */
- (void)audioSessionBeginInterruption
{
	AudioSessionSetActive(false);

	alGetError();  // clear any errors
    //制作当前环境
	alcMakeContextCurrent(NULL);
    //使内容暂停
	alcSuspendContext(_context);
}

/**
 *  恢复声音
 */
- (void)audioSessionEndInterruption
{
    //重新注册
	[self registerAudioSessionCategory];  // re-register the category
	AudioSessionSetActive(true);
//    清除错误
	alGetError();  // clear any errors
	alcMakeContextCurrent(_context);
	alcProcessContext(_context);
}

#pragma mark - OpenAL
static ALCcontext * globalContext = NULL;
- (void)setUpOpenAL
{
    
    if (globalDevice) {
        _device = globalDevice;
    }else
        _device = alcOpenDevice(NULL);
    
	if (_device != NULL)
	{
		// Set the mixer rate to the same rate as our sound samples.
		// Must be done before creating the context.
//		alcMacOSXMixerOutputRateProc(_sampleRate);

//             _context = alcCreateContext(_device, NULL);
        ALenum error;
        //传了环境进来之后一直获取不了环境了~!!!
        for (int i=0 ; i<200; i++) {
            alGetError();
            NSLog(@"这是设备%p",_device);
             NSLog(@"不断获取内容数据%p",alcCreateContext(_device, NULL));
             _context = alcCreateContext(_device, NULL);
            
            if ((error = alGetError()) )
            {
                NSLog(@"Error generating OpenAL context: %x", error);
                return;
            }
        }
       
        
		if (_context != NULL)
		{
//			alcMakeContextCurrent(_context);
            NSLog(@"这是获取本地环境%d",alcMakeContextCurrent(_context));
		}
	}
}

/**
 *  拆卸openal
 */
- (void)tearDownOpenAL
{
    //把当前的环境设置为空
	alcMakeContextCurrent(NULL);
    //把环境值破坏
	alcDestroyContext(_context);
    //把设备值破坏,终于知道了,这个设备不能破坏,破坏了就不存在了!!!!
//	alcCloseDevice(_device);
}

- (void)initBuffers
{
	for (int t = 0; t < _numBuffers; ++t)
	{
		alGetError();  // clear any errors

		alGenBuffers(1, &_buffers[t].bufferId);
//		每操作一步都会有一个error
        ALenum error;
        
		if ((error = alGetError()) != AL_NO_ERROR)
		{
			NSLog(@"Error generating OpenAL buffer: %x", error);
			return;
		}

		NSString *filename = (__bridge NSString *)_buffers[t].filename;
        if (filename != nil) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
            if (url == nil)
            {
                NSLog(@"Could not find file '%@'", filename);
                return;
            }
            ALenum format;
            ALsizei size;
            ALsizei freq;
            _buffers[t].data = GetOpenALAudioData((__bridge CFURLRef)url, &size, &format, &freq);
            
            if (_buffers[t].data == NULL)
            {
                NSLog(@"Error loading sound");
                return;
            }
            
            alBufferDataStaticProc(_buffers[t].bufferId, format, _buffers[t].data, size, freq);
            
            if ((error = alGetError()) != AL_NO_ERROR)
            {
                NSLog(@"Error attaching audio to buffer: %x", error);
                return;
            }
        }
		

		
	}
}

- (void)freeBuffers
{
	for (int t = 0; t < _numBuffers; ++t)
	{
		alDeleteBuffers(1, &_buffers[t].bufferId);
		free(_buffers[t].data);
		CFRelease(_buffers[t].filename);
		_buffers[t].bufferId = 0;
		_buffers[t].data = NULL;
	}
}


#pragma mark - 这里声音处理不了
- (void)initSources
{
	for (int t = 0; t < NUM_SOURCES; ++t)
	{
		alGetError();  // clear any errors

        //获得声音有问题
		alGenSources(1, &_sources[t].sourceId);
		ALenum error;
		if ((error = alGetError()) != AL_NO_ERROR) 
		{
			NSLog(@"Error generating OpenAL source: %x", error);
			return;
		}

		_sources[t].noteIndex = -1;
		_sources[t].queued = NO;
	}
}


- (void)freeSources
{
	for (int t = 0; t < NUM_SOURCES; ++t)
	{
		alSourceStop(_sources[t].sourceId);
		alSourcei(_sources[t].sourceId, AL_BUFFER, AL_NONE);
		alDeleteSources(1, &_sources[t].sourceId);
	}
}

#pragma mark - Playing Sounds

- (int)findAvailableSource
{
	alGetError();  // clear any errors

	// Find a source that is no longer playing and not currently queued.
	int oldest = 0;
	for (int t = 0; t < NUM_SOURCES; ++t)
	{
		ALint sourceState;
		alGetSourcei(_sources[t].sourceId, AL_SOURCE_STATE, & sourceState);
		if (sourceState != AL_PLAYING && !_sources[t].queued)
			return t;

		if (_sources[t].time < _sources[oldest].time)
			oldest = t;
	}

	// If no free source was found, then forcibly use the oldest.
	alSourceStop(_sources[oldest].sourceId);
	return oldest;
}

- (void)noteOn:(int)midiNoteNumber gain:(float)gain
{
	[self queueNote:midiNoteNumber gain:gain];
	[self playQueuedNotes];
}

- (void)queueNote:(int)midiNoteNumber gain:(float)gain
{
	if (!_initialized)
	{
		NSLog(@"SoundBankPlayer is not initialized yet");
		return;
	}

	Note *note = _notes + midiNoteNumber;
	if (note->bufferIndex != -1)
	{
		int sourceIndex = [self findAvailableSource];
		if (sourceIndex != -1)
		{
			alGetError();  // clear any errors

			Buffer *buffer = _buffers + note->bufferIndex;
			Source *source = _sources + sourceIndex;

			source->time = [NSDate timeIntervalSinceReferenceDate];
			source->noteIndex = midiNoteNumber;
			source->queued = YES;

			alSourcef(source->sourceId, AL_PITCH, note->pitch/buffer->pitch);
			alSourcei(source->sourceId, AL_LOOPING, self.loopNotes ? AL_TRUE : AL_FALSE);
			alSourcef(source->sourceId, AL_REFERENCE_DISTANCE, 100.0f);
			alSourcef(source->sourceId, AL_GAIN, gain);
		
			float sourcePos[] = { note->panning, 0.0f, 0.0f };
			alSourcefv(source->sourceId, AL_POSITION, sourcePos);

			alSourcei(source->sourceId, AL_BUFFER, AL_NONE);
			alSourcei(source->sourceId, AL_BUFFER, buffer->bufferId);

			ALenum error = alGetError();
			if (error != AL_NO_ERROR)
			{
				NSLog(@"Error attaching buffer to source: %x", error);
				return;
			}
		}
	}
}

- (void)playQueuedNotes
{
	ALuint queuedSources[NUM_SOURCES] = { 0 };
	ALsizei count = 0;

	for (int t = 0; t < NUM_SOURCES; ++t)
	{
		if (_sources[t].queued)
		{
			queuedSources[count++] = _sources[t].sourceId;
			_sources[t].queued = NO;
		}
	}

	alSourcePlayv(count, queuedSources);

	ALenum error = alGetError();
	if (error != AL_NO_ERROR)
		NSLog(@"Error starting source: %x", error);
}

- (void)noteOff:(int)midiNoteNumber
{
	if (!_initialized)
	{
		NSLog(@"SoundBankPlayer is not initialized yet");
		return;
	}

	alGetError();  // clear any errors

	for (int t = 0; t < NUM_SOURCES; ++t)
	{
		if (_sources[t].noteIndex == midiNoteNumber)
		{
			alSourceStop(_sources[t].sourceId);

			ALenum error = alGetError();
			if (error != AL_NO_ERROR)
				NSLog(@"Error stopping source: %x", error);
		}
	}
}

- (void)allNotesOff
{
	if (!_initialized)
	{
		NSLog(@"SoundBankPlayer is not initialized yet");
		return;
	}

	alGetError();  // clear any errors

	for (int t = 0; t < NUM_SOURCES; ++t)
	{
		alSourceStop(_sources[t].sourceId);

		ALenum error = alGetError();
		if (error != AL_NO_ERROR)
			NSLog(@"Error stopping source: %x", error);
	}
}


-(ALCdevice*)getALCdevice{
    return _device;
}


-(ALCcontext*)getContext
{
    return _context;
}

static ALCdevice* globalDevice;
-(void)resetWithDevice:(ALCdevice *)resetDevice
{
    globalDevice = resetDevice;
}

@end
