//
//  AnimatedShape.h
//  C4iOS
//
//  Created by moi on 13-02-06.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4Shape.h"

@interface AnimatedShape : C4Shape
-(void)startAnimation;
-(AnimatedShape *)copyWithZone:(NSZone *)zone;
@end
