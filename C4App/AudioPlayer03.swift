//
//  AudioPlayer03.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-09.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class AudioPlayer03: CanvasController {
    
    var audioPlayer:AudioPlayer!
    
    override func setup() {
        
        audioPlayer = AudioPlayer("C4Loop.aif")
        let font = Font(name: "Helvetica", size: 30.0)!
        //create text shape to display duration of mp3
        let l = TextShape(text: String(audioPlayer.duration), font: font)!
        l.center = self.canvas.center
        self.canvas.add(l)
        
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
