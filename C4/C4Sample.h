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
#pragma mark - Creating An Audio Sample
///@name Creating An Audio Sample

/**Creates and returns a new C4Sample with a given file name.
 
 @param sampleName The filename of a sample to be loaded.
 */
+ (instancetype)sampleNamed:(NSString *)sampleName;

/**Initializes a C4Sample with a given file name.
 
 @param sampleName The filename of a sample to be loaded.
 */
-(id)initWithSampleName:(NSString *)sampleName;

#pragma mark - Configuring and Controlling Playback
///@name Configuring and Controlling Playback
/**Plays a sound asynchronously.
 
 Calling this method implicitly calls the prepareToPlay method if the audio player is not already prepared to play.
 */
-(void)play;

/**Plays a sound asynchronously, starting at a specified point in the audio output device’s timeline.
 
 Use this method to precisely synchronize the playback of two or more AVAudioPlayer objects. This code snippet shows the recommended way to do this:
 
 Calling this method implicitly calls the prepareToPlay method if the audio player is not already prepared to play.
 
 @param time The number of seconds to delay playback, relative to the audio output device’s current time.
 */
-(void)playAtTime:(CGFloat)time;

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

/**A Boolean value that indicates whether the audio player is playing (YES) or not (NO). (read-only)
 */
@property(nonatomic, readonly, getter=isPlaying) BOOL playing;

/**The playback gain for the audio player, ranging from 0.0 through 1.0.
 */
@property(nonatomic) CGFloat volume;

/**The audio player’s stereo pan position.
 
 By setting this property you can position a sound in the stereo field. A value of –1.0 is full left, 0.0 is center, and 1.0 is full right.
 */
@property(nonatomic) CGFloat pan;

/**The audio player’s playback rate.
 
 This property’s default value of 1.0 provides normal playback rate.
 
 To set an audio player’s playback rate, you must first enable rate adjustment as described in the enableRate property description.
 */
@property(nonatomic) CGFloat rate;

/**A Boolean value that specifies whether playback rate adjustment is enabled for an audio player.
 
 To enable adjustable playback rate for an audio player, set this property to YES after you initialize the player and before you call the prepareToPlay instance method for the player.
 */
@property(nonatomic) BOOL enableRate;

/**A Boolean value that specifies whether or not the sound will loop when it reaches its end.
 
 Setting this variable to YES implicitly sets numberOfLoops to -1.
 */
@property(nonatomic) BOOL loops;

/**The number of times a sound will return to the beginning, upon reaching the end, to repeat playback.
 
 A value of 0, which is the default, means to play the sound once. Set a positive integer value to specify the number of times to return to the start and play again. For example, specifying a value of 1 results in a total of two plays of the sound. Set any negative integer value to loop the sound indefinitely until you call the stop method.
 */
@property(nonatomic) NSInteger numberOfLoops;

/**The audio player’s settings dictionary, containing information about the sound associated with the player. (read-only)
 
 An audio player’s settings dictionary contains keys for the following information about the player’s associated sound:
 
 - Channel layout (AVChannelLayoutKey)
 - Encoder bit rate (AVEncoderBitRateKey)
 - Audio data format (AVFormatIDKey)
 - Channel count (AVNumberOfChannelsKey)
 - Sample rate (AVSampleRateKey)
 
 The settings keys are described in AV Foundation Audio Settings Constants.
 */
@property(nonatomic, readonly) NSDictionary *settings;

#pragma mark - Managing Information About a Sound
///@name Managing Information About a Sound
/**The number of audio channels in the sound associated with the audio player. (read-only)
 */
-(NSUInteger)numberOfChannels;

/**Returns the total duration, in seconds, of the sound associated with the audio player. (read-only)
 */
@property(nonatomic, readonly) CGFloat duration;

/**The playback point, in seconds, within the timeline of the sound associated with the audio player.
 
 If the sound is playing, currentTime is the offset of the current playback position, measured in seconds from the start of the sound. If the sound is not playing, currentTime is the offset of where playing starts upon calling the play method, measured in seconds from the start of the sound.
 
 By setting this property you can seek to a specific point in a sound file or implement audio fast-forward and rewind functions.
 */
@property(nonatomic) CGFloat currentTime;

/**The time value, in seconds, of the audio output device. (read-only)
 
 The value of this property increases monotonically while an audio player is playing or paused.
 
 If more than one audio player is connected to the audio output device, device time continues incrementing as long as at least one of the players is playing or paused.
 
 If the audio output device has no connected audio players that are either playing or paused, device time reverts to 0.
 
 Use this property to indicate “now” when calling the playAtTime: instance method. By configuring multiple audio players to play at a specified offset from deviceCurrentTime, you can perform precise synchronization—as described in the discussion for that method.
 */
@property(nonatomic, readonly) CGFloat deviceCurrentTime;

#pragma mark - Using Audio Level Metering
///@name Using Audio Level Metering
/**A Boolean value that specifies the audio-level metering on/off state for the audio player.
 
 The default value for the meteringEnabled property is off (Boolean NO). Before using metering for an audio player, you need to enable it by setting this property to YES. If player is an audio player instance variable of your controller class, you enable metering as shown here:
 
 `[self.player setMeteringEnabled: YES];`
 */
@property(nonatomic, getter = isMeteringEnabled) BOOL meteringEnabled;

/**Returns the peak power for a given channel, in decibels, for the sound being played.
 
 To obtain a current peak power value, you must call the updateMeters method before calling this method.
 
 @param channelNumber The audio channel whose peak power value you want to obtain. Channel numbers are zero-indexed. A monaural signal, or the left channel of a stereo signal, has channel number 0.
 @return A floating-point representation, in decibels, of a given audio channel’s current peak power. A return value of 0 dB indicates full scale, or maximum power; a return value of -160 dB indicates minimum power (that is, near silence). If the signal provided to the audio player exceeds ±full scale, then the return value may exceed 0 (that is, it may enter the positive range).
 */
-(CGFloat)peakPowerForChannel:(NSUInteger)channelNumber;

/**Returns the average power for a given channel, in decibels, for the sound being played.
 
 To obtain a current average power value, you must call the updateMeters method before calling this method.
 
 @param channelNumber The audio channel whose average power value you want to obtain. Channel numbers are zero-indexed. A monaural signal, or the left channel of a stereo signal, has channel number 0.
 @return A floating-point representation, in decibels, of a given audio channel’s current average power. A return value of 0 dB indicates full scale, or maximum power; a return value of -160 dB indicates minimum power (that is, near silence). If the signal provided to the audio player exceeds ±full scale, then the return value may exceed 0 (that is, it may enter the positive range).
 */
-(CGFloat)averagePowerForChannel:(NSUInteger)channelNumber;

/**Refreshes the average and peak power values for all channels of an audio player.
 
 To obtain current audio power values, you must call this method before calling averagePowerForChannel: or peakPowerForChannel:.
 */
-(void)updateMeters;

#pragma mark - Marking the End of Playback
/**Method called when the audio sample reaches its end and stops.
 
 Can be overridden to trigger actions at the end of the movie.
 
 Similar to C4Movie's reachedEnd method, however when an audio sample is looping this method will not get called when the currentTime reaches the end of the file's playback length.
 */
-(void)endedNormally;

#pragma mark - Accessing the AVAudioPlayer
///@name Accessing the AVAudioPlayer
/**Specifies the player object for the audio sample.
 */
@property(nonatomic, readonly, strong) AVAudioPlayer *player;

@end