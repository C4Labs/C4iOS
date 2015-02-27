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

import QuartzCore
import UIKit
import C4Core
import AVFoundation
import CoreMedia

public class C4Movie: C4View {
    internal var statusContext = 0
    internal var player : AVQueuePlayer = AVQueuePlayer()
    internal var currentItem : AVPlayerItem = AVPlayerItem()
    
    internal class MovieView : UIView {
        
        var movieLayer: AVPlayerLayer {
            get {
                return self.layer as AVPlayerLayer
            }
        }
        
        override class func layerClass() -> AnyClass {
            return AVPlayerLayer.self
        }
    }
    
    internal var movieLayer: AVPlayerLayer {
        get {
            return self.movieView.movieLayer
        }
    }
    
    internal var movieView: MovieView {
        return self.view as MovieView
    }
    
    /**
    Initializes a new C4Movie using the specified filename from the bundle (i.e. your project).
    
    :param: name	The name of the movie file included in your project.
    */
    convenience public init(_ filename: String) {
        //grab url for movie file

        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        
        //create asset from url
        let asset = AVAsset.assetWithURL(url) as AVAsset
        let tracks = asset.tracksWithMediaType(AVMediaTypeVideo)
        
        //grab the movie track and size
        let movieTrack = tracks[0] as AVAssetTrack
        let size = C4Size(movieTrack.naturalSize)
        
        self.init(frame: C4Rect(0,0,Double(size.width),Double(size.height)))
        //initialize player with item
        player = AVQueuePlayer(playerItem: AVPlayerItem(asset: asset))
        player.actionAtItemEnd = .Pause
        currentItem = player.currentItem
        
        //runs an overrideable method for handling the end of the movie
        on(event: AVPlayerItemDidPlayToEndTimeNotification) {
            self.reachedEnd()
        }
        
        //movie view's player
        movieLayer.player = player
    }
    
    /**
    Initializes a new C4Movie using the specified frame.
    
    :param: frame	The frame of the new movie object.
    */
    convenience public init(frame: C4Rect) {
        self.init()
        self.view = MovieView(frame: CGRect(frame))
    }
    
    /**
    Begins playback of the current item.
    
    This is the same as setting rate to 1.0.
    */
    public func play() {
        player.play()
    }
    
    /**
    Pauses playback.
    
    This is the same as setting rate to 0.0.
    */
    public func pause() {
        player.pause()
    }
    
    /**
    Stops playback.
    
    This is the same as setting rate to 0.0 and resetting the current time to 0.
    */
    public func stop() {
        player.seekToTime(CMTimeMake(0,1))
        player.pause()
    }
    
    /**
    Called at the end of playback (i.e. when the movie reaches its end).
    
    You can override this function to add your own custom actions.
    
    Default behaviour: if the movie should loop then the method calls `stop()` and `play()`.
    */
    public func reachedEnd() {
        if loops {
            stop()
            play()
        }
    }
    
    /**
    Assigning a value of true to this property will cause the receiver to loop at the end of playback.

    The default value of this property is `true`.
    */    public var loops : Bool = true
}