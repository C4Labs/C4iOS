//
//  C4Object.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-17.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <Foundation/Foundation.h>
/** C4Object is the root class of any object in the C4 framework that does not have a visual representation. For example, a C4Font cannot be represented visually so it is a C4Object, whereas a C4Label is something to be seen on screen so it is instead a C4Control.
 
    This class inherits directly from NSObject.
 
C4Objects conform to the C4Notification protocol which means that all objects will have the ability to post and receive notifications.
 */

@interface C4Object : NSObject <C4Notification>

/** A basic method within which basic variable and parameter setup can happen outside of an object's initialization methods.
 
 A convenience method so that initialization of subclasses can happen in this method rather than overriding (id)init, (id)initWithFrame:, etc...
 */
-(void)setup;
@end
