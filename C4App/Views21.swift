//
//  Views21.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-10.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Views21: CanvasController {
    
    var still:Image!
    var animated:Image!
    
    
    override func setup() {

    setupImages()
//    still.layer?.mask = animated.layer
    }
    
    func setupImages() {
    still = Image("chop")!
    still.height = 240.0
    still.center = self.canvas.center
self.canvas.add(still)
        //NOTE: You need to have the following images in your project
    // You can replace these names with any image sequence
//    animated = [Image animatedImageWithNames:@[
//    @"C4Spin00.png",
//    @"C4Spin01.png",
//    @"C4Spin02.png",
//    @"C4Spin03.png",
//    @"C4Spin04.png",
//    @"C4Spin05.png",
//    @"C4Spin06.png",
//    @"C4Spin07.png",
//    @"C4Spin08.png",
//    @"C4Spin09.png",
//    @"C4Spin10.png",
//    @"C4Spin11.png"
//    ]];
//    animated.center = CGPointMake(still.width/2,still.height/2);
//    animated.animatedImageDuration = 1.0f;
//    animated.width = still.width;
//    [self.canvas addSubview:animated];
//    [animated play];
    
    }
}
