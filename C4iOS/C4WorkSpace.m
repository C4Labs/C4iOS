//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    NSMutableArray *skyImages, *tableImagesRight, *tableImagesLeft;
    NSInteger currentImage;
}

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
