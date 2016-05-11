//
//  AudioPlayer02.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-09.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class AudioPlayer02: CanvasController {
    
    var audioPlayer:AudioPlayer!
    
    override func setup() {
        
        audioPlayer = AudioPlayer("C4Loop.aif")
        
        self.canvas.addTapGestureRecognizer { (center, location, state) -> () in
            
            //playing returns true if the receiver's current playback rate > 0. Otherwise returns false.
            if self.audioPlayer.playing == false{
                self.audioPlayer.play()
                print("playing")
                self.canvas.backgroundColor = C4Pink
            } else {
                self.audioPlayer.stop()
                self.canvas.backgroundColor = C4Blue
                print("stopped")
            }
            
        }
    }
}