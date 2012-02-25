//
//  C4Canvas.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-07.
//  Copyright (c) 2011 mediart. All rights reserved.
//

/* 
 DO WE NEED C4LAYERS?
 PROBABLY... JUST HAVEN'T USED THEM YET...
 WHAT ABOUT THE C4CANVAS?... WE DON'T EVER ACCESS IT BECAUSE IT IS CURRENTLY STRUCTURED AS A BACKGROUND LAYER FOR A C4WINDOW... AND, WE WOULD ONLY INTERACT WITH THE WINDOW IN ORDER TO USE IT...
 MIGHT BE ABLE TO REMOVE IT FROM THE HIERARCHY
 */

#import "C4Layer.h"

@interface C4Canvas : C4Layer {
@private
    BOOL readyToDisplay;
}
@end
