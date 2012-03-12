//
//  C4Sample.h
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Object.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

/**This document describes C4Sample a simple class for loading and playing individual audio files.
 
 C4Sample encapsulates an instance of the AVAudioPlayer class, called an audio player, provides playback of audio data from a file or memory.
  
 Using an audio player you can:
 
 Play sounds of any duration
 Play sounds from files or memory buffers
 Loop sounds
 Play multiple sounds simultaneously, one sound per audio player, with precise synchronization
 Control relative playback level, stereo positioning, and playback rate for each sound you are playing
 Seek to a particular point in a sound file, which supports such application features as fast forward and rewind

 The C4Sample class lets you play sound in any audio format available in iOS. You implement a delegate to handle interruptions (such as an incoming phone call) and to update the user interface when a sound has finished playing. The delegate methods to use are described in AVAudioPlayerDelegate Protocol Reference.
*/

@interface C4Sample : C4Object <AVAudioPlayerDelegate>

/**Creates and returns a new C4Sample with a given file name. 
 
 @param sampleName The filename of a sample to be loaded.
 */
+(C4Sample *)sampleNamed:(NSString *)sampleName;

/**Initializes a C4Sample with a given file name. 
 
 @param sampleName The filename of a sample to be loaded.
 */
-(id)initWithSampleName:(NSString *)sampleName;

/**Plays a sound asynchronously.
  
 Calling this method implicitly calls the prepareToPlay method if the audio player is not already prepared to play.
 */
-(void)play;

/**Pauses playback; sound remains ready to resume playback from where it left off.
 
 Calling pause leaves the audio player prepared to play; it does not release the audio hardware that was acquired upon calling play or prepareToPlay.
 */
-(void)pause;

/**Stops playback and undoes the setup needed for playback.

 Calling this method, or allowing a sound to finish playing, undoes the setup performed upon calling the play or prepareToPlay methods.
 
 The stop method does not reset the value of the currentTime property to 0. In other words, if you call stop during playback and then call play, playback resumes at the point where it left off.
 */
-(void)stop;

/**Prepares the audio player for playback by preloading its buffers.
 
 Calling this method preloads buffers and acquires the audio hardware needed for playback, which minimizes the lag between calling the play method and the start of sound output.
 
 Calling the stop method, or allowing a sound to finish playing, undoes this setup.
 */
-(void)prepareToPlay;

/**Method called when the audio sample reaches its end and stops.
 
 Can be overridden to trigger actions at the end of the movie.
 
 Similar to C4Movie's reachedEnd method, however when an audio sample is looping this method will not get called when the currentTime reaches the end of the file's playback length.
 */
-(void)endedNormally;

/**Plays a sound asynchronously, starting at a specified point in the audio output device’s timeline.
 
 Use this method to precisely synchronize the playback of two or more AVAudioPlayer objects. This code snippet shows the recommended way to do this:

 Calling this method implicitly calls the prepareToPlay method if the audio player is not already prepared to play.
 
 @param time The number of seconds to delay playback, relative to the audio output device’s current time.
 */
-(void)playAtTime:(CGFloat)time;

/**A Boolean value that indicates whether the audio player is playing (YES) or not (NO). (read-only)
 */
@property (readonly, nonatomic, getter=isPlaying) BOOL playing;

/**Returns the total duration, in seconds, of the sound associated with the audio player. (read-only)
 */
@property (readonly, nonatomic) CGFloat duration;

/**The audio player’s stereo pan position.
 
 By setting this property you can position a sound in the stereo field. A value of –1.0 is full left, 0.0 is center, and 1.0 is full right.
 */
@property (readwrite, nonatomic) CGFloat pan;

/**The playback gain for the audio player, ranging from 0.0 through 1.0.
 */
@property (readwrite, nonatomic) CGFloat volume;

/**The audio player’s playback rate.
 
 This property’s default value of 1.0 provides normal playback rate.
 
 To set an audio player’s playback rate, you must first enable rate adjustment as described in the enableRate property description.
 */
@property (readwrite, nonatomic) CGFloat rate;

/**A Boolean value that specifies whether playback rate adjustment is enabled for an audio player.
 
 To enable adjustable playback rate for an audio player, set this property to YES after you initialize the player and before you call the prepareToPlay instance method for the player.
 */
@property (readwrite, nonatomic) BOOL enableRate; 

/**The playback point, in seconds, within the timeline of the sound associated with the audio player.
 
 If the sound is playing, currentTime is the offset of the current playback position, measured in seconds from the start of the sound. If the sound is not playing, currentTime is the offset of where playing starts upon calling the play method, measured in seconds from the start of the sound.
 
 By setting this property you can seek to a specific point in a sound file or implement audio fast-forward and rewind functions.
 */
@property (readwrite, nonatomic) CGFloat currentTime;

/**The time value, in seconds, of the audio output device. (read-only)
 
 The value of this property increases monotonically while an audio player is playing or paused.
 
 If more than one audio player is connected to the audio output device, device time continues incrementing as long as at least one of the players is playing or paused.
 
 If the audio output device has no connected audio players that are either playing or paused, device time reverts to 0.
 
 Use this property to indicate “now” when calling the playAtTime: instance method. By configuring multiple audio players to play at a specified offset from deviceCurrentTime, you can perform precise synchronization—as described in the discussion for that method.
 */
@property (readonly, nonatomic) CGFloat deviceCurrentTime;

/**A Boolean value that specifies whether or not the sound will loop when it reaches its end.
 
 Setting this variable to YES implicitly sets numberOfLoops to -1.
 */
@property (readwrite, nonatomic) BOOL loops;

/**The number of times a sound will return to the beginning, upon reaching the end, to repeat playback.
 
 A value of 0, which is the default, means to play the sound once. Set a positive integer value to specify the number of times to return to the start and play again. For example, specifying a value of 1 results in a total of two plays of the sound. Set any negative integer value to loop the sound indefinitely until you call the stop method.
 */
@property (readwrite, nonatomic) NSInteger numberOfLoops;
@end