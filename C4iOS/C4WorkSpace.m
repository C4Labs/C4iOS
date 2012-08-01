//
//  C4Workspace.h
//  Examples
//
//  Created by Travis Kirton
//

#import "C4Workspace.h"

@implementation C4WorkSpace

-(void)setup {
    //create the pattern images
    C4Image *patternPyramid, *patternLines;
    patternLines = [C4Image imageNamed:@"lines.png"];
    patternPyramid = [C4Image imageNamed:@"pyramid.png"];
    
    //create the shapes
    C4Shape *s1, *s2;
    s1 = [C4Shape rect:CGRectMake(0, 0, 200, 200)];
    s2 = [C4Shape ellipse:CGRectMake(0, 0, 200, 200)];
    
    //set their line widths to be quite thick
    s1.lineWidth = s2.lineWidth = 50.0f;
    
    //set their fill colors with pattern images
    s1.fillColor = [UIColor colorWithPatternImage:patternPyramid.UIImage];
    s2.fillColor = [UIColor colorWithPatternImage:patternLines.UIImage];
    
    //set their stroke colors with pattern images
    s1.strokeColor = [UIColor colorWithPatternImage:patternLines.UIImage];
    s2.strokeColor = [UIColor colorWithPatternImage:patternPyramid.UIImage];
    
    //position them
    s1.center = CGPointMake(self.canvas.center.x, self.canvas.height / 3);
    s2.center = CGPointMake(self.canvas.center.x, self.canvas.height * 2 / 3);
    
    //add them to the canvas
    [self.canvas addShape:s1];
    [self.canvas addShape:s2];
}

@end