//
//  C4Workspace.h
//  Examples
//
//  Created by Travis Kirton
//

#import "C4Workspace.h"

@interface C4WorkSpace ()
-(void)generatePatternImage;
-(void)setupShapes;
@end

@implementation C4WorkSpace {
    C4Image *patternImage;
    C4Shape *s1, *s2;
}

-(void)setup {
    [self generatePatternImage];
    [self setupShapes];
    [self runMethod:@"test" afterDelay:0.5f];
}

-(void)test {
    s1.animationOptions = REPEAT | LINEAR;
    s1.animationDuration = 33.0f;
    s1.rotation = TWO_PI;
    s2.animationDuration = 44.0f;
    s2.animationOptions = REPEAT | LINEAR;
    s2.rotation = TWO_PI;
}

-(void)generatePatternImage {
    //define dimensions for the image size
    NSInteger width = 16;
    NSInteger height = 16;
    
    //bytes per pixel = 4 because we have 4 values (RGBA)
    NSInteger bytesPerPixel = 4;
    NSInteger bytesPerRow = width * bytesPerPixel;
    //we create an array for our color data
    unsigned char *rawData = malloc(height * bytesPerRow);
    
    //because we're working with raw data, we need to use integer color values
    for(int i = 0; i < height *bytesPerRow; i+=5) {
        //C4GREY colors as RGBA values
        rawData[i] = 50;
        rawData[i + 1] = 55;
        rawData[i + 2] = 60;
        rawData[i + 3] = 255;
    }
    
    //set the pattern image
    patternImage = [[C4Image alloc] initWithRawData:rawData width:width height:height];

    free(rawData);
}

//create 2 shapes and fill them with the pattern image
-(void)setupShapes {
    CGFloat width = self.canvas.width * 0.96f;
    s1 = [C4Shape ellipse:CGRectMake(0, 0, width, width)];
    s1.fillColor = [UIColor colorWithPatternImage:patternImage.UIImage];
    s1.center = self.canvas.center;
    s1.lineWidth = 0.0f;
    [self.canvas addShape:s1];
    
    s2 = [C4Shape ellipse:s1.frame];
    s2.fillColor = [UIColor colorWithPatternImage:patternImage.UIImage];
    s2.lineWidth = 0.0f;
    [self.canvas addShape:s2];
}
@end