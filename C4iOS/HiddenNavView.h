//
//  HiddenNavView.h
//  C4iOS
//
//  Created by moi on 12-12-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4View.h"

@interface HiddenNavView : C4View
-(void)setup;
-(void)flipIn;
-(void)flipOut;
@property (readwrite, nonatomic, strong) C4Image *flipViewImage;
@end
