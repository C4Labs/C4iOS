//
//  UIImage+InitWithCIImage.m
//  C4iOS
//
//  Created by moi on 13-02-04.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "UIImage+InitWithCIImage.h"

@implementation UIImage (InitWithCIImage)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+(UIImage *)imageWithCIImage:(CIImage *)ciImage {
    CIContext *c = [CIContext contextWithOptions:nil];
    CGImageRef cg = [c createCGImage:ciImage fromRect:ciImage.extent];
    return [[self alloc] initWithCGImage:cg];
}

-(id)initWithCIImage:(CIImage *)ciImage {
    CIContext *c = [CIContext contextWithOptions:nil];
    CGImageRef cg = [c createCGImage:ciImage fromRect:ciImage.extent];
    return [self initWithCGImage:cg];
}

-(CIImage *)CIImage {
    return [CIImage imageWithCGImage:self.CGImage];
}

#pragma clang diagnostic pop
@end
