//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    UIImageView *uiiv;
}

-(void)setup {
    UIImage *input = [UIImage imageNamed:@"C4Sky"];
    CIImage *ci = [[CIImage alloc] initWithCGImage:input.CGImage options:nil];
    CIFilter *filter;
    filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setValue:ci forKey:@"inputImage"];
    [filter setValue:[CIColor colorWithRed:1.0 green:0.0 blue:0.0] forKey:@"inputColor"];
    [filter setValue:@(0.5) forKey:@"inputIntensity"];
    ci = filter.outputImage;
    filter = [CIFilter filterWithName:@"CIVibrance"];
    [filter setValue:ci forKey:@"inputImage"];
    [filter setValue:@(200.0) forKey:@"inputAmount"];
    ci = filter.outputImage;
    filter = [CIFilter filterWithName:@"CIVibrance"];
    [filter setValue:ci forKey:@"inputImage"];
    [filter setValue:@(200.0) forKey:@"inputAmount"];
    ci = filter.outputImage;
    filter = [CIFilter filterWithName:@"CIVibrance"];
    [filter setValue:ci forKey:@"inputImage"];
    [filter setValue:@(200.0) forKey:@"inputAmount"];
    ci = filter.outputImage;
    UIImage *filtered = [UIImage imageWithCIImage:ci];
    uiiv = [[UIImageView alloc] initWithImage:filtered];
    [self.canvas addSubview:uiiv];
}

-(void)touchesBegan {
}

@end
