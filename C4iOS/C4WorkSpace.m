#import "C4WorkSpace.h"
#import "C4ScrollView.h"

@implementation C4WorkSpace {
    C4ScrollView *view;
}

-(void)setup {
    view = [C4ScrollView scrollView:CGRectMake(0, 0, 400, 400)];
    view.backgroundColor = C4RED;
    view.contentSize = CGSizeMake(400,800);
    [self.canvas addSubview:view];
}

-(void)touchesBegan {
    view.animationDuration = 1.0f;
    view.rotation = QUARTER_PI;
    view.center = self.canvas.center;
}

@end