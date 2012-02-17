//
//  C4ShapeView.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4View.h"

@interface C4ShapeView : C4View {
    CAShapeLayer *shapeLayer;
}
-(void)addShape;
-(void)addAnotherShape;
@property (readwrite, strong) CAShapeLayer *shapeLayer;
@end
