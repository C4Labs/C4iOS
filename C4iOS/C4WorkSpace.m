//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"
#import "PlayheadView.h"

@implementation C4WorkSpace {
    C4Image *img;
    C4Movie *m;   
}

-(void)setup {
    //work your magic here
    self.canvas.backgroundColor = [UIColor blackColor];
    
    img = [C4Image animatedImageWithNames:[NSArray arrayWithObjects:
                                           @"whiteCircle01.png",
                                           @"whiteCircle02.png",
                                           @"whiteCircle03.png",
                                           @"whiteCircle04.png",
                                           @"whiteCircle05.png",
                                           @"whiteCircle06.png",
                                           @"whiteCircle07.png",
                                           @"whiteCircle08.png",
                                           @"whiteCircle09.png",
                                           @"whiteCircle10.png",
                                           nil]];
    //    C4Image *img = [C4Image imageNamed:@"whiteCircle01.png"];
//    [self.canvas addImage:img];
    m = [C4Movie movieNamed:@"inception.mov"];
    m.layer.mask = img.layer;
    [self.canvas addMovie:m];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [img play];
}

@end

//@implementation C4WorkSpace {
//    PlayheadView *v;
//}
//
//-(void)setup {
//    v = [[PlayheadView alloc] initWithSample:[C4Sample sampleNamed:@"loop1.wav"]];    
//    
//    v = [PlayheadView alloc];
//    v.loops = YES;
//    [self addShape:v];
//}
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    switch (v.isPlaying) {
//        case YES:
//            [v pause];
//            break;
//        default:
//            [v play];
//            break;
//    }
//}
//@end
