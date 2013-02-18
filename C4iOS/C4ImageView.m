//
//  C4ImageView.m
//  C4iOS
//
//  Created by moi on 13-02-18.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4ImageView.h"

@implementation C4ImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(C4Layer *)imageLayer {
    return (C4Layer *)self.layer;
}

+(Class)layerClass {
    return [C4Layer class];
}

@end
