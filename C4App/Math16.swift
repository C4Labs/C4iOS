//
//  Math16.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-21.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Math16: CanvasController {
    
    var line:Line!
    var slider = UISlider()
    var pts = [Point(), Point(150,300)]
    
    override func setup() {
        let slider = UISlider(frame: CGRect(x: 0,y: 0,width: 300,height: 44))
        slider.center = canvas.view.center
        canvas.add(slider)
        slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
        line = Line(pts)
        
        canvas.add(line)
        
    }
    func sliderValueChanged(sender: UISlider) {
        canvas.remove(line)
        pts = [Point(), Point(150,300)]

        pts[0] = lerp(pts[0], pts[1], at: Double(sender.value))
        line = Line(pts)
        canvas.add(line)
    }
}