//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"
#import "NewImage.h"

@implementation C4WorkSpace {
    NewImage *n, *o;
}

-(void)setup {
//    C4Image *img = [NewImage lenticularHalo:CGSizeMake(400, 400) center:CGPointMake(200, 200) color:C4RED haloRadius:70.0f haloWidth:87.0 haloOverlap:0.5 striationStrength:0.5 striationContrast:1 time:0];
    
    @autoreleasepool {
        CIContext *context = [CIContext contextWithOptions:nil];
        CIFilter *filter = [CIFilter filterWithName:@"CILenticularHaloGenerator"];
        [filter setValue:[CIVector vectorWithCGPoint:CGPointMake(150, 150)] forKey:@"inputCenter"];
        [filter setValue:[CIColor colorWithRed:1 green:0 blue:0] forKey:@"inputColor"];
        [filter setValue:@(70.0f) forKey:@"inputHaloRadius"];
        [filter setValue:@(87.0f) forKey:@"inputHaloWidth"];
        [filter setValue:@(0.77) forKey:@"inputHaloOverlap"];
        [filter setValue:@(0.5) forKey:@"inputStriationStrength"];
        [filter setValue:@(1.0f) forKey:@"inputStriationContrast"];
        [filter setValue:@(0.0f) forKey:@"inputTime"];
        CGImageRef filteredImage = [context createCGImage:filter.outputImage fromRect:CGRectMake(0, 0, 300, 300)];
    
        C4Image *img = [[C4Image alloc] initWithCGImage:filteredImage];
        self.canvas.backgroundColor = C4GREY;
        img.borderWidth = 2.0f;
        img.borderColor = C4RED;
        C4Log(@"%4.2f",CGImageGetHeight(filteredImage));
        [self.canvas addImage:img];
    }
}

@end
