//
//  MyView.m
//  C4iOS
//
//  Created by travis on 2013-01-29.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "MyView.h"

@implementation MyView

-(void)touchesBegan {
    C4Log(@"%@ %@",NSStringFromSelector(_cmd),self);
}

@end
