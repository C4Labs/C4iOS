//
// C4Workspace.h
// Examples
//
// Created by Greg Debicki
//

#import "C4Workspace.h"

@implementation C4WorkSpace {
    C4Movie *m;
}

-(void)setup {
    m = [C4Movie movieNamed:@"inception.mov"];
    [self.canvas addMovie:m];
}

@end