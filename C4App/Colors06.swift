//
//  Colors06.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-08.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Colors06: CanvasController {
    
    //we use an array of shapes and for() loops to set styles
    var shapes = [Shape]()
    
    override func setup() {
        setupShapes()
        setupLabels()
        
        //We cast each object in the array to a Shape object, and then set its color
        shapes[0].fillColor = Color(UIColor.darkTextColor())
        //lightTextColor is actually white with 60% opacity
        shapes[1].fillColor = Color(UIColor.lightTextColor())
        //on iPad groupTableViewBackgroundColor is equivalent to [UIColor clearColor]
        shapes[2].fillColor = Color(UIColor.groupTableViewBackgroundColor())
        
    }
    
    func setupShapes() {
        //create a frame for building each shape
        let frame = Rect(0, 0, self.canvas.width*0.9, self.canvas.height/20.0)
        
        //create an array of 15 shapes
        for _ in 0...2 {
            shapes.append(Rectangle(frame: frame))
            
        }
        
        //create a point that we can update to se the position of each object
        var center = self.canvas.center
        let dy = self.canvas.height / 16.0
        center.y = dy;
        
        //for every shape, update its linewidth, position and add it to the canvas
        for shape in shapes {
            shape.lineWidth = 0.0
            shape.center = center
            center.y += dy;
            self.canvas.add(shape)
        }
        
        //[UIColor lightTextColor] is actually WHITE, with a 0.6 opacity
        //So, we set it to darkTextColor to see the difference between it and it's label
        shapes[1].backgroundColor = Color(UIColor.darkTextColor())
        shapes[2].shadow.offset = Size(5,5)
        shapes[2].shadow.opacity = 0.8
        shapes[2].lineWidth = 1.0
        shapes[2].strokeColor = C4Grey
        
    }
    
    func setupLabels() {
        //create a font for the labels
        let f = Font(name: "ArialRoundedMTBold", size: 20.0)!
        var l:TextShape!
        
        //create an array of texts for the label
        let labelTexts = ["Dark", "Light", "Grouped"]
        
        //create a label for each shape and add it to the canvas
        for i in 0..<labelTexts.count {
            l = TextShape(text: labelTexts[i], font: f)
            //all labels will be white except the last two
            if(i < 2) {
                l.fillColor = white
            } else {
                l.fillColor = darkGray
            }
            l.center = shapes[i].center;
            self.canvas.add(l)
        }
    }
}