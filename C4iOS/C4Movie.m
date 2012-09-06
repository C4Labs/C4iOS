//
//  C4VideoPlayerView.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-11-19.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4Movie.h"
#import "C4YouTubeURLParser.h"

@interface C4Movie()
- (CMTime)playerItemDuration;
- (void)assetFailedToPrepareForPlayback:(NSError *)error;
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys;

//-(void)_setShadowOffset:(NSValue *)shadowOffset;
//-(void)_setShadowRadius:(NSNumber *)shadowRadius;
//-(void)_setShadowOpacity:(NSNumber *)shadowOpacity;
//-(void)_setShadowColor:(UIColor *)shadowColor;
//-(void)_setShadowPath:(id)shadowPath;

@property (readonly, nonatomic, strong) C4MovieLayer *playerLayer;
@property (readwrite, nonatomic, strong) AVPlayer *player;
@property (readwrite, nonatomic, strong) AVPlayerItem *playerItem;
@property (readwrite, atomic) BOOL shouldAutoreverse;
@end

@implementation C4Movie
@synthesize player;
@synthesize playerItem;
@synthesize rate = _rate;
//@synthesize shadowColor = _shadowColor;
//@synthesize shadowOffset = _shadowOffset;
//@synthesize shadowRadius = _shadowRadius;
//@synthesize shadowOpacity = _shadowOpacity;
//@synthesize shadowPath = _shadowPath;
@synthesize originalMovieSize = _originalMovieSize;
@synthesize originalMovieRatio = _originalMovieRatio;
@synthesize width = _width;
@synthesize height = _height;
@synthesize isPlaying;
@synthesize loops;
@synthesize shouldAutoplay;
@synthesize audioMix = _audioMix;
@synthesize volume = _volume;
@synthesize shouldAutoreverse = _shouldAutoreverse;
@synthesize animationOptions = _animationOptions;
@synthesize size = _size;

+(C4Movie *)movieNamed:(NSString *)movieName {
    C4Movie *newMovie = [[C4Movie alloc] initWithMovieName:movieName frame:CGRectZero];
    return newMovie;
}

+(C4Movie *)movieNamed:(NSString *)movieName inFrame:(CGRect)movieFrame {
    C4Movie *newMovie = [[C4Movie alloc] initWithMovieName:movieName frame:movieFrame];
    return newMovie;
}

+(C4Movie *)movieWithURL:(NSString *)url {
    C4Movie *newMovie = [[C4Movie alloc] initWithURL:[NSURL URLWithString:url] frame:CGRectZero];
    return newMovie;
}

+(C4Movie *)movieWithURL:(NSString *)url frame:(CGRect)movieFrame {
    C4Movie *newMovie = [[C4Movie alloc] initWithURL:[NSURL URLWithString:url] frame:movieFrame];
    return newMovie;
}

+(C4Movie *)movieWithYouTubeURL:(NSString *)youtubeURL {
    C4Movie *newMovie = [[C4Movie alloc] initWithYouTubeURL:youtubeURL];
    return newMovie;
}

+(C4Movie *)movieWithYouTubeURL:(NSString *)youtubeURL size:(C4YouTubeSize)movieSize {
    C4Movie *newMovie = [[C4Movie alloc] initWithYouTubeURL:youtubeURL size:movieSize];
    return newMovie;
}

+(C4Movie *)movieWithYouTubeURL:(NSString *)youtubeURL frame:(CGRect)movieFrame {
    C4Movie *newMovie = [[C4Movie alloc] initWithYouTubeURL:youtubeURL frame:movieFrame];
    return newMovie;
}

+(C4Movie *)movieWithYouTubeURL:(NSString *)youtubeURL size:(C4YouTubeSize)movieSize frame:(CGRect)movieFrame {
    C4Movie *newMovie = [[C4Movie alloc] initWithYouTubeURL:youtubeURL size:movieSize frame:movieFrame];
    return newMovie;
}

