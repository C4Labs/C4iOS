//
//  Shapes01.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-10.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Shapes01: CanvasController {
    override func setup() {
        
        var rectangle:Rectangle!
        var square:Rectangle!
        var circle:Circle!
        var ellipse:Ellipse!
        
        
        //Create a rectangle
        rectangle = Rectangle(frame: Rect(0,0,100,200))
        
        //Create a square (same w & h)
        square = Rectangle(frame: Rect(0,0,100,100))
        
        //Create an ellipse
        ellipse = Ellipse(frame: rectangle.frame) // same dimensions as rectangle
        
        //Create a circle (same w & h)
        circle = Circle(center: Point(0,0), radius: 50) // same dimensions as square
        
        //Figure out the vertical whitespace (i.e. the space between shapes and the edges of the canvas)
        var whiteSpace = self.canvas.width - 4 * rectangle.width
        
        whiteSpace = whiteSpace/5 // because there are 5 gaps
        
        //center all the shapes to the canvas
        var center = Point()
        center.y = self.canvas.center.y
        
        //set the y position for the rectangle
        center.x = whiteSpace + rectangle.width/2
        rectangle.center = center
        
        //set the y position for the square
        center.x = center.x + whiteSpace + square.height
        square.center = center
        
        //set the y position for the circle
        center.x = center.x + whiteSpace + circle.height
        circle.center = center
        
        //set the y position for the ellipse
        center.x = center.x + whiteSpace + ellipse.width
        ellipse.center = center
        
        //add all the objects to the canvas
        self.canvas.add(rectangle)
        self.canvas.add(square)
        self.canvas.add(circle)
        self.canvas.add(ellipse)
    }
}

