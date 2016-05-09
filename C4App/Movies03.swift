//
//  Movies03.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-08.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Movies03: CanvasController {
    
    var playIfTrue = true
    
    override func setup() {
        //create a movie and play it automatically
        let movie = Movie("halo.mp4")!
        movie.center = self.canvas.center
        movie.play()
        let a = ViewAnimation(duration: 1.5) {
            movie.height = 200
        }
        a.repeats = false
        a.autoreverses = true
        canvas.addTapGestureRecognizer { (center, location, state) -> () in
            a.animate()
        }
        
        self.canvas.add(movie)
    }
    
    
}
