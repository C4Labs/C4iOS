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

///This document describes the C4Movie class. You use a C4Movie object to implement the playback of video files, it encapulates an AVQueuePlayer object which handles the loading and control of assets.
///
///The C4Movie class is meant to simplify the addition of videos to your application. It is also a subclass of C4View, and so has all the common animation, interaction and notification capabilities.
///
///A C4Movie’s resizing behaviour is to map itself to the edges of its visible frame. This functionality implicitly uses AVLayerVideoGravityResize as its layer’s default gravity. You can change the frame of the movie from an arbitrary shape back to its original proportion by using its originalSize, originalRatio, or by independently setting either its width or height properties.
public class C4Movie: C4View {
    var player : AVQueuePlayer?
    var currentItem : AVPlayerItem?
    var reachedEndAction : (()->())?
    
    /// Assigning a value of true to this property will cause the receiver to loop at the end of playback.
    ///
    /// The default value of this property is `true`.
    public var loops : Bool = true
    
    /// A variable that provides access to the width of the receiver. Animatable.
    /// The default value of this property is defined by the movie being created.
    /// Assigning a value to this property causes the receiver to change the width of its frame. If the receiver's
    /// `contrainsProportions` variable is set to `true` the receiver's height will change to match the new width.
    public override var width : Double {
        get {
            return Double(view.frame.size.width)
        } set(val) {
            var newSize = C4Size(val,height)
            if constrainsProportions {
                newSize.height = val * height / width
            }
            var rect = self.frame
            rect.size = newSize
            self.frame = rect
        }
    }
    
    /// A variable that provides access to the height of the receiver. Animatable.
    /// The default value of this property is defined by the movie being created.
    /// Assigning a value to this property causes the receiver to change the height of its frame. If the receiver's
    /// `contrainsProportions` variable is set to `true` the receiver's width will change to match the new height.
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
    
    /// Assigning a value of true to this property will cause the receiver to scale its entire frame whenever its `width` or
    /// `height` variables are set.
    /// The default value of this property is `true`.
    public var constrainsProportions : Bool = true
    
    /// The original size of the receiver when it was initialized.
    public internal(set) var originalSize : C4Size = C4Size(1,1)
    
    /// The original width/height ratio of the receiver when it was initialized.
    public var originalRatio : Double {
        get {
            return originalSize.width / originalSize.height
        }
    }
    
    var movieLayer: AVPlayerLayer {
        get {
            return self.movieView.movieLayer
        }
    }
    
    var movieView: MovieView {
        return self.view as! MovieView
    }
    
    class MovieView : UIView {
        
        var movieLayer: AVPlayerLayer {
            get {
                return self.layer as! AVPlayerLayer
            }
        }
        
        override class func layerClass() -> AnyClass {
            return AVPlayerLayer.self
        }
    }
    
    /// Initializes a new C4Movie using the specified filename from the bundle (i.e. your project).
    ///
    /// - parameter name:	The name of the movie file included in your project.
    public convenience init?(_ filename: String) {
        guard let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil) else {
            return nil
        }
        
        let asset = AVAsset(URL: url)
        let tracks = asset.tracksWithMediaType(AVMediaTypeVideo)
        
        //grab the movie track and size
        let movieTrack = tracks[0]
        let size = C4Size(movieTrack.naturalSize)
        
        self.init(frame: C4Rect(0,0,Double(size.width),Double(size.height)))
        //initialize player with item
        let newPlayer = AVQueuePlayer(playerItem: AVPlayerItem(asset: asset))
        newPlayer.actionAtItemEnd = .Pause
        currentItem = newPlayer.currentItem
        player = newPlayer
        
        //runs an overrideable method for handling the end of the movie
        on(event: AVPlayerItemDidPlayToEndTimeNotification) {
            self.handleReachedEnd()
        }
        
        //movie view's player
        movieLayer.player = player
        movieLayer.videoGravity = AVLayerVideoGravityResize
        
        originalSize = self.size
    }
    
    /// Initializes a new C4Movie using the specified frame.
    ///
    /// - parameter frame:	The frame of the new movie object.
    public init(frame: C4Rect) {
        super.init()
        self.view = MovieView(frame: CGRect(frame))
    }
    
    
    /// Begins playback of the current item.
    ///
    /// This is the same as setting rate to 1.0.
    public func play() {
        guard let p = player else {
            print("The current movie's player is not properly initialized")
            return
        }
        p.play()
    }
    
    /// Pauses playback.
    ///
    /// This is the same as setting rate to 0.0.
    public func pause() {
        guard let p = player else {
            print("The current movie's player is not properly initialized")
            return
        }
        p.pause()
    }
    
    /// Stops playback.
    ///
    /// This is the same as setting rate to 0.0 and resetting the current time to 0.
    public func stop() {
        guard let p = player else {
            print("The current movie's player is not properly initialized")
            return
        }
        p.seekToTime(CMTimeMake(0,1))
        p.pause()
    }
    
    /// Called at the end of playback (i.e. when the movie reaches its end).
    ///
    /// You can override this function to add your own custom actions.
    ///
    /// Default behaviour: if the movie should loop then the method calls `stop()` and `play()`.
    public func reachedEnd(action: ()->()) {
        reachedEndAction = action
    }
    
    func handleReachedEnd() {
        if self.loops {
            self.stop()
            self.play()
        }
        reachedEndAction?()
    }
}