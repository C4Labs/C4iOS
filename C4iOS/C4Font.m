//
//  C4Font.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-27.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Font.h"

@interface C4Font ()
-(id)initWithName:(NSString *)fontName size:(CGFloat)fontSize;
@end

@implementation C4Font
@synthesize UIFont = _UIFont, CTFont = _CTFont, CGFont = _CGFont, familyName = _familyName, fontName = _fontName, pointSize = _pointSize, ascender = _ascender, descender = _descender, capHeight = _capHeight, xHeight = _xHeight, lineHeight = _lineHeight;

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

+ (C4Font *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    return [[C4Font alloc] initWithName:fontName size:fontSize];
}

-(void)dealloc {
    _UIFont = nil;
    _CTFont = nil;
    _CGFont = nil;
    _familyName = nil;
    _fontName = nil;
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
+ (C4Font *)systemFontOfSize:(CGFloat)fontSize {
    return [[C4Font alloc] initWithName:SYSTEMFONTNAME size:fontSize];
}

+ (C4Font *)boldSystemFontOfSize:(CGFloat)fontSize {
    return [[C4Font alloc] initWithName:BOLDSYSTEMFONTNAME size:fontSize];
}
+ (C4Font *)italicSystemFontOfSize:(CGFloat)fontSize {
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

-(CGFloat)pointSize {
    return _UIFont.pointSize;
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