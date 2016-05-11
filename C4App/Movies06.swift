//
//  Movies06.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-08.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Movies06: CanvasController {
    
    
    var movie:Movie!
    
    override func setup() {
        //create a movie and play it automatically
        let movie = Movie("halo.mp4")!
//        movie.reachedEnd {
//            let s = Ellipse(frame: movie.frame)
//            movie.layer?.mask = s.layer
//            let a = ViewAnimation(duration: 2) {
//                s.transform.rotate(M_PI)
//            }
//            a.repeats = true
//            a.animate()
//        }
        movie.frame = Rect(0, 0, self.canvas.frame.max.x,self.canvas.frame.max.y)
        movie.loops = false
        movie.play()
        self.canvas.add(movie)
    }

}