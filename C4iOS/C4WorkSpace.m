//
//  C4Workspace.h
//  Examples
//
//  Created by Travis Kirton
//

#import "C4Workspace.h"

@interface C4WorkSpace ()
-(void)setupShapes;
-(void)setupLabels;
@end

@implementation C4WorkSpace {
    C4Shape *red, *blue, *grey;
    
    CGFloat redColorComponents[4], blueColorComponents[4], greyColorComponents[4];
}

-(void)setup {
    [self setupShapes];

    [red.fillColor getRed:&redColorComponents[0]
                    green:&redColorComponents[1]
                     blue:&redColorComponents[2]
                    alpha:&redColorComponents[3]];
    
    [blue.fillColor getRed:&blueColorComponents[0]
                     green:&blueColorComponents[1]
                      blue:&blueColorComponents[2]
                     alpha:&blueColorComponents[3]];
//
//    [grey.fillColor getRed:&greyColorComponents[0]
//                     green:&greyColorComponents[1]
//                      blue:&greyColorComponents[2]
//                     alpha:&greyColorComponents[3]];

    [self setupLabels];
}

-(void)setupShapes {
    CGRect frame = CGRectMake(0, 0, self.canvas.width*0.9f, self.canvas.height/5.0f);
    red =  [C4Shape rect:frame];
    blue = [C4Shape rect:frame];
    grey = [C4Shape rect:frame];
    
    red.fillColor  = [UIColor magentaColor];
    blue.fillColor = red.fillColor;
    grey.fillColor = C4GREY;
    
//    CGFloat components[4];
//    [red.fillColor getRed:&components[0]
//                 green:&components[1]
//                  blue:&components[2]
//                 alpha:&components[3]];
//    C4Log(@"%4.2f,%4.2f,%4.2f,%4.2f",components[0],components[1],components[2],components[3]);
//
//    
    red.lineWidth = blue.lineWidth = grey.lineWidth = 0.0f;
    
    red.center  = CGPointMake(self.canvas.center.x, self.canvas.height/4);
    blue.center = CGPointMake(self.canvas.center.x, self.canvas.height*2/4);
    grey.center = CGPointMake(self.canvas.center.x, self.canvas.height*3/4);
    
    [self.canvas addShape:red];
    [self.canvas addShape:blue];
    [self.canvas addShape:grey];
}

-(void)setupLabels {
    C4Font *f = [C4Font fontWithName:@"ArialRoundedMTBold" size:30.0f];
    C4Label *l;
    
    NSString *colorString = [NSString stringWithFormat:@"{%4.2f,%4.2f,%4.2f,%4.2f}",
                             redColorComponents[0],
                             redColorComponents[1],
                             redColorComponents[2],
                             redColorComponents[3]];

    l = [C4Label labelWithText:colorString font:f];
    l.textColor = [UIColor whiteColor];
    l.center = red.center;
    [self.canvas addLabel:l];
    
    NSString *bluecolorString = [NSString stringWithFormat:@"{%4.2f,%4.2f,%4.2f,%4.2f}",
                   blueColorComponents[0],
                   blueColorComponents[1],
                   blueColorComponents[2],
                   blueColorComponents[3]];
    l = [C4Label labelWithText:bluecolorString font:f];
    l.textColor = [UIColor whiteColor];
    l.center = blue.center;
    [self.canvas addLabel:l];
    
    colorString = [NSString stringWithFormat:@"{%4.2f,%4.2f,%4.2f,%4.2f}",
                   greyColorComponents[0],
                   greyColorComponents[1],
                   greyColorComponents[2],
                   greyColorComponents[3]];
    l = [C4Label labelWithText:colorString font:f];
    l.textColor = [UIColor whiteColor];
    l.center = grey.center;
    [self.canvas addLabel:l];
}
@end