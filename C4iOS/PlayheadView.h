//
//  MyShape.h
//  C4iOS
//
//  Created by Travis Kirton on 12-05-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Shape.h"

@interface PlayheadView : C4Shape 
-(id)initWithSample:(C4Sample *)newSample;
-(id)initWithSample:(C4Sample *)newSample frame:(CGRect)rect;
-(void)play;
-(void)pause;
-(void)stop;
@property (readwrite, strong, nonatomic) C4Sample *sample;
@property (readwrite, nonatomic) BOOL loops;
@property (readonly, nonatomic) BOOL isPlaying;
@end
