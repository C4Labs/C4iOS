//
//  Colors03.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-08.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Colors03: CanvasController {
    
    //we use an array of shapes and for() loops to set styles
    var shapes = [Shape]()
    
    override func setup() {
        setupShapes()
        setupLabels()
        
        //We cast each object in the array to a Shape object, and then set its color
        shapes[0].fillColor = black
        shapes[1].fillColor = darkGray
        shapes[2].fillColor = lightGray
        shapes[3].fillColor = gray
        shapes[4].fillColor = red
        shapes[5].fillColor = green
        shapes[6].fillColor = blue
        shapes[7].fillColor = cyan
        shapes[8].fillColor = yellow
        shapes[9].fillColor = magenta
        shapes[10].fillColor = orange
        shapes[11].fillColor = purple
        shapes[12].fillColor = brown
        shapes[13].fillColor = white
        shapes[14].fillColor = clear
    }
    
    func setupShapes() {
        //create a frame for building each shape
        let frame = Rect(0, 0, self.canvas.width*0.9, self.canvas.height/20.0)
        
        //create an array of 15 shapes
        for _ in 0..<15 {
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
        
        //we create a shadow so that we can see the white shape
        let white = shapes[13]
        white.shadow.offset = Size(3, 3)
        white.shadow.opacity = 0.8
        
        //we create an outlined clear shape with shadow to see that its fill color is transparent
        let clear = shapes[14]
        clear.shadow.offset = Size(3, 3)
        clear.shadow.opacity = 0.8
        clear.lineWidth = 1.0
        clear.strokeColor = darkGray
    }
    
    func setupLabels() {
        //create a font for the labels
        let f = Font(name: "ArialRoundedMTBold", size: 20.0)!
        var l:TextShape!
        
        //create an array of texts for the label
        let labelTexts = ["black", "darkGray", "lightGray", "gray",
            "red", "green", "blue", "cyan", "yellow", "magenta",
            "orange", "purple", "brown", "white", "clear"]
        
        //create a label for each shape and add it to the canvas
        for i in 0..<labelTexts.count {
            l = TextShape(text: labelTexts[i], font: f)
            //all labels will be white except the last two
            if(i < 13) {
                l.fillColor = white
            } else {
                l.fillColor = darkGray
            }
            l.center = shapes[i].center;
            self.canvas.add(l)
        }
    }
}

