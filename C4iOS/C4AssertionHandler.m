//
//  C4AssertionHandler.m
//  C4iOS
//
//  Created by Travis Kirton on 12-07-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4AssertionHandler.h"

@implementation C4AssertionHandler

-(void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...{
    C4Log(@"ASSERTION ERROR");
    C4Log(@"IN:     %@",[fileName lastPathComponent]);
    C4Log(@"LINE:   %d",line);
    C4Log(@"METHOD: %@",functionName);
    va_list args;
    va_start (args, format);
    NSString *reason = [[NSString alloc] initWithFormat:format arguments:args];
    va_end (args);
    C4Log(@"REASON: %@",reason);
    abort();
}

-(void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ... {
    C4Log(@"ASSERTION ERROR");
    C4Log(@"IN:     %@",[fileName lastPathComponent]);
    C4Log(@"LINE:   %d",line);
    C4Log(@"METHOD: %@",NSStringFromSelector(selector));
    va_list args;
    va_start (args, format);
    NSString *reason = [[NSString alloc] initWithFormat:format arguments:args];
    va_end (args);
    C4Log(@"REASON: %@",reason);
    abort();
}

-(void)handleGestureTypeAssertion:(int)givenType {
    C4Log(@"The gesture type you tried to use (%d) is not TAP, PINCH, SWIPERIGHT, SWIPELEFT, SWIPEUP, SWIPEDOWN, ROTATION, PAN, or  LONGPRESS", givenType);
    abort();
}

-(void)handleGestureTypeFailureInFunction:(NSString *)functionName object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line {
    C4Log(@"GESTURE TYPE ERROR");
    C4Log(@"IN:     %@",[fileName lastPathComponent]);
    C4Log(@"LINE:   %d",line);
    C4Log(@"METHOD: %@",functionName);
    C4Log(@"The gesture type you tried to use (%d) is not TAP, PINCH, SWIPERIGHT, SWIPELEFT, SWIPEUP, SWIPEDOWN, ROTATION, PAN, or LONGPRESS");
    abort();
}

-(void)handleGestureTypeFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line {
    C4Log(@"GESTURE TYPE ERROR");
    C4Log(@"IN:     %@",[fileName lastPathComponent]);
    C4Log(@"LINE:   %d",line);
    C4Log(@"METHOD: %@",NSStringFromSelector(selector));
    C4Log(@"The gesture you tried to use is not one of: TAP, PINCH, SWIPERIGHT, SWIPELEFT, SWIPEUP, SWIPEDOWN, ROTATION, PAN, or LONGPRESS");
    abort();
}
@end
