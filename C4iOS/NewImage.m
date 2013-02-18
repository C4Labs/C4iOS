//
//  NewImage.m
//  C4iOS
//
//  Created by moi on 13-02-18.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "NewImage.h"

@interface NewImage ()

@property (readwrite, strong, nonatomic) C4ImageView *imageView;
@property (readwrite, strong, nonatomic) UIImage *originalImage;
@property (readwrite, strong, nonatomic) CIImage *output;
@property (readwrite, strong, nonatomic) CIContext *filterContext;
@property (readonly, nonatomic) dispatch_queue_t filterQueue;
@property (readonly, nonatomic) NSUInteger bytesPerPixel, bytesPerRow;
@property (readonly, nonatomic) unsigned char *rawData;

@end

@implementation NewImage
@synthesize filterQueue = _filterQueue, rawData = _rawData;

#pragma mark Initialization
+(NewImage *)imageNamed:(NSString *)name {
    return [[NewImage alloc] initWithImageName:name];
}

+(NewImage *)imageWithImage:(NewImage *)image {
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
        
        _constrainsProportions = YES;
        _multipleFilterEnabled = NO;
        
        [self setProperties];
        _filterQueue = nil;
        _output = nil;
        _imageView = [[C4ImageView alloc] initWithImage:_originalImage];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_imageView];
        self.autoresizesSubviews = YES;
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

#pragma mark Properties
-(void)setHeight:(CGFloat)height {
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    if(_constrainsProportions) newFrame.size.width = height * self.originalRatio;
    self.frame = newFrame;
}

-(void)setWidth:(CGFloat)width {
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    if(_constrainsProportions) newFrame.size.height = width/self.originalRatio;
    self.frame = newFrame;
}

-(void)setSize:(CGSize)size {
    CGRect newFrame = CGRectZero;
    newFrame.origin = self.origin;
    newFrame.size = size;
    self.frame = newFrame;
}

#pragma mark Contents
-(UIImage *)UIImage {
    CGImageRef cg = self.contents;
    UIImage *image = [UIImage imageWithCGImage:cg scale:CGImageGetWidth(cg)/self.width orientation:self.originalImage.imageOrientation ];
    return image;
}

-(CIImage *)CIImage {
    return [CIImage imageWithCGImage:self.contents];
}

-(CGImageRef)CGImage {
    return self.contents;
}

-(CGImageRef)contents {
    return (__bridge CGImageRef)(self.imageLayer.contents);
}

-(void)setContents:(CGImageRef)image {
    if(self.animationDuration == 0.0f) self.imageLayer.contents = (__bridge id)image;
    else [self.imageLayer animateContents:image];
}

-(void)setImage:(NewImage *)image {
    _originalImage = image.UIImage;
    [self setProperties];
    [self setContents:_originalImage.CGImage];
}

-(CIContext *)filterContext {
    if(_filterContext == nil) _filterContext = [CIContext contextWithOptions:nil];
    return _filterContext;
}

-(dispatch_queue_t)filterQueue {
    if(_filterQueue == nil) {
        const char *label = [[@"FILTER_QUEUE_" stringByAppendingString:[self description]]UTF8String];
        _filterQueue = dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT);
    }
    return _filterQueue;
}

#pragma mark Filters
//FIXME: Add all other filters in the following way!
-(void)colorInvert {
    @autoreleasepool {
        CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
        [filter setDefaults];
        CIImage *inputImage = _output == nil ? self.CIImage : _output;
        [filter setValue:inputImage forKey:@"inputImage"];
        _output = filter.outputImage;
        if(_multipleFilterEnabled == NO) [self renderImageWithFilterName:filter.name];
        filter = nil;
    }
}

-(void)colorMonochrome:(UIColor *)color inputIntensity:(CGFloat)intensity {
    @autoreleasepool {
        CIFilter *filter = [self prepareFilterWithName:@"CIColorMonochrome"];
        CGFloat rgba[4];
        [color getRed:&rgba[0] green:&rgba[1] blue:&rgba[2] alpha:&rgba[3]];
        [filter setValue:[CIColor colorWithRed:rgba[0] green:rgba[1] blue:rgba[2] alpha:rgba[3]] forKey:@"inputColor"];
        [filter setValue:@(intensity) forKey:@"inputIntensity"];
        _output = filter.outputImage;
        if(_multipleFilterEnabled == NO) [self renderImageWithFilterName:filter.name];
        filter = nil;
    }
}

