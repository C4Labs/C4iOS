//
//  C4VideoPlayerView.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-11-19.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4Movie.h"

@interface C4Movie()
- (CMTime)playerItemDuration;
- (void)assetFailedToPrepareForPlayback:(NSError *)error;
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys;

-(void)_setShadowOffset:(NSValue *)shadowOffset;
-(void)_setShadowRadius:(NSNumber *)shadowRadius;
-(void)_setShadowOpacity:(NSNumber *)shadowOpacity;
-(void)_setShadowColor:(UIColor *)shadowColor;
-(void)_setShadowPath:(id)shadowPath;

@property (strong, nonatomic) AVPlayer *player;
@property (strong) AVPlayerItem *playerItem;
@end

@implementation C4Movie
@synthesize player;
@synthesize playerItem;
@synthesize rate = _rate;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize shadowRadius = _shadowRadius;
@synthesize shadowOpacity = _shadowOpacity;
@synthesize shadowPath = _shadowPath;
@synthesize originalMovieSize = _originalMovieSize;
@synthesize originalMovieRatio = _originalMovieRatio;
@synthesize width = _width;
@synthesize height = _height;
@synthesize isPlaying;
@synthesize loops;
@synthesize shouldAutoplay;

+(C4Movie *)movieNamed:(NSString *)movieName {
    return [[C4Movie alloc] initWithMovieName:movieName];
}

+(C4Movie *)movieNamed:(NSString *)movieName inFrame:(CGRect)movieFrame {
    return [C4Movie movieNamed:movieName inFrame:movieFrame];
}


-(id)initWithMovieName:(NSString *)movieName {
    self = [super init];
    if(self != nil) {        
        self.shouldAutoplay = YES;
        NSArray *movieNameComponents = [movieName componentsSeparatedByString:@"."];
        movieURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:[movieNameComponents objectAtIndex:0]
                                                                                      ofType:[movieNameComponents objectAtIndex:1]]];
        if([movieURL scheme]) {
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:movieURL options:nil];
            NSAssert(asset != nil, @"The asset you tried to create couldn't be initialized");
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
        self.backgroundColor = [UIColor blackColor];
        CGRect newFrame = CGRectZero;
        newFrame.size = _originalMovieSize;
        self.frame = newFrame;
    }
    return self;
}

-(id)initWithMovieName:(NSString *)movieName andFrame:(CGRect)movieFrame {
    self = [super init];
    if(self != nil) {        
        NSArray *movieNameComponents = [movieName componentsSeparatedByString:@"."];
        movieURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:[movieNameComponents objectAtIndex:0]
                                                                                      ofType:[movieNameComponents objectAtIndex:1]]];
        if([movieURL scheme]) {
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:movieURL options:nil];
            NSAssert(asset != nil, @"The asset you tried to create couldn't be initialized");
            NSArray *requestedKeys = [NSArray arrayWithObjects:@"duration", @"playable", nil];
            [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler: ^(void) {		 
                dispatch_async( dispatch_get_main_queue(), ^(void) {
                    [self prepareToPlayAsset:asset withKeys:requestedKeys];
                });
            }];

            AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            _originalMovieSize = videoTrack.naturalSize;
            _originalMovieRatio = _originalMovieSize.width / _originalMovieSize.height;
        }

        self.backgroundColor = [UIColor blackColor];        
        self.frame = movieFrame;
    }
    return self;
}

- (CMTime)playerItemDuration {
	AVPlayerItem *thePlayerItem = [player currentItem];
	if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay) {                
		return(playerItem.duration);
	}
	return(kCMTimeInvalid);
}

- (BOOL)isPlaying {
	return (self.rate == 0.0f);
}

-(CGFloat)rate {
    return self.player.rate;
}

-(void)setRate:(CGFloat)rate {
    _rate = rate;
    if(self.isPlaying)
        self.player.rate = rate;
}

+ (Class)layerClass
{
	return [C4PlayerLayer class];
}

- (C4PlayerLayer *)playerLayer
{
	return (C4PlayerLayer *)self.layer;
}

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    /* Display the error. */
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
														message:[error localizedFailureReason]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
}

- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    rateContext = &rateContext;
    currentItemContext = &currentItemContext;
    playerItemStatusContext = &playerItemStatusContext;
    
    /* Make sure that the value of each key has loaded successfully. */
	for (NSString *thisKey in requestedKeys)
	{
		NSError *error = nil;
		AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
		if (keyStatus == AVKeyValueStatusFailed)
		{
			[self assetFailedToPrepareForPlayback:error];
			return;
		}
		/* If you are also implementing the use of -[AVAsset cancelLoading], add your code here to bail 
         out properly in the case of cancellation. */
	}
    
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable) 
    {
        /* Generate an error describing the failure. */
		NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
		NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
		NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   localizedDescription, NSLocalizedDescriptionKey, 
								   localizedFailureReason, NSLocalizedFailureReasonErrorKey, 
								   nil];
		NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"C4VideoPlayerController" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
	
	/* At this point we're ready to set up for playback of the asset. */	
    /* Stop observing our prior AVPlayerItem, if we have one. */
    if (self.playerItem)
    {
        /* Remove existing player item key value observers and notifications. */
        
        [self.playerItem removeObserver:self forKeyPath:@"status"];            
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.playerItem];
    }
	
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [self.playerItem addObserver:self 
                      forKeyPath:@"status" 
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:playerItemStatusContext];

    [self listenFor:AVPlayerItemTimeJumpedNotification andRunMethod:@"currentTimeChanged"];
    
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
    
    /* Create new player, if we don't already have one. */
    if (self.player == nil) {
        /* Get a new AVPlayer initialized to play the specified player item. */
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.playerItem]];	
		player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        /* Observe the AVPlayer "currentItem" property to find out when any 
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did 
         occur.*/
        [self.player addObserver:self 
                      forKeyPath:@"currentItem" 
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:currentItemContext];
    }
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (self.player.currentItem != self.playerItem)
    {
        /* Replace the player item with a new player item. The item replacement occurs 
         asynchronously; observe the currentItem property to find out when the 
         replacement will/did occur*/
        //        C4Log(@"replaceCurrentItemWithPlayerItem");
        [[self player] replaceCurrentItemWithPlayerItem:self.playerItem];
    }
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
                //                C4Log(@"AVPlayerStatusUnknown");
                break;
                
            case AVPlayerStatusReadyToPlay:
            {
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
            }
                break;
                
            case AVPlayerStatusFailed:
            {
                C4Log(@"AVPlayerStatusFailed");
                AVPlayerItem *thePlayerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:thePlayerItem.error];
            }
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
        [self seekToTime:0.0f];
        [self play];
    }
    [self reachedEnd];
}

-(void)play {
    self.player.rate = _rate;
}

-(void)setShadowOffset:(CGSize)shadowOffset {
    [self performSelector:@selector(_setShadowOffset:) withObject:[NSValue valueWithCGSize:shadowOffset] afterDelay:self.animationDelay];
}
-(void)_setShadowOffset:(NSValue *)shadowOffset {
    [self.playerLayer animateShadowOffset:[shadowOffset CGSizeValue]];
}

-(void)setShadowRadius:(CGFloat)shadowRadius {
    [self performSelector:@selector(_setShadowRadius:) withObject:[NSNumber numberWithFloat:shadowRadius] afterDelay:self.animationDelay];
}
-(void)_setShadowRadius:(NSNumber *)shadowRadius {
    [self.playerLayer animateShadowRadius:[shadowRadius floatValue]];
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity {
    [self performSelector:@selector(_setShadowOpacity:) withObject:[NSNumber numberWithFloat:shadowOpacity] afterDelay:self.animationDelay];
}
-(void)_setShadowOpacity:(NSNumber *)shadowOpacity {
    [self.playerLayer animateShadowOpacity:[shadowOpacity floatValue]];
}

-(void)setShadowColor:(UIColor *)shadowColor {
    [self performSelector:@selector(_setShadowColor:) withObject:shadowColor afterDelay:self.animationDelay];
}
-(void)_setShadowColor:(UIColor *)shadowColor {
    [self.playerLayer animateShadowColor:shadowColor.CGColor];
}

-(void)setShadowPath:(CGPathRef)shadowPath {
    [self performSelector:@selector(_setShadowPath:) withObject:(__bridge id)shadowPath afterDelay:self.animationDelay];
}
-(void)_setShadowPath:(id)shadowPath {
    [self.playerLayer animateShadowPath:(__bridge CGPathRef)shadowPath];
}

-(void)setAnimationDuration:(CGFloat)animationDuration {
    [super setAnimationDuration:animationDuration];
    self.playerLayer.animationDuration = animationDuration;
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    [super setAnimationOptions:animationOptions];
    self.playerLayer.animationOptions = animationOptions;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self.playerLayer containsPoint:point];
}

-(void)setWidth:(CGFloat)width {
    _width = width;
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    newFrame.size.height = width/self.originalMovieRatio;
    self.frame = newFrame;
}

-(void)setHeight:(CGFloat)height {
    _height = height;
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    newFrame.size.width = height * self.originalMovieRatio;
    self.frame = newFrame;
}

-(CGFloat)currentTime {
    return (CGFloat)CMTimeGetSeconds(self.player.currentTime);
}

-(CGFloat)duration {
    return (CGFloat)CMTimeGetSeconds(self.playerItem.duration);
}

/* clamps to the nearest second */
-(void)seekToTime:(CGFloat)time {
    CMTime newTime = CMTimeMakeWithSeconds(time, 1);
    CMTimeRange timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(0, 1), self.playerItem.duration);
    CMTimeClampToRange(newTime, timeRange);
    [self.player seekToTime:newTime];
}

-(void)seekByAddingTime:(CGFloat)time {
    [self seekToTime:time + self.currentTime];
}

-(void)reachedEnd {
}

-(void)currentTimeChanged {
}

@end
