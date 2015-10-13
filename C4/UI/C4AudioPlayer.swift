// Copyright © 2014 C4
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

import UIKit
import AVFoundation

/// C4AudioPlayer provides playback of audio data from a file or memory.
///
///  Using an audio player you can:
///
///  Play sounds of any duration
///
///  Play sounds from files or memory buffers
///
///  Loop sounds
///
///  Play multiple sounds simultaneously, one sound per audio player, with precise synchronization
///
///  Control relative playback level, stereo positioning, and playback rate for each sound you are playing
///
///  Seek to a particular point in a sound file, which supports such application features as fast forward and rewind
///
///  Obtain data you can use for playback-level metering
public class C4AudioPlayer : NSObject, AVAudioPlayerDelegate {
    internal var currentPlayer = AVAudioPlayer()
    internal var audiofiles = [AVAudioPlayer]()
    
    /// Initializes a new audio player from a given file name
    ///
    /// ````
    /// let ap = C4AudioPlayer("audioTrackFileName")
    /// ````
    convenience public init(_ filename: String) {
        self.init(filenames: [filename])
    }
    
    /// Initializes a new audio player from a given set of file names. The files will be played in sequence.
    ///
    /// ````
    /// let ap = C4AudioPlayer(["audioTrackFileName", "anotherTrackFileName"])
    /// ````
    convenience public init(filenames: [String]) {
        self.init()
        
        for filename in filenames {
            if let url = NSBundle.mainBundle().URLForResource(filename, withExtension:nil) {
                let player: AVAudioPlayer!
                do {
                    player = try AVAudioPlayer(contentsOfURL: url)
                } catch _ {
                    player = nil
                }
                player.delegate = self
                audiofiles.append(player)
            }
        }
        
        currentPlayer = audiofiles[0]
        currentPlayer.meteringEnabled = true
        currentPlayer.enableRate = true
    }
    
    /// Plays a sound asynchronously.
    public func play() {
        currentPlayer.play()
    }
    
    /// Pauses playback; sound remains ready to resume playback from where it left off.
    /// Calling pause leaves the audio player prepared to play; it does not release the audio hardware that was acquired upon
    /// calling play or prepareToPlay.
    public func pause() {
        currentPlayer.pause()
    }
    
    /// Stops playback and undoes the setup needed for playback.
    /// Calling this method, or allowing a sound to finish playing, undoes the setup performed upon calling the play or
    /// prepareToPlay methods.
    /// The stop method does not reset the value of the currentTime property to 0. In other words, if you call stop during
    /// playback and then call play, playback resumes at the point where it left off.
    public func stop() {
        currentPlayer.stop()
    }
    
    /// Returns the total duration, in seconds, of the sound associated with the audio player. (read-only)
    public var duration : Double {
        get {
            return Double(currentPlayer.duration)
        }
    }
    
    /// Returns true if the receiver's current playback rate > 0. Otherwise returns false.
    public var playing : Bool {
        get {
            return currentPlayer.playing
        }
    }
    
    /// The audio player’s stereo pan position.
    /// By setting this property you can position a sound in the stereo field. A value of –1.0 is full left, 0.0 is center, and
    /// 1.0 is full right.
    public var pan : Double {
        get {
            return Double(currentPlayer.pan)
        } set(val) {
            currentPlayer.pan = clamp(Float(val), min: -1.0, max: 1.0)
        }
    }
    
    /// The playback volume for the audio player, ranging from 0.0 through 1.0 on a linear scale.
    /// A value of 0.0 indicates silence; a value of 1.0 (the default) indicates full volume for the audio player instance.
    /// Use this property to control an audio player’s volume relative to other audio output.
    /// To provide UI in iOS for adjusting system audio playback volume, use the MPVolumeView class, which provides media
    /// playback controls that users expect and whose appearance you can customize.
    public var volume : Double {
        get {
            return Double(currentPlayer.volume)
        } set(val) {
            currentPlayer.volume = Float(val)
        }
    }
    
    /// The playback point, in seconds, within the timeline of the sound associated with the audio player.
    /// If the sound is playing, currentTime is the offset of the current playback position, measured in seconds from the start
    /// of the sound. If the sound is not playing, currentTime is the offset of where playing starts upon calling the play
    /// method, measured in seconds from the start of the sound.
    /// By setting this property you can seek to a specific point in a sound file or implement audio fast-forward and rewind
    /// functions.
    public var currentTime: Double {
        get {
            return currentPlayer.currentTime
        } set(val) {
            currentPlayer.currentTime = NSTimeInterval(val)
        }
    }
    
