//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace 

-(void)setup {
    C4Log(@"size: (%4.2f,%4.2f)",self.canvas.width, self.canvas.height);
    C4Log(@"center: (%4.2f,%4.2f)",self.canvas.center.x,self.canvas.center.y);
}

@end
