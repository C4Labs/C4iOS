//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"
#import "C4Image.h"

@implementation C4WorkSpace {
    C4Image *still;
    C4Image *animated;
    UIImageView *uiiv;
}

-(void)setup {
    [self setupImages];
    still.mask = animated;
    [self rotate];
}

-(void)rotate {
    animated.animationOptions = REPEAT | LINEAR;
    animated.animationDuration = 6.0f;
    animated.rotation = TWO_PI;
}

-(void)setupImages {
    still = [C4Image imageNamed:@"C4Sky"];
    still.height = 240.0f;
    still.center = self.canvas.center;
    [self.canvas addImage:still];
    
    animated = [C4Image animatedImageWithNames:@[
                @"C4Spin00.png",
                @"C4Spin01.png",
                @"C4Spin02.png",
                @"C4Spin03.png",
                @"C4Spin04.png",
                @"C4Spin05.png",
                @"C4Spin06.png",
                @"C4Spin07.png",
                @"C4Spin08.png",
                @"C4Spin09.png",
                @"C4Spin10.png",
                @"C4Spin11.png"
                ]];
//    animated = [NewImage imageNamed:@"C4Spin00"];
    animated.center = CGPointMake(still.width/2,still.height/2);
    animated.animatedImageDuration = 1.0f;
    [self.canvas addSubview:animated];
    [animated play];
}

-(void)touchesBegan {
    if(animated.isAnimating == YES) [animated pause];
    else [animated play];
}

@end