//
//  AudioPlayer07.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-09.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class AudioPlayer07: CanvasController {
    
    var audioPlayer:AudioPlayer!
    var circle:Circle!
    var velocityMax:Double = 10000
    
    override func setup() {
        
        audioPlayer = AudioPlayer("C4Loop.aif")
        audioPlayer.loops = true
        
        self.canvas.addPanGestureRecognizer { (center, location, translation, velocity, state) -> () in
            //slide finger quickly over screen to change pan from left to right.
            self.audioPlayer.pan = abs(velocity.x) / self.velocityMax
            print("\(abs(velocity.x))")
            
        }
        
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