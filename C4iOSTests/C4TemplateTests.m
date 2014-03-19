// Copyright © 2012 Travis Kirton, Alejandro Isaza
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

#import "C4Template.h"
#import "C4Button.h"
#import <XCTest/XCTest.h>

@interface C4TemplateTests : XCTestCase

@end


@implementation C4TemplateTests

- (void)testTemplate {
    // Create a template
    C4Template* template = [C4Template templateForClass:[C4Button class]];
    
    // Use proxy to set properties
    C4Button* proxy = (C4Button*)template;
    proxy.shadowRadius = 1.5;
    [proxy setTitleColor:[UIColor redColor] forState:HIGHLIGHTED];
    [proxy setTitleShadowColor:nil forState:NORMAL];
    
    // Check that initialy values are unset
    C4Button* button = [[C4Button alloc] initWithType:CUSTOM];
    [button setTitleShadowColor:[UIColor blackColor] forState:NORMAL];
    XCTAssertNotEqual(button.shadowRadius, 1.5,
                      @"Initial shadowRadius collides with value being tested");
    XCTAssertNotEqualObjects([button titleColorForState:HIGHLIGHTED], [UIColor redColor],
                             @"Initial titleColor collides with value being tested");
    XCTAssertNotEqualObjects([button titleShadowColorForState:NORMAL], nil,
                             @"Initial titleShadowColor collides with value being tested");
    
    // After applying the template the values should match what we set on the template
    [template applyToTarget:button];
    XCTAssertEqual(button.shadowRadius, 1.5,
                   @"shadowRadius property was not properly set by the template");
    XCTAssertEqualObjects([button titleColorForState:HIGHLIGHTED], [UIColor redColor],
                          @"titleColor property was not properly set by the template");
    XCTAssertNil([button titleShadowColorForState:NORMAL],
                 @"titleShadowColor property was not properly set by the template");
}

- (void)testInvalidProperty {
    // Create a template
    C4Template* template = [C4Template templateForClass:[C4Button class]];
    
    // Use wrong proxy to set properties
    C4Shape* proxy = (C4Shape*)template;
    XCTAssertThrows(proxy.pointA = CGPointMake(1, 1),
                    @"setting invalid property should throw an exception");
}

@end
