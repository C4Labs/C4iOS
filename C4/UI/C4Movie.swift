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
import AVFoundation
import CoreMedia

public class C4Movie: C4View {
    internal var statusContext = 0
    internal var player : AVQueuePlayer = AVQueuePlayer()
    internal var currentItem : AVPlayerItem?
    private(set) public var duration: Double = 0.0

    internal class MovieView : UIView {
        
        var movieLayer: AVPlayerLayer {
            get {
                return self.layer as! AVPlayerLayer
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
        return self.view as! MovieView
    }
    
    /**
    Initializes a new C4Movie using the specified filename from the bundle (i.e. your project).
    
    - parameter name:	The name of the movie file included in your project.
    */
    convenience public init(_ filename: String) {
        //grab url for movie file

        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        
        assert(url != nil, "Could not locate movie with the given filename: \(filename)")
        
        //create asset from url
        let asset = AVAsset(URL: url!)
        let tracks = asset.tracksWithMediaType(AVMediaTypeVideo)

        //grab the movie track and size
        let movieTrack = tracks[0]
        let size = C4Size(movieTrack.naturalSize)
        
        self.init(frame: C4Rect(0,0,Double(size.width),Double(size.height)))
        duration = Double(CMTimeGetSeconds(asset.duration))

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
        movieLayer.videoGravity = AVLayerVideoGravityResize

        _originalSize = self.size
    }
    
    /**
    Initializes a new C4Movie using the specified frame.
    
    - parameter frame:	The frame of the new movie object.
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

    public func seekTo(time: Double) {
        player.seekToTime(CMTime(seconds: time, preferredTimescale: 600))
    }

    /**
    Assigning a value of true to this property will cause the receiver to loop at the end of playback.

    The default value of this property is `true`.
    */    public var loops : Bool = true

    /**
    A variable that provides access to the width of the receiver. Animatable.
    The default value of this property is defined by the movie being created.
    Assigning a value to this property causes the receiver to change the width of its frame. If the receiver's `contrainsProportions` variable is set to `true` the receiver's height will change to match the new width.
    */
    public override var width : Double {
        get {
            return Double(view.frame.size.width)
        } set(val) {
            var newSize = C4Size(val,height)
            if constrainsProportions {
                let ratio = Double(height / width)
                newSize.height = val * ratio
            }
            var rect = self.frame
            rect.size = newSize
            self.frame = rect
        }
    }

    /**
    A variable that provides access to the height of the receiver. Animatable.
    The default value of this property is defined by the movie being created.
    Assigning a value to this property causes the receiver to change the height of its frame. If the receiver's `contrainsProportions` variable is set to `true` the receiver's width will change to match the new height.
    */
    public override var height : Double {
        get {
            return Double(view.frame.size.height)
        } set(val) {
            var newSize = C4Size(Double(view.frame.size.width),val)
            if constrainsProportions {
                let ratio = Double(self.size.width / self.size.height)
                newSize.width = val * ratio
            }
            var rect = self.frame
            rect.size = newSize
            self.frame = rect
        }
    }

    /**
    Assigning a value of true to this property will cause the receiver to scale its entire frame whenever its `width` or `height` variables are set.
    The default value of this property is `false`.
    */
    public var constrainsProportions : Bool = false

    /**
    The original size of the receiver when it was initialized.
    */
    internal var _originalSize : C4Size = C4Size()
    public var originalSize : C4Size {
        get {
            return _originalSize
        }
    }

    /**
    The original width/height ratio of the receiver when it was initialized.
    */
    public var originalRatio : Double {
        get {
            return _originalSize.width / _originalSize.height
        }
    }
}