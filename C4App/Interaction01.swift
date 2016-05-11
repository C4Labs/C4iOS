//
//  Interaction01.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-16.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Interaction01: CanvasController {
    
    let s1 = Circle(center: Point(), radius: 50)
    let s2 = Circle(center: Point(), radius: 50)

    override func setup() {

        s1.fillColor = C4Pink
        s1.center = self.canvas.center
        s1.center.y -= 75
        s2.center = self.canvas.center
        s2.center.y += 75

        s1.addTapGestureRecognizer { (center,location, state) -> () in
            self.s1.fillColor = C4Pink
            self.s1.post("tapped")
        }
        s2.addTapGestureRecognizer { (center,location, state) -> () in
            self.s2.fillColor = C4Blue
            self.s2.post("tapped")
        }
        canvas.addTapGestureRecognizer { (center,location, state) -> () in
            self.canvas.backgroundColor = C4Grey
            self.canvas.layer?.post("tapped")
        }
        self.s1.on(event: "tapped", from: self.canvas.layer) { (Void) -> Void in
            self.s1.fillColor = self.canvas.backgroundColor
        }
        self.s2.layer?.on(event: "tapped", from: self.canvas.layer) { (Void) -> Void in
            self.s2.fillColor = self.canvas.backgroundColor
        }
        canvas.on(event: "tapped", from: s1) { (Void) -> Void in
            self.canvas.backgroundColor = self.s1.fillColor
        }
        canvas.on(event: "tapped", from: s2) { (Void) -> Void in
            self.canvas.backgroundColor = self.s2.fillColor
        }
        canvas.add(s1)
        canvas.add(s2)
        

    }
}
