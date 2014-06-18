// Copyright © 2012 Travis Kirton
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

#import "C4Shape_Private.h"
#import "C4Shape+String.h"

NSString* const C4ShapeStringType = @"string";

@implementation C4Shape (String)

+ (instancetype)shapeFromString:(NSString *)string withFont:(C4Font *)font {
    C4Shape *newShape = [[C4Shape alloc] init];
    [newShape shapeFromString:string withFont:font];
    return newShape;
}

- (void)shapeFromString:(NSString *)string withFont:(C4Font *)font {
    self.shapeData = @{
        C4ShapeTypeKey: C4ShapeStringType
    };
    
    CGAffineTransform afft = CGAffineTransformMakeScale(1, -1);
    CGMutablePathRef glyphPaths = CGPathCreateMutable();
    CGPathMoveToPoint(glyphPaths, nil, 0, 0);
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, nil);
    
    CGPoint currentOrigin = CGPointZero;
    for(int i = 0; i < string.length; i++) {
        CGGlyph currentGlyph;
        const unichar c = [string characterAtIndex:i];
        CTFontGetGlyphsForCharacters(ctFont, &c, &currentGlyph, 1);
        CGPathRef fontPath = CTFontCreatePathForGlyph(ctFont, currentGlyph, &afft);
        CGSize advance = CGSizeZero;
        CGAffineTransform t = CGAffineTransformMakeTranslation(currentOrigin.x, currentOrigin.y);
        CGPathAddPath(glyphPaths, &t, fontPath);
        CTFontGetAdvancesForGlyphs(ctFont, kCTFontDefaultOrientation, &currentGlyph, &advance, 1);
        currentOrigin.x += advance.width;
        CFRelease(fontPath);
    }
    
    CGRect pathRect = CGPathGetBoundingBox(glyphPaths);
    const CGAffineTransform translate = CGAffineTransformMakeTranslation(-pathRect.origin.x,-pathRect.origin.y);
    
    CGMutablePathRef transFormedGlyphPaths = CGPathCreateMutableCopyByTransformingPath(glyphPaths, &translate);
    
    self.path = transFormedGlyphPaths;
//    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)transFormedGlyphPaths];
    
    pathRect = CGPathGetPathBoundingBox(transFormedGlyphPaths);
    self.bounds = pathRect;
    
    CFRelease(ctFont);
    CGPathRelease(glyphPaths);
    CGPathRelease(transFormedGlyphPaths);
}

- (BOOL)isString {
    return [[self.shapeData objectForKey:C4ShapeTypeKey] isEqualToString:C4ShapeStringType];
}

@end
