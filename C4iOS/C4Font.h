//
//  C4Font.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-27.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface C4Font : C4Object {
@private
}
-(id)initWithName:(NSString *)fontName size:(CGFloat)fontSize;
+ (C4Font *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

// Returns an array of font family names for all installed fonts
+ (NSArray *)familyNames;
// Returns an array of font names for the specified family name
+ (NSArray *)fontNamesForFamilyName:(NSString *)familyName;

// Some convenience methods to create system fonts
+ (C4Font *)systemFontOfSize:(CGFloat)fontSize;
+ (C4Font *)boldSystemFontOfSize:(CGFloat)fontSize;
+ (C4Font *)italicSystemFontOfSize:(CGFloat)fontSize;

// Font attributes

// Create a new font that is identical to the current font except the specified size
- (C4Font *)fontWithSize:(CGFloat)fontSize;

@property(readonly, strong, nonatomic)  UIFont   *UIFont;
@property(readonly, nonatomic)  CTFontRef   CTFont;
@property(nonatomic,readonly,strong)    NSString *familyName;
@property(nonatomic,readonly,strong)    NSString *fontName;
@property(nonatomic,readonly)           CGFloat   pointSize;
@property(nonatomic,readonly)           CGFloat   ascender;
@property(nonatomic,readonly)           CGFloat   descender;
@property(nonatomic,readonly)           CGFloat   capHeight;
@property(nonatomic,readonly)           CGFloat   xHeight;
@property(nonatomic,readonly)           CGFloat   lineHeight __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
@end