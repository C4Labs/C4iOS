//
//  Shapes07.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-02.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
class Shapes07: CanvasController {
    
    var poly1:Polygon!
    var poly2:Polygon!
    
    override func setup() {
        
        self.createAndStylePolygons()
        self.createLabels()
        
        //define the fill rules for each polygon
        poly1.fillRule = .NonZero//Default value
        poly2.fillRule = .EvenOdd;
    }
    
    
    func createAndStylePolygons() {
        
        let polyPoints = [Point(), Point(150, -150), Point(200, -100), Point(100, 0), Point(0, -100), Point(50,-150), Point(200,0)]
        
        
        //create poly1 and style it
        poly1 =  Polygon(polyPoints)
        poly1.center = Point(self.canvas.width/3, self.canvas.center.y);
        
        //create poly2 and style it
        poly2 = Polygon(polyPoints)
        poly2.center = Point(self.canvas.width*2/3, self.canvas.center.y);
        
        
        
        //add all the polygons to the canvas
        self.canvas.add(poly1)
        self.canvas.add(poly2)
    }
    
    
    func createLabels() {
        
        let f = Font(name: "ArialRoundedMTBold", size: 30)!
        
        
        //create the FILLNORMAL label, center it to the base of poly1
        let lableNormal =  TextShape(text: ".NonZero", font: f)!
        
        var center = poly1.center
        center.y += poly1.height/2 + lableNormal.height
        lableNormal.center = center;
        self.canvas.add(lableNormal)
        
        //create the FILLEVENODD label, center it to the base of poly2
        let labelEvenOdd =  TextShape(text: ".EvenOdd", font: f)!
        center = poly2.center
        center.y += poly2.height/2 + labelEvenOdd.height
        labelEvenOdd.center = center
        self.canvas.add(labelEvenOdd)
    }
}