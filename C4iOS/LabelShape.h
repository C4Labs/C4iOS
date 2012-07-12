//
//  LabelShape.h
//  C4iOS
//
//  Created by Travis Kirton on 12-06-20.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Shape.h"

@interface LabelShape : C4Shape
@property (readonly, atomic, strong) C4Shape *label;
@end
