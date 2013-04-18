//
//  C4WorkSpace.m
//  Multi-Canvas Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"
#import "WorkSpaceA.h"
#import "WorkSpaceB.h"
#import "WorkSpaceC.h"

@implementation C4WorkSpace {
    WorkSpaceA *workspaceA;
    WorkSpaceB *workspaceB;
    WorkSpaceC *workspaceC;
    C4View *currentView;
}

-(void)setup {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.canvas.height - 44, self.canvas.width, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;

    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *b1 = [[UIBarButtonItem alloc] initWithTitle:@"WorkSpace A" style:UIBarButtonItemStyleBordered target:self action:@selector(switchToA)];
    UIBarButtonItem *b2 = [[UIBarButtonItem alloc] initWithTitle:@"WorkSpace B" style:UIBarButtonItemStyleBordered target:self action:@selector(switchToB)];
    UIBarButtonItem *b3 = [[UIBarButtonItem alloc] initWithTitle:@"WorkSpace C" style:UIBarButtonItemStyleBordered target:self action:@selector(switchToC)];
    
    [toolBar setItems:@[flexible, b1, b2, b3, flexible]];
    
    [self.canvas addSubview:toolBar];

    workspaceA = [[WorkSpaceA alloc] initWithNibName:@"WorkSpaceA" bundle:[NSBundle mainBundle]];
    workspaceB = [[WorkSpaceB alloc] initWithNibName:@"WorkSpaceB" bundle:[NSBundle mainBundle]];
    workspaceC = [[WorkSpaceC alloc] initWithNibName:@"WorkSpaceC" bundle:[NSBundle mainBundle]];
    
    CGFloat offSet = self.canvas.width * 0.05f;
    workspaceA.canvas.frame = CGRectMake(offSet, offSet, self.canvas.width - 2 * offSet, self.canvas.height - 44 - 2 * offSet);
    workspaceB.canvas.frame = workspaceA.canvas.frame;
    workspaceC.canvas.frame = workspaceB.canvas.frame;

    [workspaceA setup];
    [workspaceB setup];
    [workspaceC setup];

    [self.canvas addSubview:workspaceA.canvas];
    currentView = (C4View *)workspaceA.canvas;
    
    self.canvas.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pyramid"]];
}

-(void)switchToA {
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionFlipFromLeft;
    [self switchToView:(C4View*)workspaceA.canvas transitionOptions:options];
}

-(void)switchToB {
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCurlDown;
    [self switchToView:(C4View*)workspaceB.canvas transitionOptions:options];
}

-(void)switchToC {
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve;
    [self switchToView:(C4View*)workspaceC.canvas transitionOptions:options];
}

-(void)switchToView:(C4View *)view transitionOptions:(UIViewAnimationOptions)options {
    if(![currentView isEqual:view]) {
        [UIView transitionFromView:currentView toView:view duration:0.75f options:options completion:^(BOOL finished) {
            currentView = view;
            finished = YES;
        }];
    }
    currentView.userInteractionEnabled = YES;
}

@end
