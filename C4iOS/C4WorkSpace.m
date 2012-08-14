//
//  C4Workspace.h
//  Examples
//
//  Created by Travis Kirton
//

#import "C4Workspace.h"

@implementation C4WorkSpace {
    C4GL *gl;
}

//this example uses a default renderer
-(void)setup {
    //create a frame based on the width of the canvas
    CGFloat width = self.canvas.width*0.9f;
    CGRect frame = CGRectMake(0, 0, width, width*.66f);
    
    //create the gl object with the frame
    gl = [C4GL glWithFrame:frame];
    gl.center = self.canvas.center;
    gl.userInteractionEnabled = NO;
    [self.canvas addGL:gl];
    
    [gl startAnimation];
}

//toggle the animation based on touching the canvas
-(void)touchesBegan {
    if (gl.isAnimating) [gl stopAnimation];
    else [gl startAnimation];
}

@end