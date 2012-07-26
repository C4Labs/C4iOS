//
//  C4WorkSpace.m
//  Examples
//
//  Created by Travis Kirton on 12-07-19.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@interface C4WorkSpace ()
-(void)createLines;
@end

@implementation C4WorkSpace {
    CGPoint endPoints[2];
    C4Shape *line1, *line2, *line3, *line4, *line5;
}

-(void)setup {
    //create all the lines
    [self createLines];
    
    //create a 4-point pattern
    CGFloat gap = line1.width / 220.0f;
    NSInteger patternCount = 20;
    CGFloat pattern[20] = {1*gap,1*gap,2*gap,2*gap,3*gap,3*gap,4*gap,4*gap,5*gap,5*gap,6*gap,6*gap,7*gap,7*gap,8*gap,8*gap,9*gap,9*gap,10*gap,10*gap};
    CGFloat patternWidth;
    for(int i = 0; i < 20; i ++) {
        patternWidth += pattern[i];
    }
    
    [line1 setDashPattern:pattern pointCount:patternCount];

    [line2 setDashPattern:pattern pointCount:patternCount];
    line2.lineDashPhase = patternWidth*.25f;

    [line3 setDashPattern:pattern pointCount:patternCount];
    line3.lineDashPhase = patternWidth*.5f;
    
    [line4 setDashPattern:pattern pointCount:patternCount];
    line4.lineDashPhase = patternWidth*.75f;
    
    [line5 setDashPattern:pattern pointCount:patternCount];
    line5.lineDashPhase = patternWidth;
}

-(void)createLines {
    //create 2 end points
    endPoints[0] = CGPointZero;
    endPoints[1] = CGPointMake(self.canvas.width*0.9f,0);
    
    //create 5 lines
    line1 = [C4Shape line:endPoints];
    line2 = [C4Shape line:endPoints];
    line3 = [C4Shape line:endPoints];
    line4 = [C4Shape line:endPoints];
    line5 = [C4Shape line:endPoints];
    
    //center all the lines
    CGPoint center = self.canvas.center;
    center.y = self.canvas.height/6;
    
    line1.center = center;
    
    center.y += self.canvas.height/6;
    line2.center = center;
    
    center.y += self.canvas.height/6;
    line3.center = center;
    
    center.y += self.canvas.height/6;
    line4.center = center;
    
    center.y += self.canvas.height/6;
    line5.center = center;
    
    //set their line widths
    line1.lineWidth = 30.0f;
    line2.lineWidth = 30.0f;
    line3.lineWidth = 30.0f;
    line4.lineWidth = 30.0f;
    line5.lineWidth = 30.0f;
    
    //add them to the canvas
    [self.canvas addShape:line1];
    [self.canvas addShape:line2];
    [self.canvas addShape:line3];
    [self.canvas addShape:line4];
    [self.canvas addShape:line5];

    endPoints[0].x = self.canvas.center.x +0.5f;
    endPoints[0].y = 0;
    endPoints[1].x = self.canvas.center.x+0.5f;
    endPoints[1].y = self.canvas.height;
    
    C4Shape *gridLine = [C4Shape line:endPoints];
    gridLine.lineWidth = 1.0f;
    gridLine.strokeColor = C4GREY;
    [self.canvas addShape:gridLine];
}

-(void)touchesBegan {
    line1.pointA = CGPointMake(100,0);
}
@end
