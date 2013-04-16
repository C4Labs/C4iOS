//
//  C4WorkSpace.m
//  Complex Shapes Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4ScrollView *sv1, *sv2, *sv3, *sv4, *sv5;
}

-(void)setup {
    C4Font *font = [C4Font fontWithName:@"AvenirNext-Heavy" size:24];
    C4Label *label = [C4Label labelWithText:@"5" font:font];

    for(int i = 1; i < 6; i++) {
        font.pointSize = 36 * i;
        label.text = [NSString stringWithFormat:@"%d",6-i];
        label.font = font;
        label.backgroundColor = [UIColor colorWithPatternImage:[C4Image imageNamed:@"lines.png"].UIImage];
        [label sizeToFit];
        
        C4ScrollView *currentView = [C4ScrollView scrollView:CGRectMake(0, 0, self.canvas.width, label.height)];
        currentView.center = self.canvas.center;
        currentView.contentSize = CGSizeMake(currentView.width * 17, currentView.height);
        currentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];

        if(6 - i == 1) sv1 = currentView;
        else if(6 - i == 2) sv2 = currentView;
        else if(6 - i == 3) sv3 = currentView;
        else if(6 - i == 4) sv4 = currentView;
        else if(6 - i == 5) sv5 = currentView;

        [self.canvas addSubview:currentView];

        for(int j = 0; j < 17; j++) {
            C4Label *currentLabel = [label copy];
            currentLabel.center = CGPointMake(currentView.width/2.0f + currentView.width * j, currentView.height / 2.0f);
            [currentView addLabel:currentLabel];
        }
    }
    
    [sv1 addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    change = change;
    context = context;
    if([keyPath isEqualToString:@"contentOffset"]) {
        if((C4ScrollView *)object == sv1) {
            sv2.contentOffset = CGPointMake(sv1.contentOffset.x/2,0);
            sv3.contentOffset = CGPointMake(sv2.contentOffset.x/2,0);
            sv4.contentOffset = CGPointMake(sv3.contentOffset.x/2,0);
            sv5.contentOffset = CGPointMake(sv4.contentOffset.x/2,0);
        }
    }
}
@end