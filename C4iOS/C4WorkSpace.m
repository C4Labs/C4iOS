//
//  C4WorkSpace.m
//  Exporting Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    CGContextRef graphicsContext;
}

-(void)setup {
    C4Font *font = [C4Font fontWithName:@"AvenirNextCondensed-Heavy" size:144];
    C4Shape *s = [C4Shape shapeFromString:@"EXPORTING" withFont:font];
    s.center = self.canvas.center;
    [self.canvas addShape:s];

    [self exportImage];
    [self exportHighResImage];
    [self exportPDF];
}

-(void)exportImage {
    graphicsContext = [self createImageContext];
    
    [self.canvas renderInContext:graphicsContext];
    NSString *fileName = @"exportedImageFromC4.png";

    [self saveImage:fileName];
    [self saveImageToLibrary];
}

-(void)exportHighResImage {
    graphicsContext = [self createHighResImageContext];
    [self.canvas renderInContext:graphicsContext];
    NSString *fileName = @"exportedHighResImageFromC4.png";
    
    [self saveImage:fileName];
    [self saveImageToLibrary];
}

-(CGContextRef)createImageContext {
    UIGraphicsBeginImageContext(self.canvas.frame.size);
    return UIGraphicsGetCurrentContext();
}

-(CGContextRef)createHighResImageContext {
    UIGraphicsBeginImageContextWithOptions(self.canvas.frame.size, YES, 5.0f);
    return UIGraphicsGetCurrentContext();
}

-(void)saveImageToLibrary {
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

-(void)saveImage:(NSString *)fileName {
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImagePNGRepresentation(image);    
    NSString *savePath = [[self documentsDirectory] stringByAppendingPathComponent:fileName];
    [imageData writeToFile:savePath atomically:YES];
}

-(void)exportPDF {
    graphicsContext = [self createPDFContext];
    
    [self.canvas renderInContext:graphicsContext];
    [self savePDF];
}

-(CGContextRef)createPDFContext {
    NSString *fileName = @"exportedPDFFromC4.pdf";
    
    NSString *outputPath = [[self documentsDirectory] stringByAppendingPathComponent:fileName];

    UIGraphicsBeginPDFContextToFile(outputPath, self.canvas.frame, nil);
    UIGraphicsBeginPDFPage();
    return UIGraphicsGetCurrentContext();
}

-(void)savePDF {
    UIGraphicsEndPDFContext();
}

-(NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}
@end