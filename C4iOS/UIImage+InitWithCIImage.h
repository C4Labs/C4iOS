//
//  UIImage+InitWithCIImage.h
//  C4iOS
//
//  Created by moi on 13-02-04.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>
//Using this category to fix the UIImage initWithCIImage method...
@interface UIImage (InitWithCIImage)
+(UIImage *)imageWithCIImage:(CIImage *)ciImage;
-(id)initWithCIImage:(CIImage *)ciImage;
@end
