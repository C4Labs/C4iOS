//
//  C4ShapeView.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4ShapeView.h"

@implementation C4ShapeView
@synthesize shapeLayer;
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        self.shapeLayer = [[CAShapeLayer alloc] init];
        /* have to initialize the path here, as it was giving me problems elsewhere */
        CGMutablePathRef emptyPath = CGPathCreateMutable();
        CGPathAddRect(emptyPath, nil, CGRectZero);
        self.shapeLayer.path = emptyPath;
        [self.layer addSublayer:shapeLayer];
        [self addShape];
    }
    return self;
}

/* the technique in both the following methods allows me to change the shape of a shape and change the shape of their view's frame automatically */
-(void)addShape {
    CGMutablePathRef newPath = CGPathCreateMutable();//(self.shapeLayer.path);
    CGPathAddEllipseInRect(newPath, nil, CGRectMake(0, 0, 200, 100));
    CGMutablePathRef shapeLayerPathCopy = CGPathCreateMutableCopy(self.shapeLayer.path);
    CGPathAddPath(shapeLayerPathCopy, nil, newPath);
    self.shapeLayer.path = shapeLayerPathCopy;
    CGRect bounds = CGPathGetBoundingBox(self.shapeLayer.path);
    bounds.origin = self.frame.origin;
    self.frame = bounds;
}

-(void)addAnotherShape {
    CGMutablePathRef newPath = CGPathCreateMutable();//(self.shapeLayer.path);
    CGPathAddEllipseInRect(newPath, nil, CGRectMake(0, 100, 200, 100));
    CGMutablePathRef shapeLayerPathCopy = CGPathCreateMutableCopy(self.shapeLayer.path);
    CGPathAddPath(shapeLayerPathCopy, nil, newPath);
    self.shapeLayer.path = shapeLayerPathCopy;
    CGRect bounds = CGPathGetBoundingBox(self.shapeLayer.path);
    bounds.origin = self.frame.origin;
    self.frame = bounds;
}
@end