-(id)initWithYouTubeURL:(NSString *)url {
    self = [self initWithYouTubeURL:url size:YT1080 frame:CGRectZero];
    return  self;
}

-(id)initWithYouTubeURL:(NSString *)url frame:(CGRect)movieFrame {
    self = [self initWithYouTubeURL:url size:YT1080 frame:movieFrame];
    return self;
}

-(id)initWithYouTubeURL:(NSString *)url size:(C4YouTubeSize)ytMovieSize {
    self = [self initWithYouTubeURL:url size:ytMovieSize frame:CGRectZero];
    return self;
}
-(id)initWithYouTubeURL:(NSString *)url size:(C4YouTubeSize)ytMovieSize frame:(CGRect)movieFrame {
    NSURL *newURL = [NSURL URLWithString:url];
    C4YouTubeURLParser *parser = [C4YouTubeURLParser parserWithURL:newURL];
    NSURL *actualURL;
    for (int i = ytMovieSize; i >= 0; i--) {
        switch (i) {
            case YT1080:
                actualURL = parser.large1080;
                break;
            case YT720:
                actualURL = parser.large720;
                break;
            case YTMEDIUM:
                actualURL = parser.medium;
                break;
            default:
                actualURL = parser.small;
                break;
        }
        if(actualURL != nil) break;
    }
    C4Assert(actualURL != nil, @"The C4YouTubeURLParser could not find a valid url for any of the sizes: small, medium, 720p, or 1080p");
    self = [self initWithURL:actualURL frame:movieFrame];
    return self;
}

-(id)initWithMovieName:(NSString *)movieName {
    self = [self initWithMovieName:movieName frame:CGRectZero];
    return self;
}

-(id)initWithMovieName:(NSString *)movieName frame:(CGRect)movieFrame {
    NSArray *movieNameComponents = [movieName componentsSeparatedByString:@"."];
    movieURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:[movieNameComponents objectAtIndex:0]
                                                                                  ofType:[movieNameComponents objectAtIndex:1]]];
    self = [self initWithURL:movieURL frame:movieFrame];
    return self;
}

-(id)initWithURL:(NSURL *)url {
    self = [self initWithURL:url frame:CGRectZero];
    return self;
}

-(id)initWithURL:(NSURL *)url frame:(CGRect)movieFrame {
    self = [super init];
    if(self != nil) {
        _volume = 1.0f;
        self.shouldAutoplay = NO;
        movieURL = url;
        if([movieURL scheme]) {
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:movieURL options:nil];
            C4Assert(asset != nil, @"The asset (%@) you tried to create couldn't be initialized", movieURL);
            NSArray *requestedKeys = [NSArray arrayWithObjects:@"duration", @"playable", nil];
            [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler: ^(void) {
                dispatch_async( dispatch_get_main_queue(), ^(void) {
                    [self prepareToPlayAsset:asset withKeys:requestedKeys];
                });
            }];
            
            AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            _originalMovieSize = videoTrack.naturalSize;
            _originalMovieRatio = _originalMovieSize.width / _originalMovieSize.height;
            self.player.actionAtItemEnd = AVPlayerActionAtItemEndPause; // currently C4Movie doesn't handle queues
            self.player.allowsAirPlayVideo = NO;
        }
        
        _rate = 1.0f;
        self.backgroundColor = [UIColor clearColor];
        if(CGRectEqualToRect(movieFrame, CGRectZero)) {
            movieFrame.size = _originalMovieSize;
        }
        self.frame = movieFrame;
        [self setup];
    }
    self.volume = _volume;
    return self;
}

-(void)dealloc {
    self.player = nil;
    self.playerItem = nil;
}

- (CMTime)playerItemDuration {
	AVPlayerItem *thePlayerItem = [player currentItem];
	if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay) {                
		return(playerItem.duration);
	}
	return(kCMTimeInvalid);
}

- (BOOL)isPlaying {
	return (self.player.rate != 0.0f);
}

