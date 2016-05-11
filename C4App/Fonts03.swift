//
//  Fonts03.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-08.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Fonts03: CanvasController {
    override func setup() {
        
        //Best seen on iPad / iPad simulator
        //create a text string that will be used for all labels
        var textString:String!
        
        //create an initial font
        var f = Font(name:"ArialRoundedMTBold", size:45.0)!
        
        //create a point to reuse for all labels
        var p = Point(10, 0);
        
        //create an initial label, position it, add it to the canvas
        var l = TextShape(text: "Font Properties", font: f)!
        l.origin = p
        p.y += l.height + 10; //update p for the next label
        self.canvas.add(l)
        //change the font size
        f = f.font(30.0)
        
        //create a formatted string, with the current property variable, create a label...
        textString = "Family name: \(f.familyName)";
        l = TextShape(text: textString, font: f)!
        l.origin = p
        p.y += l.height + 10
        self.canvas.add(l)
        
        textString = "Font name: \(f.fontName)";
        l = TextShape(text: textString, font: f)!
        l.origin = p;
        p.y += l.height + 10;
        self.canvas.add(l)
        
        textString = String.localizedStringWithFormat("Point size: %.2f", f.pointSize)
        l = TextShape(text: textString, font: f)!
        l.origin = p;
        p.y += l.height + 10;
        self.canvas.add(l)
        
        textString = String.localizedStringWithFormat("Ascender: %.2f", f.ascender)
        l = TextShape(text: textString, font: f)!
        l.origin = p;
        p.y += l.height + 10;
        self.canvas.add(l)
        
        textString = String.localizedStringWithFormat("Descender: %.2f", f.descender)
        l = TextShape(text: textString, font: f)!
        l.origin = p;
        p.y += l.height + 10;
        self.canvas.add(l)
        
        textString = String.localizedStringWithFormat("Cap Height: %.2f", f.capHeight)
        l = TextShape(text: textString, font: f)!
        l.origin = p;
        p.y += l.height + 10;
        self.canvas.add(l)
        
        textString = String.localizedStringWithFormat("X-Height: %.2f", f.xHeight)
        l = TextShape(text: textString, font: f)!
        l.origin = p;
        p.y += l.height + 10;
        self.canvas.add(l)
        
        textString = String.localizedStringWithFormat("Line Height: %.2f", f.lineHeight)
        l = TextShape(text: textString, font: f)!
        l.origin = p;
        p.y += l.height + 10;
        self.canvas.add(l)
    }
}
