//
//  Views12.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-09.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Views12: CanvasController {
    
    var s1:Rectangle!
    var s2:Rectangle!
    var s3:Rectangle!
    
    override func setup() {
        
        let shapeFrame = Rect(0, 0, 100, 100)
        s1 = Rectangle(frame: shapeFrame)
        s2 = Rectangle(frame: shapeFrame)
        s3 = Rectangle(frame: shapeFrame)
        
        
        var centerPoint = self.canvas.center
        centerPoint.y -= 150
        s1.center = centerPoint;
        centerPoint.y += 150;
        s2.center = centerPoint;
        centerPoint.y += 150;
        s3.center = centerPoint;
        self.canvas.add(s1)
        self.canvas.add(s2)
        //
        //            s1.perspectiveDistance = 75.0
        //            s2.perspectiveDistance = 150.0f;
        //            s3.perspectiveDistance = 1000.0f;
        //
        //            [self setupAnimations];
    }
    //
    //        -(void)setupAnimations{
    //            s1.animationDuration = 2.0f;
    //            s1.animationOptions = LINEAR | REPEAT;
    //            s1.rotationX += TWO_PI;
    //            s2.animationDuration = 2.0f;
    //            s2.animationOptions = LINEAR | REPEAT;
    //            s2.rotationX += TWO_PI;
    //            s3.animationDuration = 2.0f;
    //            s3.animationOptions = LINEAR | REPEAT;
    //            s3.rotationX += TWO_PI;
    //        }
    
}
