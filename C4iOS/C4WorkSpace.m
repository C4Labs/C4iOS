#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Image *animatedImage;
    C4Slider *durationSlider;
}

-(void)setup {
    animatedImage = [C4Image animatedImageWithNames:@[
                     @"C4Spin00",
                     @"C4Spin01",
                     @"C4Spin02",
                     @"C4Spin03",
                     @"C4Spin04",
                     @"C4Spin05",
                     @"C4Spin06",
                     @"C4Spin07",
                     @"C4Spin08",
                     @"C4Spin09",
                     @"C4Spin10",
                     @"C4Spin11",
                     ]];
    animatedImage.center = self.canvas.center;
    [animatedImage play];
    [self.canvas addImage:animatedImage];
    
    durationSlider = [C4Slider slider:CGRectMake(0, 0, 368, 44)];
    durationSlider.center = CGPointMake(self.canvas.center.x,
                                        self.canvas.center.y + animatedImage.height / 2.0f + durationSlider.height);
    durationSlider.minimumValue = 0.5f;
    durationSlider.maximumValue = 2.0f;
    durationSlider.continuous = NO;
    [durationSlider runMethod:@"updateDuration" target:self forEvent:VALUECHANGED];
    [self.canvas addSubview:durationSlider];
}

-(void)updateDuration {
    [animatedImage pause];
    animatedImage.animatedImageDuration = durationSlider.value;
    [animatedImage play];
}


@end