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
    assert([shape isKindOfClass:[C4Shape class]]);
    [self addSubview:shape];
}

-(void)addLabel:(C4Label *)label {
    assert([label isKindOfClass:[C4Label class]]);
    [self addSubview:label];
}

-(void)addGL:(C4GL *)gl {
    assert([gl isKindOfClass:[C4GL class]]);
    [self addSubview:gl];
}

-(void)addImage:(C4Image *)image {
    assert([image isKindOfClass:[C4Image class]]);
    [self addSubview:image];
}

/*
 The following method makes sure that the main backing CALayer
 for this UIWindow subclass will be a C4Canvas
 */

@end
