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

#import "C4Font.h"

@implementation C4Font

-(id)init {
    self = [super init];
    if(self != nil) {
        _UIFont = [UIFont systemFontOfSize:12.0f];
        [self setup];
    }
    return self;
}

-(id)initWithName:(NSString *)fontName size:(CGFloat)fontSize {
    self = [super init];
    if(self != nil) {
        _UIFont = [UIFont fontWithName:fontName size:fontSize];
        [self setup];
    }
    return self;
}

+ (instancetype)fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    return [[C4Font alloc] initWithName:fontName size:fontSize];
}

// Returns an array of font family names for all installed fonts
+ (NSArray *)familyNames {
    return [UIFont familyNames];
}
// Returns an array of font names for the specified family name
+ (NSArray *)fontNamesForFamilyName:(NSString *)familyName {
    return [UIFont fontNamesForFamilyName:familyName];
}

// Some convenience methods to create system fonts
+ (instancetype)systemFontOfSize:(CGFloat)fontSize {
    return [[C4Font alloc] initWithName:SYSTEMFONTNAME size:fontSize];
}

+ (instancetype)boldSystemFontOfSize:(CGFloat)fontSize {
    return [[C4Font alloc] initWithName:BOLDSYSTEMFONTNAME size:fontSize];
}
+ (instancetype)italicSystemFontOfSize:(CGFloat)fontSize {
    return [[C4Font alloc] initWithName:ITALICSYSTEMFONTNAME size:fontSize];
}

// Font attributes

// Create a new font that is identical to the current font except the specified size
- (C4Font *)fontWithSize:(CGFloat)fontSize {
    return [[C4Font alloc] initWithName:[self.UIFont fontName] size:fontSize];
}

-(NSString *)familyName {
    return _UIFont.familyName;
}

-(NSString *)fontName {
    return _UIFont.fontName;
}

-(void)setFontName:(NSString *)fontName {
    _UIFont = [UIFont fontWithName:fontName size:self.pointSize];
}

-(CGFloat)pointSize {
    return _UIFont.pointSize;
}

-(void)setPointSize:(CGFloat)pointSize {
    _UIFont = [UIFont fontWithName:self.fontName size:pointSize];
}

-(CGFloat)ascender {
    return _UIFont.ascender;
}

-(CGFloat)descender {
    return _UIFont.descender;
}

-(CGFloat)capHeight {
    return _UIFont.capHeight;
}

-(CGFloat)xHeight {
    return _UIFont.xHeight;
}

-(CGFloat)lineHeight {
    return _UIFont.lineHeight;
}

-(CGFontRef)CGFont {
    return (__bridge CGFontRef)self.UIFont;
}

-(CTFontRef)CTFont {
    return CTFontCreateWithName((__bridge CFStringRef)self.fontName, self.pointSize, nil);
}

@end