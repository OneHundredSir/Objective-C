//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微博:http://weibo.com/u/6013257513?is_all=1
//  QQ技术讨论交流群 : 365204530
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda




#import <QuartzCore/QuartzCore.h>
#import "DemoViewController.h"
#import "SoundBankPlayer.h"
#import <OpenAL/OpenAL.h>
@implementation DemoViewController
{
	SoundBankPlayer *_soundBankPlayer;
	NSTimer *_timer;
	BOOL _playingArpeggio;
	NSArray *_arpeggioNotes;
	NSUInteger _arpeggioIndex;
	CFTimeInterval _arpeggioStartTime;
	CFTimeInterval _arpeggioDelay;
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
		_playingArpeggio = NO;

		// Create the player and tell it which sound bank to use.
        device = alcOpenDevice(NULL);

//        context=alcCreateContext(device, NULL);
		_soundBankPlayer = [[SoundBankPlayer alloc] init];
		[_soundBankPlayer setSoundBank:@"Piano"];
//        [_soundBankPlayer setSingleSoundBank:@"b3.caf"];

		// We use a timer to play arpeggios.
		[self startTimer];
	}
	return self;
}

- (void)dealloc
{
	[self stopTimer];
}

- (IBAction)strumCMajorChord
{
	[_soundBankPlayer queueNote:48 gain:0.4f];
	[_soundBankPlayer queueNote:55 gain:0.4f];
	[_soundBankPlayer queueNote:64 gain:0.4f];
	[_soundBankPlayer playQueuedNotes];
}

- (IBAction)arpeggiateCMajorChord
{
	[self playArpeggioWithNotes:@[@48, @55, @64] delay:0.05f];
}

- (IBAction)strumAMinorChord
{
	[_soundBankPlayer queueNote:45 gain:0.4f];
	[_soundBankPlayer queueNote:52 gain:0.4f];
	[_soundBankPlayer queueNote:60 gain:0.4f];
	[_soundBankPlayer queueNote:67 gain:0.4f];
	[_soundBankPlayer playQueuedNotes];
}

- (IBAction)arpeggiateAMinorChord
{
	[self playArpeggioWithNotes:@[@33, @45, @52, @60, @67] delay:0.1f];
}

- (void)playArpeggioWithNotes:(NSArray *)notes delay:(CFTimeInterval)delay
{
	if (!_playingArpeggio)
	{
		_playingArpeggio = YES;
		_arpeggioNotes = [notes copy];
		_arpeggioIndex = 0;
		_arpeggioDelay = delay;
		_arpeggioStartTime = CACurrentMediaTime();
	}
}

- (void)startTimer
{
	_timer = [NSTimer scheduledTimerWithTimeInterval:0.05f  // 50 ms
											  target:self
										    selector:@selector(handleTimer:)
										    userInfo:nil
											 repeats:YES];
}

- (void)stopTimer
{
	if (_timer != nil && [_timer isValid])
	{
		[_timer invalidate];
		_timer = nil;
	}
}

- (void)handleTimer:(NSTimer *)timer
{
	if (_playingArpeggio)
	{
		// Play each note of the arpeggio after "arpeggioDelay" seconds.
		CFTimeInterval now = CACurrentMediaTime();
		if (now - _arpeggioStartTime >= _arpeggioDelay)
		{
			NSNumber *number = _arpeggioNotes[_arpeggioIndex];
			[_soundBankPlayer noteOn:[number intValue] gain:0.4f];

			_arpeggioIndex += 1;
			if (_arpeggioIndex == [_arpeggioNotes count])
			{
				_playingArpeggio = NO;
				_arpeggioNotes = nil;
			}
			else  // schedule next note
			{
				_arpeggioStartTime = now;
			}
		}
	}
}

static ALCdevice *device = NULL;
static ALCcontext *context = NULL;
- (IBAction)changeToOther:(UIButton *)sender
{
    if (device == NULL) {
        device = [_soundBankPlayer getALCdevice];
    }
    

}



- (IBAction)backToPlayer:(id)sender
{
    if (device != NULL) {
        _soundBankPlayer = [SoundBankPlayer resetWithDevice:device andContext:context AndPlaySoundName:@"Piano"];
//        [_soundBankPlayer resetWithDevice:device];
        
//        [_soundBankPlayer setSoundBank:@"Piano"];
//        [self startTimer];
    }else
        NSAssert(device, @"device是空的");
    
    
}



@end
