//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"
<<<<<<< HEAD
<<<<<<< HEAD
@implementation C4WorkSpace
=======
@implementation C4WorkSpace {
    NSMutableArray *skyImages, *tableImagesRight, *tableImagesLeft;
    NSInteger currentImage;
}
>>>>>>> Examples

-(void)setup {
    CGFloat h = self.canvas.height / 17.0f;
    CGFloat padding = h / 16.0f;

    skyImages = [@[] mutableCopy];
    for(int i = 0; i < 16; i++) {
        C4Image *img = [C4Image imageNamed:@"C4Sky.png"];
        img.height = h;
        img.center = CGPointMake(self.canvas.center.x, self.canvas.height * i / 17.0f+i*padding+(h+padding)/2.0f);
        img.perspectiveDistance = 500.0f;
        [skyImages addObject:img];
        [self.canvas addImage:img];
    }

    tableImagesRight = [@[] mutableCopy];
    for(int i = 0; i < 16; i++) {
        C4Image *img = [C4Image imageNamed:@"C4Table.png"];
        img.height = h;
        img.anchorPoint = CGPointMake(-2.0f,0.5f);
        img.center = CGPointMake(self.canvas.center.x, self.canvas.height * i / 17.0f+i*padding+(h+padding)/2.0f);
        img.perspectiveDistance = 500.0f;
        [tableImagesRight addObject:img];
        [self.canvas addImage:img];
    }

    tableImagesLeft = [@[] mutableCopy];
    for(int i = 0; i < 16; i++) {
        C4Image *img = [C4Image imageNamed:@"C4Table.png"];
        img.height = h;
        img.anchorPoint = CGPointMake(3.0f,0.5f);
        img.center = CGPointMake(self.canvas.center.x, self.canvas.height * i / 17.0f+i*padding+(h+padding)/2.0f);
        img.perspectiveDistance = 500.0f;
        [tableImagesLeft addObject:img];
        [self.canvas addImage:img];
    }

    currentImage = 0;
    [self runMethod:@"animate" afterDelay:0.1f];
}

-(void)animate {
    C4Image *sky = skyImages[currentImage];
    sky.animationDuration = 4.0f;
    sky.animationOptions = LINEAR | REPEAT;
    sky.rotationY = TWO_PI;

<<<<<<< HEAD
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
=======
    C4Image *table;
    table = tableImagesRight[currentImage];
    table.animationDuration = 4.0f;
    table.animationOptions = LINEAR | REPEAT;
    table.rotationY = TWO_PI;

    table = tableImagesLeft[currentImage];
    table.animationDuration = 4.0f;
    table.animationOptions = LINEAR | REPEAT;
    table.rotationY = TWO_PI;

    currentImage++;
    if(currentImage < [skyImages count]) {
        [self runMethod:@"animate" afterDelay:0.25f];
    }
}

@end
>>>>>>> Examples
