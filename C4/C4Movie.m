// Copyright © 2012 Travis Kirton
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

#import "C4Movie.h"
#import "C4UIMovieControl.h"

@interface C4Movie() {
    void *rateContext, *currentItemContext, *playerItemStatusContext;
}
@property(nonatomic) NSURL *movieURL;
@property(nonatomic, strong) AVPlayerLayer *playerLayer;
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) AVPlayerItem *playerItem;
@end

@implementation C4Movie

+ (instancetype)movieNamed:(NSString *)movieName {
    C4Movie *newMovie = [[C4Movie alloc] initWithMovieName:movieName frame:CGRectZero];
    return newMovie;
}

+ (instancetype)movieNamed:(NSString *)movieName inFrame:(CGRect)movieFrame {
    C4Movie *newMovie = [[C4Movie alloc] initWithMovieName:movieName frame:movieFrame];
    return newMovie;
}

+ (instancetype)movieWithURL:(NSString *)url {
    C4Movie *newMovie = [[C4Movie alloc] initWithURL:[NSURL URLWithString:url] frame:CGRectZero];
    return newMovie;
}

+ (instancetype)movieWithURL:(NSString *)url frame:(CGRect)movieFrame {
    C4Movie *newMovie = [[C4Movie alloc] initWithURL:[NSURL URLWithString:url] frame:movieFrame];
    return newMovie;
}

-(id)initWithMovieName:(NSString *)movieName {
    movieName = [movieName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self = [self initWithMovieName:movieName frame:CGRectZero];
    return self;
}

-(id)initWithMovieName:(NSString *)movieName frame:(CGRect)movieFrame {
    NSArray *movieNameComponents = [movieName componentsSeparatedByString:@"."];
    self.movieURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:movieNameComponents[0] ofType:movieNameComponents[1]]];
    self = [self initWithURL:self.movieURL frame:movieFrame];
    return self;
}

-(id)initWithURL:(NSURL *)url {
    self = [self initWithURL:url frame:CGRectZero];
    return self;
}

-(id)initWithURL:(NSURL *)url frame:(CGRect)frame {
    self = [super initWithView:[[C4UIMovieControl alloc] initWithFrame:frame]];
    if(self != nil) {
        _volume = 1.0f;
        self.shouldAutoplay = NO;
        _movieURL = url;
        if([_movieURL scheme]) {
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:_movieURL options:nil];
            C4Assert(asset != nil, @"The asset (%@) you tried to create couldn't be initialized", _movieURL);
            
            NSArray *requestedKeys = @[@"duration", @"playable"];
            for (NSString *key in requestedKeys) {
                NSError *error = nil;
                AVKeyValueStatus keyStatus = [asset statusOfValueForKey:key error:&error];
                if (keyStatus == AVKeyValueStatusFailed) {
                    [self assetFailedToPrepareForPlayback:error];
                    return nil;
                }
            }
            
            if (asset.playable == NO) {
                NSError *error = [NSError errorWithDomain:@"C4Movie asset cannot be played" code:0 userInfo:nil];
                [self assetFailedToPrepareForPlayback:error];
                return nil;
            }
            
            [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler: ^(void) {
                dispatch_async( dispatch_get_main_queue(), ^(void) {
                    [self prepareToPlayAsset:asset];
                });
            }];
            [self completeSetupWithAsset:asset frame:frame];
        }
    }
    return self;
}

-(void)completeSetupWithAsset:(AVURLAsset *)asset frame:(CGRect)movieFrame {
    NSArray *assetTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    
    if(CGRectEqualToRect(movieFrame, CGRectZero)) {
        AVAssetTrack *videoTrack = assetTracks[0];
        _originalMovieSize = videoTrack.naturalSize;
        _originalMovieRatio = _originalMovieSize.width / _originalMovieSize.height;
        movieFrame.size = _originalMovieSize;
        self.frame = movieFrame;
    }
    self.backgroundColor = [UIColor clearColor];
    _constrainsProportions = YES;
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndPause; // currently C4Movie doesn't handle queues
    self.rate = 1.0f;
    
    [self setup];
}

- (CMTime)playerItemDuration {
    AVPlayerItem *thePlayerItem = [_player currentItem];
    if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay) {
        return(_playerItem.duration);
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
    self.player.rate = rate;
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.view.layer;
}

-(void)assetFailedToPrepareForPlayback:(NSError *)error {
    C4Log(@"The movie you tried to load failed...\n\n%@\n\nConfirm the following:\n1)the URL you used is correct.\n2)make sure your device is connected to the internet",error);
}

-(void)prepareToPlayAsset:(AVURLAsset *)asset {
    rateContext = &rateContext;
    currentItemContext = &currentItemContext;
    playerItemStatusContext = &playerItemStatusContext;
    
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
    
    [self listenFor:AVPlayerItemTimeJumpedNotification andRun:^(NSNotification *n) {
        [self currentTimeChanged];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
    
    if (self.player == nil) {
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.playerItem]];
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [self.player addObserver:self
                      forKeyPath:@"currentItem"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:currentItemContext];
    }
    
    NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
    NSMutableArray *allAudioTrackInputParameters = [@[] mutableCopy];
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
        
        AVPlayerStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerStatusUnknown:
                //C4Log(@"AVPlayerStatusUnknown");
                break;
            case AVPlayerStatusReadyToPlay:
                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
                //C4Log(@"AVPlayerStatusReadyToPlay");
                self.playerLayer.hidden = NO;
                
                /* Set the C4PlayerLayer on the view to allow the AVPlayer object to display
                 its content. */
                [self.playerLayer setPlayer:_player];
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
        AVPlayerItem *newPlayerItem = change[NSKeyValueChangeNewKey];
        //C4Log(@"currentItemContext");
        
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

-(void)playerItemDidReachEnd:(NSNotification*)aNotification {
    aNotification = aNotification;
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
    [self.player play];
}

-(void)pause {
    [self.player pause];
}

-(CGFloat)width {
    return self.bounds.size.width;
}

-(void)setWidth:(CGFloat)width {
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    if(_constrainsProportions) newFrame.size.height = width/self.originalMovieRatio;
    self.frame = newFrame;
}

-(CGFloat)height {
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height {
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    if(_constrainsProportions) newFrame.size.width = height * self.originalMovieRatio;
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


#pragma mark Templates

+ (C4Template *)defaultTemplate {
    static C4Template* template;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        template = [C4Template templateFromBaseTemplate:[super defaultTemplate] forClass:self];
    });
    return template;
}

@end
