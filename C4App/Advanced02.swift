//
//  Advanced02.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-14.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Advanced02: CanvasController {
    
    var line:Line!
    
    override func setup() {
        let linePoints = [Point(), Point()]
        line = Line(linePoints)
        canvas.addPanGestureRecognizer({ (center, location, translation, velocity, state) -> () in
            

            self.line.endPoints = (self.canvas.center,location)
            self.line.strokeColor = C4Blue
            self.canvas.add(self.line)
            
            if (state == .Ended){
                self.canvas.remove(self.line)
            }
        })
    }
}
