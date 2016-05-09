//
//  Shapes11.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-03.
//  Copyright © 2015 Slant. All rights reserved.
//

import UIKit
import C4

class Shapes11: CanvasController {
    
    var poly1:Polygon = Polygon()
    var poly2:Polygon = Polygon()
    var poly3:Polygon = Polygon()
    
    
    override func setup() {
        self.createAndStylePolygons()
        self.createLabels()
        
        //set the lineJoin property for each shape
        poly1.lineJoin = .Miter //This is the default value
        poly2.lineJoin = .Round
        poly3.lineJoin = .Bevel
    }
    
    func createAndStylePolygons() {
        //the base width for the polygons
        let base:CGFloat = 150
        let height = sqrt(3)/4 * base; // half the height of an equilateral
        let polyPoints = [Point(),Point(75, Int(-height)),Point(150, 0)]
        
        //create poly1 and style it
        poly1 = Polygon(polyPoints)
        poly1.fillColor = Color(UIColor.clearColor())
        poly1.lineWidth = 30.0
        poly1.center = Point(self.canvas.width/4, self.canvas.center.y)
        
        //create poly2 and style it
        poly2 = Polygon(polyPoints)
        poly2.fillColor = Color(UIColor.clearColor())
        poly2.strokeColor = C4Blue
        poly2.lineWidth = 30.0
        poly2.center = self.canvas.center
        poly2.lineJoin = .Round
        
        //create poly3 and style it
        poly3 = Polygon(polyPoints)
        poly3.fillColor = Color(UIColor.clearColor())
        poly3.strokeColor = C4Pink
        poly3.lineWidth = 30.0
        poly3.center = Point(self.canvas.width*3/4, self.canvas.center.y)
        
        //add all the polygons to the canvas
        self.canvas.add(poly1)
        self.canvas.add(poly2)
        self.canvas.add(poly3)
    }
    
    func createLabels() {
        let f = Font(name: "ArialRoundedMTBold", size:30.0)!
        
        //create the JOINMITER label, center it to the base of poly1
        var l = TextShape(text: "JOINMITER", font: f)!
        var center = poly1.center
        center.y += poly1.height
        l.center = center
        self.canvas.add(l)
        
        //create the JOINROUND label, center it to the base of poly2
        l = TextShape(text: "JOINROUND", font: f)!
        center = poly2.center
        center.y += poly2.height
        l.center = center
        self.canvas.add(l)
        
        
        
        //create the JOINBEVEL label, center it to the base of poly3
        l = TextShape(text: "JOINBEVEL", font: f)!
        center = poly3.center
        center.y += poly3.height
        l.center = center
        self.canvas.add(l)
        
        
    }
}