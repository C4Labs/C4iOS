//
//  C4AssertionHandler.h
//  C4iOS
//
//  Created by Travis Kirton on 12-07-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface C4AssertionHandler : NSAssertionHandler
-(void)handleGestureTypeFailureInFunction:(NSString *)functionName object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line;
-(void)handleGestureTypeFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line;
@end
