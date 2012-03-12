//
//  ViewController.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-06.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4CanvasController.h"

@implementation C4CanvasController
@synthesize canvas;
@synthesize origin;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil) {
        
    }
    return self;
}

-(void)setup {

}

-(void)addShape:(C4Shape *)shape {
    NSAssert([shape isKindOfClass:[C4Shape class]],
             @"You tried to add something other than a C4Shape object using [canvas addShape:]");
    [self.view addSubview:shape];
}

-(void)addLabel:(C4Label *)label {
    NSAssert([label isKindOfClass:[C4Label class]], 
             @"You tried to add something other than a C4Label object using [canvas addLabel:]");
    [self.view addSubview:label];
}

-(void)addGL:(C4GL *)gl {
    NSAssert([gl isKindOfClass:[C4GL class]], 
             @"You tried to add something other than a C4GL object using [canvas addGL:]");
    [self.view addSubview:gl];
}

-(void)addImage:(C4Image *)image {
    NSAssert([image isKindOfClass:[C4Image class]],
             @"You tried to add something other than a C4Image object using [canvas addImage:]");
    [self.view addSubview:image];
}

-(void)addMovie:(C4Movie *)movie {
    NSAssert([movie isKindOfClass:[C4Movie class]],
             @"You tried to add something other than a C4Movie object using [canvas addMovie:]");
    [self.view addSubview:movie];
}
@end