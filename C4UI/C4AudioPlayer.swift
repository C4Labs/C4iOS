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

import C4Core
import UIKit
import AVFoundation

public class C4AudioPlayer : NSObject, AVAudioPlayerDelegate {
    internal var currentPlayer = AVAudioPlayer()
    internal var audiofiles = [AVAudioPlayer]()
    
    /**
    Initializes a new audio player from a given file name
    */
    convenience public init(_ filename: String) {
        self.init(filenames: [filename])
    }
    
    /**
    Initializes a new audio player from a given set of file names. The files will be played in sequence.
    */
    convenience public init(filenames: [String]) {
        self.init()
        
        for filename in filenames {
            let url = NSBundle.mainBundle().URLForResource(filename, withExtension:nil)
            let player = AVAudioPlayer(contentsOfURL: url, error: nil)
            player.delegate = self
            audiofiles.append(player)
        }
        
        currentPlayer = audiofiles[0]
    }
    
    /**
    Plays a sound asynchronously.
    */
    public func play() {
        currentPlayer.play()
    }
    
    /**
    Pauses playback; sound remains ready to resume playback from where it left off.
    Calling pause leaves the audio player prepared to play; it does not release the audio hardware that was acquired upon calling play or prepareToPlay.
    */
    public func pause() {
        currentPlayer.pause()
    }
    
    /**
    Returns the total duration, in seconds, of the sound associated with the audio player. (read-only)
    */
    public var duration : Double {
        get {
            return Double(currentPlayer.duration)
        }
    }
    
    /**
    Returns true if the receiver's current playback rate > 0. Otherwise returns false.
    */
    public var playing : Bool {
        get {
            return currentPlayer.rate > 0 ? true : false
        }
    }
    
    /**
    The audio player’s stereo pan position.
    By setting this property you can position a sound in the stereo field. A value of –1.0 is full left, 0.0 is center, and 1.0 is full right.
    */
    public var pan : Double {
        get {
            return Double(currentPlayer.pan)
        } set(val) {
            currentPlayer.pan = clamp(Float(val), -1.0, 1.0)
        }
    }
    
    /**
    The playback volume for the audio player, ranging from 0.0 through 1.0 on a linear scale.
    A value of 0.0 indicates silence; a value of 1.0 (the default) indicates full volume for the audio player instance.
    Use this property to control an audio player’s volume relative to other audio output.
    To provide UI in iOS for adjusting system audio playback volume, use the MPVolumeView class, which provides media playback controls that users expect and whose appearance you can customize.
    */
    public var volume : Double {
        get {
            return Double(currentPlayer.volume)
        } set(val) {
            currentPlayer.volume = Float(val)
        }
    }
    
    /**
    The playback point, in seconds, within the timeline of the sound associated with the audio player.
    If the sound is playing, currentTime is the offset of the current playback position, measured in seconds from the start of the sound. If the sound is not playing, currentTime is the offset of where playing starts upon calling the play method, measured in seconds from the start of the sound.
    By setting this property you can seek to a specific point in a sound file or implement audio fast-forward and rewind functions.
    */
    public var currentTime: Double {
        get {
            return currentPlayer.currentTime
        } set(val) {
            currentPlayer.currentTime = NSTimeInterval(val)
        }
    }
    
    /**
    The audio player’s playback rate.
    This property’s default value of 1.0 provides normal playback rate. The available range is from 0.5 for half-speed playback through 2.0 for double-speed playback.
    To set an audio player’s playback rate, you must first enable rate adjustment as described in the enableRate property description.
    */
    public var rate: Double {
        get {
            return Double(currentPlayer.rate)
        } set(val) {
            currentPlayer.rate = Float(rate)
        }
    }
    
    /**
    Advances the audioplayer to the next sound / audio file. 
    The player pauses, then advances if possible. If there is another file in the queue the audioplayer automatically starts playing again.
    */
    public func next() {
        currentPlayer.pause()
        
        let index = find(audiofiles, currentPlayer)
        if let index = index {
            currentPlayer = audiofiles[index + 1]
            currentPlayer.currentTime = 0.0
            currentPlayer.play()
        }
    }
    
    /**
    Plays the previous sound or sound / audio file in the queue.
    The player pauses, then positions the playhead to the previous sound / audio file if possible. If there is a previous file in the queue the audioplayer automatically starts playing again.
    */
    public func prev() {
        currentPlayer.pause()
        let index = find(audiofiles, currentPlayer)
        if let index = index {
            currentPlayer = audiofiles[index - 1]
            currentPlayer.currentTime = 0.0
            currentPlayer.play()
        }
    }
}
