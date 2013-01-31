//
//  C4WorkSpace.m
//  Examples
//
//  Created by Greg Debicki.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *s1, *s2, *s3;
    NSInteger count;
    C4Label *label1, *label2, *label3;
    C4Font *customFont;
    NSString *string;
}

-(void)setup {
    
    [self setupShapes];
    
    s1.zPosition = 3;
    s2.zPosition = 2;
    s3.zPosition = 1;
    
    [self performSelector:@selector(setupLabels) withObject:Nil afterDelay:0.05f];
    [self performSelector:@selector(updateLabels) withObject:Nil afterDelay:0.1f];
    
    count = 1;
    
}

-(void)touchesBegan {
    count++;
    
    if (count == 1 ) {
        s1.zPosition = 3;
        s2.zPosition = 2;
        s3.zPosition = 1;
    }
    if (count == 2 ) {
        s1.zPosition = 2;
        s2.zPosition = 3;
        s3.zPosition = 1;
    }
    if (count == 3 ) {
        s1.zPosition = 1;
        s2.zPosition = 2;
        s3.zPosition = 3;
    }
    if (count == 4) {
        count = 0;
    }
    
    if (count == 0){
        s1.zPosition = 2;
        s2.zPosition = 3;
        s3.zPosition = 1;
    }
    [self updateLabels];
    //    [self performSelector:@selector(updateLabels) withObject:Nil afterDelay:0.05f];
    
}

-(void) setupShapes {
    
    CGRect rect = CGRectMake(0, 0, 125, 250);
    
    s1 = [C4Shape rect:rect];
    s2 = [C4Shape rect:rect];
    s3 = [C4Shape rect:rect];
    
    [self.canvas addShape:s1];
    [self.canvas addShape:s2];
    [self.canvas addShape:s3];
    
    CGPoint currentCenter = self.canvas.center;
    
    currentCenter.x -= 100;
    currentCenter.y -= 50;
    s1.center = currentCenter;
    
    currentCenter.x += 100;
    currentCenter.y += 50;
    s2.center = currentCenter;
    
    currentCenter.x += 100;
    currentCenter.y += 50;
    s3.center = currentCenter;
    
}

-(void) updateLabels {
    string = [[NSString alloc]initWithFormat:@"%i", (NSInteger)s1.zPosition];
    label1.text = string;
    string = [[NSString alloc]initWithFormat:@"%i", (NSInteger)s2.zPosition];
    label2.text = string;
    string = [[NSString alloc]initWithFormat:@"%i", (NSInteger)s3.zPosition];
    label3.text = string;
}

-(void)setupLabels {
    customFont = [C4Font fontWithName:@"Helvetica" size:25.0f];
    
    string = [[NSString alloc]initWithFormat:@"%i", (NSInteger)s1.zPosition];
    label1 = [C4Label labelWithText:string font:customFont];
    
    string = [[NSString alloc]initWithFormat:@"%i", (NSInteger)s2.zPosition];
    label2 = [C4Label labelWithText:string font:customFont];
    
    string = [[NSString alloc]initWithFormat:@"%i", (NSInteger)s3.zPosition];
    label3 = [C4Label labelWithText:string font:customFont];
    
    [self addLabel:label1];
    [self addLabel:label2];
    [self addLabel:label3];
    
    CGPoint currentCenter = s1.center;
    currentCenter.y += 150;
    label1.center = currentCenter;
    
    currentCenter = s2.center;
    currentCenter.y += 150;
    label2.center = currentCenter;
    
    currentCenter = s3.center;
    currentCenter.y += 150;
    label3.center = currentCenter;
    
}

@end