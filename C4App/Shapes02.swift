//
//  Shapes01.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-01.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Shapes02 : CanvasController {
    override func setup() {
        //create a 2 point array for the line
        let linePts = [Point(100,100),Point(200,200)]
        let line = Line(linePts)
        
        //create a 3 point array for the triangle
        let trianglePts = [Point(0,100), Point(100,100), Point(100,0)]
        let triangle = Triangle(trianglePts)
        
        //create a 4 point array for the polygon
        let polygonPts = [Point(0,0), Point(100,0), Point(100,100), Point(0,100)]
        let polygon = Polygon(polygonPts)
        
        //create an array between 10 and 20 points for the random shape
        var array = [Point]()
        
        let randomCount = random(min: 10, max: 20)
        for _ in 0..<randomCount {
            let p = Point(random(below:100),random(below:100))
            array.append(p)
        }
        let randomPolygon = Polygon()
        randomPolygon.points = array
        
        //Figure out the vertical whitespace (i.e. the space between shapes and the edges of the canvas)
        let ch = canvas.width
        let th = line.width + triangle.width + polygon.width + randomPolygon.width
        var whiteSpace = ch - th
        
        whiteSpace = whiteSpace/5; // because there are 5 gaps
        
        //create a point that will define the center of each shape, aligned to the middle of the canvas
        var center = Point()
        center.y = self.canvas.center.y
        
        //set the y position for the line
        center.x = whiteSpace + line.width/2
        line.center = center
        
        //set the y position for the triangle
        center.x = center.x + whiteSpace + triangle.height
        triangle.center = center
        
        //set the y position for the polygon
        center.x = center.x + whiteSpace + polygon.height
        polygon.center = center
        
        //set the y position for the random shape
        center.x = center.x + whiteSpace + randomPolygon.height;
        randomPolygon.center = center;
        
        //add shapes to canvas
        self.canvas.add(line)
        self.canvas.add(triangle)
        self.canvas.add(polygon)
        self.canvas.add(randomPolygon)
        
    }
}
