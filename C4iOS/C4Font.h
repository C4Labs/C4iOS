//
//  C4Font.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-27.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This document describes the C4Font class which provides basic font construction and manipulation throughout the C4 framework.

 The C4Font provides access to an underlying UIFont object, which class provides the interface for getting and setting font information. The class provides you with access to the font’s characteristics and also provides the system with access to the font’s glyph information, which is used during layout. You use font objects by passing them to methods that accept them as a parameter.
 
 You do not create C4Font objects using the alloc and init methods. Instead, you use class methods of C4Font to look up and retrieve the desired font object.
 */

@interface C4Font : C4Object {
@private
}

#pragma mark Creating Arbitrary Fonts
/** Creates and returns a font object for the specified font name and size.
 
 You can use the familyNames: method to retrieve a list of available font families on iOS.
 
 You can use the fontNamesForFamilyName: method to retrieve the specific font names for a given font family.
 
 @param fontName The fully specified name of the font. This name incorporates both the font family name and the specific style information for the font.
 @param fontSize The size (in points) to which the font is scaled. This value must be greater than 0.0.

 @return A C4Font object of the specified name and size;
*/
+ (C4Font *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

/** Returns a font object that is the same as the receiver but which has the specified size instead.

 @param fontSize The size (in points) to which the font is scaled. This value must be greater than 0.0.
 @return A C4Font object of the specified size;
 */
- (C4Font *)fontWithSize:(CGFloat)fontSize;

/** Returns an array of font family names available on the system.

 Font family names correspond to the base name of a font, such as Times New Roman. You can pass the returned strings to the fontNamesForFamilyName: method to retrieve a list of font names available for that family. You can then use the corresponding font name to retrieve an actual font object.
 
 @return An array of NSString objects, each of which contains the name of a font family.
 */
+ (NSArray *)familyNames;

/** Returns an array of font names available in a particular font family.
 
 You can pass the returned strings as parameters to the fontWithName:size: method to retrieve an actual font object.
 
 @param familyName The name of the font family. Use the familyNames method to get an array of the available font family names on the system. 
 @return An array of NSString objects, each of which contains a font name associated with the specified family.
 */
+ (NSArray *)fontNamesForFamilyName:(NSString *)familyName;

/** Returns the font object used for standard interface items in the specified size.
 
 @param fontSize The size (in points) to which the font is scaled. This value must be greater than 0.0. 
 @return A C4Font object of the specified size.
 */
+ (C4Font *)systemFontOfSize:(CGFloat)fontSize;

/** Returns the font object used for standard interface items that are rendered in boldface type in the specified size.
 
 @param fontSize The size (in points) to which the font is scaled. This value must be greater than 0.0. 
 @return A C4Font object of the specified size.
 */
+ (C4Font *)boldSystemFontOfSize:(CGFloat)fontSize;

/** Returns the font object used for standard interface items that are rendered in italic type in the specified size.
 
 @param fontSize The size (in points) to which the font is scaled. This value must be greater than 0.0. 
 @return A C4Font object of the specified size.
 */
+ (C4Font *)italicSystemFontOfSize:(CGFloat)fontSize;

/// @name Properties
#pragma mark Properties


/** The main font object from which all other methods refer. 
 
 When a C4Font is initialized it creates and stores a UIFont. The C4Font class is essentially a wrapper for UIFont, with some additions that make it easier to access and create CGFontRef and CTFontRef objects depending on the need and the context.
 
 The C4Font class is designed to mimick the UIFont class and can be used in almost identical fashion. 
 
 @return The receiver's UIFont object.
 */
@property(readonly, strong, nonatomic)  UIFont   *UIFont;

/** A CTFont object that corresponds to the receiver's UIFont.
 
 Creates and returns an instance of a CTFontRef.
 
 @return A CTFontRef object whose characteristics match the receiver's.
 */
@property(readonly, nonatomic)  CTFontRef   CTFont;

/** A CGFont object that corresponds to the receiver's UIFont.
 
 Creates and returns an instance of a CGFontRef.
 
 @return A CGFontRef object whose characteristics match the receiver's.
 */
@property(readonly, nonatomic)  CGFontRef   CGFont;

/** The font family name. (read-only)
 
 A family name is a name such as Times New Roman that identifies one or more specific fonts. The value in this property is intended for an application’s internal usage only and should not be displayed.
 */
@property(nonatomic,readonly,strong)    NSString *familyName;

/** The font face name. (read-only)
 
 The font name is a name such as HelveticaBold that incorporates the family name and any specific style information for the font. The value in this property is intended for an application’s internal usage only and should not be displayed.
 */
@property(nonatomic,readonly,strong)    NSString *fontName;

/** The receiver’s point size, or the effective vertical point size for a font with a nonstandard matrix. (read-only)
 */
@property(nonatomic,readonly)           CGFloat   pointSize;

/** The top y-coordinate, offset from the baseline, of the receiver’s longest ascender. (read-only)
 
 The ascender value is measured in points.
 */
@property(nonatomic,readonly)           CGFloat   ascender;

/** The bottom y-coordinate, offset from the baseline, of the receiver’s longest descender. (read-only)
 
 The descender value is measured in points. This value may be positive or negative. For example, if the longest descender extends 2 points below the baseline, this method returns -2.0.
 */
@property(nonatomic,readonly)           CGFloat   descender;

/** The receiver’s cap height information. (read-only)
 
 This value measures (in points) the height of a capital character.
 */
@property(nonatomic,readonly)           CGFloat   capHeight;

/** The x-height of the receiver. (read-only)
 
 This value measures (in points) the height of the lowercase character "x".
 */
@property(nonatomic,readonly)           CGFloat   xHeight;

/** The height of text lines (measured in points). (read-only)
 */
@property(nonatomic,readonly)           CGFloat   lineHeight;
@end