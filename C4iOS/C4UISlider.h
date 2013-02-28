//
//  C4UISlider.h
//  C4iOS
//
//  Created by moi on 13-02-27.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

@class NewSlider;

#import <UIKit/UIKit.h>
#import "NewSlider.h"

@interface C4UISlider : UISlider
@property (readonly, atomic, weak) NewSlider *delegate;
-(id)initWithFrame:(CGRect)frame delegate:(id)delegate;
@end
