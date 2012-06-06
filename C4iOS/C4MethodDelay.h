//
//  C4MethodDelay.h
//  C4iOS
//
//  Created by Travis Kirton on 12-06-05.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol C4MethodDelay <NSObject>
-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds;
-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds;
@end
