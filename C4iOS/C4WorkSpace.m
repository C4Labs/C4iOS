//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"
<<<<<<< HEAD
@implementation C4WorkSpace

-(void)setup {
    C4Image *image = [C4Image imageNamed:@"C4Sky"];
    image.width = 180.0f;
    image.anchorPoint = CGPointMake(-0.5f,0.5f);
    image.center = self.canvas.center;
    [self.canvas addImage:image];
    
    C4Shape *c1, *c2;
    c1 = [C4Shape ellipse:CGRectMake(0, 0, 20, 20)];
    c1.fillColor = [UIColor clearColor];
    c1.strokeColor = C4RED;
    c1.center = image.origin;
    
    c2 = [C4Shape ellipse:CGRectMake(0, 0, 20, 20)];
    c2.fillColor = [UIColor clearColor];
    c2.strokeColor = C4RED;
    c2.center = image.center;
    
    image.backgroundColor = C4BLUE;
    image.borderColor = C4RED;
    image.borderWidth = 1.0f;
    
    [self.canvas addObjects:@[c1,c2]];
}

@end

//@implementation C4WorkSpace {
//    NSMutableArray *skyImages, *tableImagesRight, *tableImagesLeft;
//    NSInteger currentImage;
//}
//
//-(void)setup {
//    CGFloat h = self.canvas.height / 17.0f;
//    CGFloat padding = h / 16.0f;
//
//    skyImages = [@[] mutableCopy];
//    for(int i = 0; i < 16; i++) {
//        C4Image *img = [C4Image imageNamed:@"C4Sky.png"];
//        img.height = h;
//        img.center = CGPointMake(self.canvas.center.x, self.canvas.height * i / 17.0f+i*padding+(h+padding)/2.0f);
//        img.perspectiveDistance = 500.0f;
//        [skyImages addObject:img];
//        [self.canvas addImage:img];
//    }
//
//    tableImagesRight = [@[] mutableCopy];
//    for(int i = 0; i < 16; i++) {
//        C4Image *img = [C4Image imageNamed:@"C4Table.png"];
//        img.height = h;
//        img.anchorPoint = CGPointMake(-2.0f,0.5f);
//        img.center = CGPointMake(self.canvas.center.x, self.canvas.height * i / 17.0f+i*padding+(h+padding)/2.0f);
//        img.perspectiveDistance = 500.0f;
//        [tableImagesRight addObject:img];
//        [self.canvas addImage:img];
//    }
//
//    tableImagesLeft = [@[] mutableCopy];
//    for(int i = 0; i < 16; i++) {
//        C4Image *img = [C4Image imageNamed:@"C4Table.png"];
//        img.height = h;
//        img.anchorPoint = CGPointMake(3.0f,0.5f);
//        img.center = CGPointMake(self.canvas.center.x, self.canvas.height * i / 17.0f+i*padding+(h+padding)/2.0f);
//        img.perspectiveDistance = 500.0f;
//        [tableImagesLeft addObject:img];
//        [self.canvas addImage:img];
//    }
//
//    currentImage = 0;
//    [self runMethod:@"animate" afterDelay:0.1f];
//}
//
//-(void)animate {
//    C4Image *sky = skyImages[currentImage];
//    sky.animationDuration = 4.0f;
//    sky.animationOptions = LINEAR | REPEAT;
//    sky.rotationY = TWO_PI;
//
//    C4Image *table;
//    table = tableImagesRight[currentImage];
//    table.animationDuration = 4.0f;
//    table.animationOptions = LINEAR | REPEAT;
//    table.rotationY = TWO_PI;
//
//    table = tableImagesLeft[currentImage];
//    table.animationDuration = 4.0f;
//    table.animationOptions = LINEAR | REPEAT;
//    table.rotationY = TWO_PI;
//
//    currentImage++;
//    if(currentImage < [skyImages count]) {
//        [self runMethod:@"animate" afterDelay:0.25f];
//    }
//}
//
//@end
=======

@implementation C4WorkSpace

-(void)setup {
    C4Image *img1 = [C4Image imageNamed:@"C4Sky"];
    C4Image *img2 = [C4Image imageNamed:@"C4Table"];
    
    img1.width = 180;
    img2.width = 180;
    
    img2.anchorPoint = CGPointMake(-1.0f,0.5f);
    
    img1.center = self.canvas.center;
    img2.center = self.canvas.center;
    
    [self.canvas addObjects:@[img1,img2]];
    
    img1.rotation = QUARTER_PI;
    img2.rotation = QUARTER_PI;
}

@end
>>>>>>> Examples