    /// The audio player’s playback rate.
    /// This property’s default value of 1.0 provides normal playback rate. The available range is from 0.5 for half-speed
    /// playback through 2.0 for double-speed playback.
    /// To set an audio player’s playback rate, you must first enable rate adjustment as described in the enableRate property
    /// description.
    ///
    /// ````
    /// let ap = C4AudioPlayer("audioTrackFileName")
    /// ap.enableRate = true
    /// ap.rate = 0.5
    /// ap.play()
    /// ````
    public var rate: Double {
        get {
            return Double(currentPlayer.rate)
        } set(val) {
            currentPlayer.rate = Float(rate)
        }
    }
    
    /// Advances the audioplayer to the next sound / audio file.
    /// The player pauses, then advances if possible. If there is another file in the queue the audioplayer automatically starts
    /// playing again.
    public func next() {
        currentPlayer.pause()
        
        let index = audiofiles.indexOf(currentPlayer)
        if let index = index {
            currentPlayer = audiofiles[index + 1]
            currentPlayer.currentTime = 0.0
            currentPlayer.play()
        }
    }
    
    /// Plays the previous sound or sound / audio file in the queue.
    /// The player pauses, then positions the playhead to the previous sound / audio file if possible. If there is a previous
    /// file in the queue the audioplayer automatically starts playing again.
    public func prev() {
        currentPlayer.pause()
        let index = audiofiles.indexOf(currentPlayer)
        if let index = index {
            currentPlayer = audiofiles[index - 1]
            currentPlayer.currentTime = 0.0
            currentPlayer.play()
        }
    }
    
    /// The number of times a sound will return to the beginning, upon reaching the end, to repeat playback.
    /// A value of 0, which is the default, means to play the sound once. Set a positive integer value to specify the number of
    /// times to return to the start and play again. For example, specifying a value of 1 results in a total of two plays of the
    /// sound. Set any negative integer value to loop the sound indefinitely until you call the stop method.
    ///
    /// Defaults to 1000000.
    public var loops : Bool {
        get {
            return currentPlayer.numberOfLoops > 0 ? true : false
        }
        set(val) {
            if val {
                currentPlayer.numberOfLoops = 1000000
            } else {
                currentPlayer.numberOfLoops = 0
            }
        }
    }
    
    /// A Boolean value that specifies the audio-level metering on/off state for the audio player.
    /// The default value for the meteringEnabled property is off (Boolean false). Before using metering for an audio player, you need to enable it by setting this
    /// property to true. If player is an audio player instance variable of your controller class, you enable metering as shown here:
    ///
    /// ````
    /// let ap = C4AudioPlayer("audioTrackFileName")
    /// ap.meteringEnabled = true
    /// ````
    public var meteringEnabled : Bool {
        get {
            return currentPlayer.meteringEnabled
        } set(v) {
            currentPlayer.meteringEnabled = v
        }
    }
    
    /// A Boolean value that specifies whether playback rate adjustment is enabled for an audio player.
    /// To enable adjustable playback rate for an audio player, set this property to true after you initialize the player and before you call the prepareToPlay
    /// instance method for the player.
    public var enableRate : Bool {
        get {
            return currentPlayer.enableRate
        } set(v) {
            currentPlayer.enableRate = v
        }
    }
    
    /// Refreshes the average and peak power values for all channels of an audio player.
    /// To obtain current audio power values, you must call this method before calling averagePowerForChannel: or peakPowerForChannel:.
    ///
    /// ````
    /// let t = NSTimer.scheduledTimerWithTimeInterval(1.0/60.0,
    ///                                        target: self,
    ///                                      selector: "update",
    ///                                      userInfo: nil,
    ///                                       repeats: true)
    ///
    /// let ap = C4AudioPlayer("audioTrackFileName")
    /// ap.meteringEnabled = true
    ///
    /// func update() {
    ///     ap.updateMeters()
    /// }
    /// ````
    public func updateMeters() {
        currentPlayer.updateMeters()
    }
    
    /// Returns the average power for a given channel, in decibels, for the sound being played.
    ///
    /// ````
    /// func update() {
    ///     let av = player.averagePower(channel: 0)
    /// }
    /// ````
    /// - parameter channelNumber: The audio channel whose average power value you want to obtain.
    ///
    /// - returns: A floating-point representation, in decibels, of a given audio channel’s current average power.
    public func averagePower(channel: Int) -> Double {
        return Double(currentPlayer.averagePowerForChannel(channel))
    }
    
    /// Returns the peak power for a given channel, in decibels, for the sound being played.
    ///
    /// ````
    /// func update() {
    ///     let pk = player.peakPower(channel: 0)
    /// }
    /// - parameter channelNumber: The audio channel whose peak power value you want to obtain.
    ///
    /// - returns: A floating-point representation, in decibels, of a given audio channel’s current peak power.
    public func peakPower(channel: Int) -> Double {
        return Double(currentPlayer.peakPowerForChannel(channel))
    }
}
