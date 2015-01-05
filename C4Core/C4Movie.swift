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
    internal var player : AVPlayer = AVPlayer()
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
    
    convenience public init(_ name: String) {
        //grab url for movie file
        let components = name.componentsSeparatedByString(".")
        let url = NSBundle.mainBundle().URLForResource(components[0], withExtension: components[1])
        
        //create asset from url
        let asset = AVAsset.assetWithURL(url) as AVAsset
        let tracks = asset.tracksWithMediaType(AVMediaTypeVideo)
        
        //grab the movie track and size
        let movieTrack = tracks[0] as AVAssetTrack
        let size = C4Size(movieTrack.naturalSize)
        
        self.init(frame: C4Rect(0,0,Double(size.width),Double(size.height)))
        //initialize player with item
        player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        player.actionAtItemEnd = .Pause
        currentItem = player.currentItem

        //runs an overrideable method for handling the end of the movie
        on(event: AVPlayerItemDidPlayToEndTimeNotification) {
            self.reachedEnd()
        }

        //movie view's player
        movieLayer.player = player
    }
    
    convenience public init(frame: C4Rect) {
        self.init()
        self.view = MovieView(frame: CGRect(frame))
    }
    
    public func play() {
        player.play()
    }
    
    public func pause() {
        player.pause()
    }
    
    public func stop() {
        player.seekToTime(CMTimeMake(0,1))
        player.pause()
    }

    public func reachedEnd() {
        if loops {
            stop()
            play()
        }
    }
    
    public var loops : Bool = true
}