-(void)startFiltering {
    _multipleFilterEnabled = YES;
}

-(CIFilter *)prepareFilterWithName:(NSString *)filterName {
    @autoreleasepool {
        CIFilter *filter = [CIFilter filterWithName:filterName];
        [filter setDefaults];
        CIImage *inputImage = _output == nil ? self.CIImage : _output;
        [filter setValue:inputImage forKey:@"inputImage"];
        return filter;
    }
}

-(void)renderFilteredImage {
    if(_multipleFilterEnabled == YES && _output != nil) {
        [self renderImageWithFilterName:@"MultipleFilter"];
    }
}

-(void)renderImageWithFilterName:(NSString *)filterName {
    dispatch_async(self.filterQueue, ^{
        //applies create the image based on its original size, contents will automatically scale
        CGImageRef filteredImage = [self.filterContext createCGImage:_output fromRect:(CGRect){CGPointZero,self.originalSize}];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setContents:filteredImage];
            [self postNotification:[filterName stringByAppendingString:@"Complete"]];
            _multipleFilterEnabled = NO;
            _output = nil;
        });
    });
}

#pragma mark Pixels
-(void)loadPixelData {
    const char *queueName = [@"pixelDataQueue" UTF8String];
    __block dispatch_queue_t pixelDataQueue = dispatch_queue_create(queueName,  DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(pixelDataQueue, ^{
        NSUInteger width = CGImageGetWidth(self.CGImage);
        NSUInteger height = CGImageGetHeight(self.CGImage);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        _bytesPerPixel = 4;
        _bytesPerRow = _bytesPerPixel * width;
        free(_rawData);
        _rawData = malloc(height * _bytesPerRow);
        
        NSUInteger bitsPerComponent = 8;
        CGContextRef context = CGBitmapContextCreate(_rawData, width, height, bitsPerComponent, _bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
        CGContextRelease(context);
        _pixelDataLoaded = YES;
        [self postNotification:@"pixelDataWasLoaded"];
        pixelDataQueue = nil;
    });
}

-(UIColor *)colorAt:(CGPoint)point {
    if(_pixelDataLoaded == NO) {
        C4Log(@"You must first load pixel data");
    } else  if ([self pointInside:point withEvent:nil]) {
        if(_rawData == nil) {
            [self loadPixelData];
        }
        NSUInteger byteIndex = (NSUInteger)(_bytesPerPixel * point.x + _bytesPerRow * point.y);
        NSInteger r, g, b, a;
        r = _rawData[byteIndex];
        g = _rawData[byteIndex + 1];
        b = _rawData[byteIndex + 2];
        a = _rawData[byteIndex + 3];
        
        return [UIColor colorWithRed:RGBToFloat(r) green:RGBToFloat(g) blue:RGBToFloat(b) alpha:RGBToFloat(a)];
    }
    return [UIColor clearColor];
}

-(C4Vector *)rgbVectorAt:(CGPoint)point {
    if(_pixelDataLoaded == NO) {
        C4Log(@"You must first load pixel data");
    } else if([self pointInside:point withEvent:nil]) {
        if(self.pixelDataLoaded == NO) {
            [self loadPixelData];
        }
        NSUInteger byteIndex = (NSUInteger)(_bytesPerPixel * point.x + _bytesPerRow * point.y);
        CGFloat r, g, b;
        r = _rawData[byteIndex];
        g = _rawData[byteIndex + 1];
        b = _rawData[byteIndex + 2];
        return [C4Vector vectorWithX:r Y:g Z:b];
    }
    return [C4Vector vectorWithX:-1 Y:-1 Z:-1];
}

#pragma mark Copying
-(NewImage *)copyWithZone:(NSZone *)zone {
    return [[NewImage allocWithZone:zone] initWithImage:self];
}

#pragma mark Default Style
+(NewImage *)defaultStyle {
    return (NewImage *)[NewImage appearance];
}

#pragma mark Layer Access Overrides
-(C4Layer *)imageLayer {
    return self.imageView.imageLayer;
}

-(C4Layer *)layer {
    return self.imageLayer;
}

@end
