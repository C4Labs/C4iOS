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
@end
