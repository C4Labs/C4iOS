//
//  C4Window.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-07.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4Window.h"

@implementation C4Window
@synthesize canvasController;

- (id)init
{
    self = [super init];
    if (self) {
#ifdef VERBOSE
        C4Log(@"%@ init",[self class]);
#endif

    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
#ifdef VERBOSE
        C4Log(@"%@ initWithFrame",[self class]);
#endif
    }
    return self;
}

-(void)awakeFromNib {
#ifdef VERBOSE
    C4Log(@"%@ awakeFromNib",[self class]);
#endif
}

-(void)addShape:(C4Shape *)shape {
    NSAssert([shape isKindOfClass:[C4Shape class]],
             @"You tried to add something other than a C4Shape object using [canvas addShape:]");
    [self addSubview:shape];
}

-(void)addLabel:(C4Label *)label {
    NSAssert([label isKindOfClass:[C4Label class]], 
             @"You tried to add something other than a C4Label object using [canvas addLabel:]");
    [self addSubview:label];
}

-(void)addGL:(C4GL *)gl {
    NSAssert([gl isKindOfClass:[C4GL class]], 
             @"You tried to add something other than a C4GL object using [canvas addGL:]");
    [self addSubview:gl];
}

-(void)addImage:(C4Image *)image {
    NSAssert([image isKindOfClass:[C4Image class]],
             @"You tried to add something other than a C4Image object using [canvas addImage:]");
    [self addSubview:image];
}

/*
 The following method makes sure that the main backing CALayer
 for this UIWindow subclass will be a C4Canvas
 */

@end
