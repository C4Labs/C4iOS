//
//  WorkSpaceC.m
//  C4iOS
//
//  Created by travis on 2013-04-17.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "WorkSpaceC.h"
#import "WorkSpaceA.h"
#import "WorkSpaceB.h"

@implementation WorkSpaceC {
    WorkSpaceA *workspaceA;
    WorkSpaceB *workspaceB;
}

-(void)setup {
    workspaceA = [[WorkSpaceA alloc] initWithNibName:@"WorkSpaceA" bundle:[NSBundle mainBundle]];
    workspaceB = [[WorkSpaceB alloc] initWithNibName:@"WorkSpaceB" bundle:[NSBundle mainBundle]];
    
    CGFloat offset = self.canvas.width * 0.01f;
    
    workspaceA.canvas.frame = CGRectMake(offset,offset, self.canvas.width - 2 * offset,(self.canvas.height - offset * 3)/2.0f);
    workspaceB.canvas.frame = CGRectMake(offset,offset * 2 + workspaceA.canvas.height, workspaceA.canvas.width, workspaceA.canvas.height);
    workspaceB.canvas.clipsToBounds = YES;
    
    [workspaceA setup];
    [workspaceB setup];
    
    [self.canvas addObjects:@[workspaceA.canvas, workspaceB.canvas]];
}
@end
