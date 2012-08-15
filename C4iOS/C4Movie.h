//
//  C4VideoPlayerView.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-11-19.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import <UIKit/UIKit.h>

/**This document describes the C4Movie class. You use an C4Movie object to implement the playback of video files, it encapulates an [AVPlayer](AVPlayer) object which handles the loading and control of assets.
 
 Underlying the AVPlayer is an C4PlayerLayer which has many of the common functionalities of image, shape, text and gl layers. The C4PlayerLayer is what will display the visual content of items played by an instance of AVPlayer and uses CoreAnimation to do so; 
 
 The C4Movie class is meant to simplify the addition of videos to your application. It is also a subclass of C4Control, and so has all the common animation, interaction and notification capabilities.
 
 A C4Movie's resizing behaviour is to map itself to the edges of its visible frame. This functionality implicitly uses  AVLayerVideoGravityResize as its layer's default gravity. You can change the frame of the movie from an arbitrary shape back to its original proportion by using its originalMovieSize, originalMovieRatio, or by independently setting either its width or height properties.
 */

@interface C4Movie : C4Control {
    NSURL *movieURL;
    void *rateContext, *currentItemContext, *playerItemStatusContext;
}
/**Creates and returns a new C4Movie object with a given file name.

 This method will set the frame of the returned object to that of the file's original size.
 
 @param movieName The filename of a video located in the application's main bundle.
 */
+(C4Movie *)movieNamed:(NSString *)movieName;

/**Creates and returns a new C4Movie object with a given file name and frame.
 
 This method will stretch the movie to fill the given frame size.

 @param movieName The filename of a video located in the application's main bundle.
 @param movieFrame The frame for the new movie
 */
+(C4Movie *)movieNamed:(NSString *)movieName inFrame:(CGRect)movieFrame;

/**Initializes a C4Movie object with a given file name.
 
 This method will set the frame of the object to that of the file's original size.
 
 @param movieName The filename of a video located in the application's main bundle.
 */
-(id)initWithMovieName:(NSString *)movieName;

/**Initializes a C4Movie object with a given file name and frame.
 
 This method will stretch the movie to fill the given frame size.
 
 @param movieName The filename of a video located in the application's main bundle.
 @param movieFrame The frame for the new movie
 */
-(id)initWithMovieName:(NSString *)movieName andFrame:(CGRect)movieFrame;

/**Starts playing the movie.
 
 The movie will play at its last specified rate.
 */
-(void)play;

/**Pauses the movie.
 */
-(void)pause;

/**The duration of the movie, in seconds.
 */
-(CGFloat)duration;

/**The current time of the movie, in seconds.
 */
-(CGFloat)currentTime;

/**Will jump the movie to a specific time, in seconds.
 
 @param time A specific time to which the playhead will jump.
 */
-(void)seekToTime:(CGFloat)time;

/**Will jump the movie forwards or backwards by the given amount of time.
 @param time The amount of time to move forwards or backwards. Can have a + or - value.
 */
-(void)seekByAddingTime:(CGFloat)time;

/**Method called when the movie reaches its end.
 
 Can be overridden to trigger actions at the end of the movie.
 */
-(void)reachedEnd;

/**Method called when the movie's time changes.
 
 Can be overridden to trigger actions when the movie's current time is changed arbitrarily.
 */
-(void)currentTimeChanged;

/**The original size of the movie file.
 */
@property (readonly, nonatomic) CGSize originalMovieSize;

/**The original ratio of the movie file.
 
 Calculated from the originalMovieSize.
 */
@property (readonly, nonatomic) CGFloat originalMovieRatio;

/**The rate at which the movie will play.
 
 Must be positive and >= 0.0f
 
 Setting to 0.0f is like calling pause.
 */
@property (nonatomic) CGFloat rate;

/**The width of the movie.
 
 Setting this value will also set the height to its appropriate size ratio for the given width.
 
 To stretch the movie without changing its height, you can call movie.frame(movie.origin.x, movie.origin.y, newWidth, movie.height);
 */
@property (nonatomic) CGFloat width;

/**The height of the movie.
 
 Setting this value will also set the width to its appropriate size ratio for the given height.
 
 To stretch the movie without changing its width, you can call movie.frame(movie.origin.x, movie.origin.y, movie.width, newHeight);
 */
@property (nonatomic) CGFloat height;

/**Specifies whether the movie is playing or not.
 */
@property (readonly, nonatomic) BOOL isPlaying;

/**Specifies whether the movie will loop or not.
 */
@property (atomic) BOOL loops;

/**Specifies whether the movies should play automatically after being loaded into the view.
 */
@property (atomic) BOOL shouldAutoplay;

/**Specifies the audio mix for the movie.
 */
@property (readonly, nonatomic, strong) AVMutableAudioMix *audioMix;

/**Specifies the volume of the movie.
 
 This value ranges from 0 to 1.
 */
@property (readwrite, nonatomic) CGFloat volume;

/**Specifies the size of the movie. Animatable.
 */
@property (readwrite, nonatomic) CGSize size;
@end