-(CGFloat)rate {
    return self.player.rate;
}

-(void)setRate:(CGFloat)rate {
    BOOL wasPlaying = self.isPlaying;
    if(wasPlaying == YES) {
        [self pause];
    }
    _rate = rate;
    if(wasPlaying == YES) {
        [self play];
    }
}

+ (Class)layerClass
{
	return [C4MovieLayer class];
}

- (C4MovieLayer *)playerLayer
{
	return (C4MovieLayer *)self.layer;
}

-(void)assetFailedToPrepareForPlayback:(NSError *)error {
    C4Log(@"The movie you tried to load failed: %@",error);
}

-(void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys {
    rateContext = &rateContext;
    currentItemContext = &currentItemContext;
    playerItemStatusContext = &playerItemStatusContext;
    
	for (NSString *key in requestedKeys) {
		NSError *error = nil;
		AVKeyValueStatus keyStatus = [asset statusOfValueForKey:key error:&error];
		if (keyStatus == AVKeyValueStatusFailed) {
			[self assetFailedToPrepareForPlayback:error];
			return;
		}
	}
    
    if (asset.playable == NO) {
        NSError *error = [NSError errorWithDomain:@"C4Movie asset cannot be played" code:0 userInfo:nil];
        [self assetFailedToPrepareForPlayback:error];
        return;
    }
	
    if (self.playerItem != nil) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];            
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.playerItem];
    }
	
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    [self.playerItem addObserver:self 
                      forKeyPath:@"status" 
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:playerItemStatusContext];

    [self listenFor:AVPlayerItemTimeJumpedNotification andRunMethod:@"currentTimeChanged"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
    
    if (self.player == nil) {
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.playerItem]];	
		player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [self.player addObserver:self 
                      forKeyPath:@"currentItem" 
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:currentItemContext];
    }

    NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
    NSMutableArray *allAudioTrackInputParameters = [NSMutableArray array];
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *trackInputParameters =[AVMutableAudioMixInputParameters audioMixInputParameters];
        [trackInputParameters setTrackID:[track trackID]];
        [allAudioTrackInputParameters addObject:trackInputParameters];
    }
    
    AVMutableAudioMix *newAudioMix = [AVMutableAudioMix audioMix];
    [newAudioMix setInputParameters:allAudioTrackInputParameters];
    _audioMix = newAudioMix;
    self.playerItem.audioMix = self.audioMix;
    
    if (self.player.currentItem != self.playerItem) {
        [[self player] replaceCurrentItemWithPlayerItem:self.playerItem];
    }
    //explicitly set the volume here, it needs to be set after the audio mix has been created
    self.volume = self.volume;
}

- (void)observeValueForKeyPath:(NSString*) path 
                      ofObject:(id)object 
                        change:(NSDictionary*)change 
                       context:(void*)context
{
	/* AVPlayerItem "status" property value observer. */
	if (context == playerItemStatusContext)
	{
        
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because 
                 it has not tried to load new media resources for playback */
            case AVPlayerStatusUnknown:
//                    C4Log(@"AVPlayerStatusUnknown");
                break;
            case AVPlayerStatusReadyToPlay:
                /* Once the AVPlayerItem becomes ready to play, i.e. 
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
                //                C4Log(@"AVPlayerStatusReadyToPlay");
                self.playerLayer.hidden = NO;
                
                /* Set the C4PlayerLayer on the view to allow the AVPlayer object to display
                 its content. */	
                [self.playerLayer setPlayer:player];
                if(self.shouldAutoplay == YES) {
                    [self play];
                }
                [self postNotification:@"movieIsReadyForPlayback"];
                break;
            case AVPlayerStatusFailed:{
                AVPlayerItem *thePlayerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:thePlayerItem.error];
                C4Assert(NO,@"The asset you tried to load couldn't be prepared for playback, check its filename and type, maybe the compression is wrong...");
            }
                break;
            default:
                C4Assert(NO,@"Strange... the player's status is none of: AVPlayerStatusUnknown, AVPlayerStatusReadyToPlay, AVPlayerStatusFailed");
                break;
        }
	}
	/* AVPlayer "currentItem" property observer. 
     Called when the AVPlayer replaceCurrentItemWithPlayerItem: 
     replacement will/did occur. */
	else if (context == currentItemContext)
	{
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        //        C4Log(@"currentItemContext");
        
        /* New player item null? */
        if (newPlayerItem == (id)[NSNull null]) {
        }
        else {
            /* Set the AVPlayer for which the player layer displays visual output. */
            [self.playerLayer setPlayer:self.player];
            
            /* Specifies that the player should preserve the video’s aspect ratio and 
             fit the video within the layer’s bounds. */
            self.playerLayer.videoGravity = AVLayerVideoGravityResize;
        }
	}
	else {
		[super observeValueForKeyPath:path ofObject:object change:change context:context];
	}
    
    return;
}

