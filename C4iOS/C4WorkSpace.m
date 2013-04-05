//
// C4WorkSpace.m
//
// Created by Greg Debicki.
//

<<<<<<< HEAD
@implementation C4WorkSpace {
    C4Shape *s;
}

-(void)setup {
    s = [C4Shape ellipse:CGRectMake(0, 0, 200, 200)];
    s.center = self.canvas.center;
    [self.canvas addShape:s];
}

-(void)touchesBegan {
    [self runMethod:@"changeFillColor:" withObject:s afterDelay:1.0f];
}

-(void)changeFillColor:(C4Shape *)shape {
    shape.fillColor = [UIColor colorWithRed:[C4Math randomInt:100]/100.0f
                                      green:[C4Math randomInt:100]/100.0f
                                       blue:[C4Math randomInt:100]/100.0f
                                      alpha:1.0f];
}

=======
#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4ScrollView *scrollview;
    C4Image *table;
}

-(void)setup {
    table = [C4Image imageNamed:@"C4Table"];
    scrollview = [C4ScrollView scrollView:CGRectMake(0, 0, 320, 240)];
    scrollview.contentSize = table.frame.size;
    scrollview.borderColor = C4GREY;
    scrollview.borderWidth = 1.0f;
    scrollview.center = self.canvas.center;
    
    [scrollview addImage:table];
    [self.canvas addSubview:scrollview];
}

>>>>>>> Fixed some dictionary issues in C4Shape
@end