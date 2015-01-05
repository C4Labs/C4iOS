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
    
    convenience public init(_ filename: String) {
        self.init(filenames: [filename])
    }
    
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
    
    public func play() {
        currentPlayer.play()
    }
    
    public func pause() {
        currentPlayer.pause()
    }
    
    public var duration : Double {
        get {
            return Double(currentPlayer.duration)
        }
    }
    
    public var playing : Bool {
        get {
            return currentPlayer.rate > 0 ? true : false
        }
    }
    
    public var pan : Double {
        get {
            return Double(currentPlayer.pan)
        } set(val) {
            currentPlayer.pan = clamp(Float(val), -1.0, 1.0)
        }
    }
    
    public var volume : Double {
        get {
            return Double(currentPlayer.volume)
        } set(val) {
            currentPlayer.volume = Float(val)
        }
    }
    
    public var currentTime: Double {
        get {
            return currentPlayer.currentTime
        } set(val) {
            currentPlayer.currentTime = NSTimeInterval(val)
        }
    }
    
    public var rate: Double {
        get {
            return Double(currentPlayer.rate)
        } set(val) {
            currentPlayer.rate = Float(rate)
        }
    }
    
    public func next() {
        currentPlayer.pause()
        
        let index = find(audiofiles, currentPlayer)
        if let index = index {
            currentPlayer = audiofiles[index + 1]
            currentPlayer.currentTime = 0.0
            currentPlayer.play()
        }
    }
    
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