- (void) playerItemDidReachEnd:(NSNotification*) aNotification {
    [self postNotification:@"reachedEnd"];
    if(self.loops) {
        if(self.player.rate < 0.0f)
            [self seekToTime:self.duration];
        else
            [self seekToTime:0.0f];
        [self play];
    }
    [self reachedEnd];
}

-(void)play {
    self.player.rate = _rate;
}

-(void)pause {
    [self.player pause];
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    /*
     important: we have to intercept the setting of AUTOREVERSE for the case of reversing 1 time
     i.e. reversing without having set REPEAT
     
     UIView animation will flicker if we don't do this...
     */
    
    //shapelayer animation options should be set first
    self.playerLayer.animationOptions = animationOptions;
    
    //strip the autoreverse from the control's animation options if needed
    if ((animationOptions & AUTOREVERSE) == AUTOREVERSE) {
        self.shouldAutoreverse = YES;
        animationOptions &= ~AUTOREVERSE;
    }
    _animationOptions = animationOptions | BEGINCURRENT;
}


-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self.playerLayer containsPoint:point];
}

-(CGFloat)width {
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width {
    _width = width;
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    newFrame.size.height = width/self.originalMovieRatio;
    self.frame = newFrame;
}

-(CGFloat)height {
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height {
    _height = height;
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    newFrame.size.width = height * self.originalMovieRatio;
    self.frame = newFrame;
}

-(CGSize)size {
    return self.frame.size;
}

-(void)setSize:(CGSize)size {
    CGRect newFrame = CGRectZero;
    newFrame.origin = self.origin;
    newFrame.size = size;
    self.frame = newFrame;
}

-(CGFloat)currentTime {
    return (CGFloat)CMTimeGetSeconds(self.player.currentTime);
}

-(CGFloat)duration {
    return (CGFloat)CMTimeGetSeconds(self.playerItem.duration);
}

/* clamps to the nearest frame, based on the movie's time scale */
-(void)seekToTime:(CGFloat)time {
    CMTime current = self.player.currentTime;
    CMTime newTime = CMTimeMakeWithSeconds(time, current.timescale);
    CMTimeRange timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(0, current.timescale), self.playerItem.duration);
    CMTimeClampToRange(newTime, timeRange);
    [self.player seekToTime:newTime toleranceBefore:CMTimeMake(1, current.timescale) toleranceAfter:CMTimeMake(1, current.timescale)];
}

-(void)seekByAddingTime:(CGFloat)time {
    [self seekToTime:time + self.currentTime];
}

-(void)reachedEnd {
}

-(void)currentTimeChanged {
}

-(void)setVolume:(CGFloat)volume {
    _volume = volume;
    for(AVMutableAudioMixInputParameters *avmam in self.audioMix.inputParameters) {
        [avmam setVolume:volume atTime:kCMTimeZero];
    }
    self.player.currentItem.audioMix = self.audioMix;
}

@end
