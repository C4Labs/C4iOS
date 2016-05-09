//
//  AudioPlayer01.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-09.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class AudioPlayer01: CanvasController {
    
    var audioPlayer:AudioPlayer!
    
    override func setup() {
        
        audioPlayer = AudioPlayer("C4Loop.aif")
        
        self.canvas.addTapGestureRecognizer { (center, location, state) -> () in
            self.audioPlayer.play()
//            print("in tap")
        }
    }
}
