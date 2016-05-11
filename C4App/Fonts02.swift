//
//  Fonts02.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-08.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Fonts02: CanvasController {
    override func setup() {
        //create a regular system font
        var font = Font.systemFont(30.0)
        var label = TextShape(text: "Regular System Font", font: font)!
        label.center = Point(self.canvas.center.x, self.canvas.height / 4.0)
        
        self.canvas.add(label)
        
        //create a bold system font
        font = Font.boldSystemFont(30.0)
        label = TextShape(text: "Bold System Font", font: font)!
        label.center = Point(self.canvas.center.x, self.canvas.height * 2.0 / 4.0)
        
        self.canvas.add(label)
        
        //create a italic system font
        font = Font.italicSystemFont(30.0)
        label = TextShape(text: "Italic System Font", font: font)!
        label.center = Point(self.canvas.center.x, self.canvas.height * 3.0 / 4.0)
        
        self.canvas.add(label)
    }
}