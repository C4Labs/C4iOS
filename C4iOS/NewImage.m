//
//  NewImage.m
//  C4iOS
//
//  Created by moi on 13-02-18.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "NewImage.h"

@interface NewImage () {
}

@property (readwrite, strong, nonatomic) C4ImageView *imageView;
@property (readwrite, strong, nonatomic) UIImage *originalImage;
@property (readonly, nonatomic) CGSize originalSize;
@property (readonly, nonatomic) CGFloat originalRatio;
@property (readonly) BOOL constrainsProportions, multipleFilterEnabled;
@end

@implementation NewImage

#pragma mark Initialization
+(NewImage *)imageNamed:(NSString *)name {
    return [[NewImage alloc] initWithImageName:name];
}

+(NewImage *)imageWithImage:(C4Image *)image {
    return [[NewImage alloc] initWithImage:image];
}

+(NewImage *)imageWithUIImage:(UIImage *)image {
    return [[NewImage alloc] initWithUIImage:image];
}

-(id)initWithRawData:(unsigned char*)data width:(NSInteger)width height:(NSInteger)height {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(data, width, height, bitsPerComponent, 4*width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    return [self initWithCGImage:image];
}

-(id)initWithCGImage:(CGImageRef)image {
    return [self initWithUIImage:[UIImage imageWithCGImage:image]];
}

-(id)initWithImageName:(NSString *)name {
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [self initWithUIImage:[UIImage imageNamed:name]];
}

-(id)initWithImage:(C4Image *)image {
    return [self initWithUIImage:image.UIImage];
}

-(id)initWithUIImage:(UIImage *)image {
    if(image == nil || image == (UIImage *)[NSNull null]) return nil;
    self = [super init];
    if(self != nil) {
        _originalImage = image;
        _imageView = [[C4ImageView alloc] initWithImage:_originalImage];
        [self addSubview:_imageView];
        [self setProperties];
        _constrainsProportions = YES;
        _multipleFilterEnabled = NO;
    }
    return self;
}

+(NewImage *)imageWithData:(NSData *)imageData {
    return [[NewImage alloc] initWithData:imageData];
}

-(id)initWithData:(NSData *)imageData {
    return [self initWithUIImage:[UIImage imageWithData:imageData]];
}


-(void)setProperties {
    _originalSize = _originalImage.size;
    _originalRatio = _originalSize.width / _originalSize.height;
    
    CGRect scaledFrame = CGRectZero;
    scaledFrame.origin = self.frame.origin;
    scaledFrame.size = _originalSize;
    self.frame = scaledFrame;
}

@end
