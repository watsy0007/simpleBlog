//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//
//
//  UIView+BeeUIStyle.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UIStyle.h"
#import "Bee_UILayout.h"
#import "UIView+BeeUIStyle.h"
#import "UIView+BeeExtension.h"
#import "NSString+BeeExtension.h"
#import "NSDictionary+BeeExtension.h"

#import <execinfo.h>
#import <objc/runtime.h>
#import <objc/message.h>

#pragma mark -

@implementation UIView(BeeUIStyle)

@dynamic style;

- (BeeUIStyle *)style
{
	BeeUIStyle * s = [[[BeeUIStyle alloc] init] autorelease];
	s.object = self;
	return s;
}

- (void)resetStyleProperties
{
	// TODO:
}

- (void)applyStyleProperties:(NSDictionary *)properties
{
// setPatternBackgoundColor

    NSString * patternImage = [properties stringOfAny:@[@"pattern", @"patternImage", @"bgPattern", @"bg-pattern", @"backgroundPattern", @"background-pattern"]];
    if ( patternImage && patternImage.length )
    {
        UIColor * color = [UIColor colorWithPatternImage:[UIImage imageNamed:patternImage]];
        if ( color )
        {
			[self setBackgroundColor:color];
        }
    }
    
// setBackgoundColor
	
    NSString * backgroundColor = [properties stringOfAny:@[@"color", @"backgroundColor", @"background-color", @"bgcolor", @"bg-color", @"backcolor", @"back-color"]];
    if ( backgroundColor && backgroundColor.length )
    {
        UIColor * color = [UIColor colorWithString:backgroundColor];
        if ( color )
        {
			[self setBackgroundColor:color];
        }
    }

// setAlpha
	
    NSString * alpha = [properties stringOfAny:@[@"alpha", @"opaque", @"transparency"]];
    if ( alpha && alpha.length )
    {
        [self setAlpha:[alpha floatValue]];
    }
    
// setHidden
	
    NSString * hidden = [properties stringOfAny:@[@"hidden", @"hide"]];
    if ( hidden )
    {
		[self setHidden:hidden.boolValue];
    }
	
	NSString * visible = [properties stringOfAny:@[@"visible", @"show"]];
    if ( visible )
    {
		[self setHidden:visible.boolValue ? NO : YES];
	}

// setContentMode

	NSString * contentMode = [properties stringOfAny:@[@"mode", @"contentMode", @"content-mode", @"scale"]];
    if ( contentMode )
    {
		BOOL flag;
		
		flag = [contentMode matchAnyOf:@[@"scale", @"scaleToFill", @"scale-to-fill"]];
		if ( flag )
		{
			[self setContentMode:UIViewContentModeScaleToFill];
		}

		flag = [contentMode matchAnyOf:@[@"fit", @"aspectFit", @"aspect-fit"]];
		if ( flag )
		{
			[self setContentMode:UIViewContentModeScaleAspectFit];
		}

		flag = [contentMode matchAnyOf:@[@"fill", @"aspectFill", @"aspect-fill"]];
		if ( flag )
		{
			[self setContentMode:UIViewContentModeScaleAspectFill];
		}
		
		flag = [contentMode matchAnyOf:@[@"c", @"center"]];
		if ( flag )
		{
			[self setContentMode:UIViewContentModeCenter];
		}

		flag = [contentMode matchAnyOf:@[@"t", @"top"]];
		if ( flag )
		{
			[self setContentMode:UIViewContentModeTop];
		}

		flag = [contentMode matchAnyOf:@[@"b", @"bottom"]];
		if ( flag )
		{
			[self setContentMode:UIViewContentModeBottom];
		}

		flag = [contentMode matchAnyOf:@[@"l", @"left"]];
		if ( flag )
		{
			[self setContentMode:UIViewContentModeLeft];
		}

		flag = [contentMode matchAnyOf:@[@"r", @"right"]];
		if ( flag )
		{
			[self setContentMode:UIViewContentModeRight];
		}
		
		flag = [contentMode matchAnyOf:@[@"tl", @"topLeft", @"top-left", @"lt", @"leftTop", @"left-top"]];
		if ( flag )
		{
			[self setContentMode:UIViewContentModeTopLeft];
		}

		flag = [contentMode matchAnyOf:@[@"tr", @"topRight", @"top-right", @"rt", @"rightTop", @"right-top"]];
		if ( flag )
		{
			[self setContentMode:UIViewContentModeTopRight];
		}
		
		flag = [contentMode matchAnyOf:@[@"bl", @"bottomLeft", @"bottom-left", @"lb", @"leftBottom", @"left-bottom"]];
		if ( flag )
		{
			[self setContentMode:UIViewContentModeBottomLeft];
		}
		
		flag = [contentMode matchAnyOf:@[@"br", @"bottomRight", @"bottom-right", @"rb", @"rightBottom", @"right-bottom"]];
		if ( flag )
		{
			[self setContentMode:UIViewContentModeBottomRight];
		}
	}
	
// setText
	
	if ( [self respondsToSelector:@selector(setText:)] )
	{
		NSString * text = [properties stringOfAny:@[@"text", @"content", @"value", @"val"]];
		if ( text )
		{
			[self performSelector:@selector(setText:) withObject:text];
		}	
	}

// setTextColor
	
	if ( [self respondsToSelector:@selector(setTextColor:)] )
	{
		NSString * textColor = [properties stringOfAny:@[@"textColor", @"text-color", @"foregroundColor", @"foreground-Color", @"fgColor", @"fg-Color"]];
		if ( textColor )
		{
			[self performSelector:@selector(setTextColor:) withObject:[UIColor colorWithString:textColor]];
		}
	}
	
// setFont
	
	if ( [self respondsToSelector:@selector(setFont:)] )
	{
		// 18,system,bold
		// 18,arial
		// 18
		// 18,bold
		// 18,italic

		NSString * font = [properties stringOfAny:@[@"font"]];
		if ( font )
		{
			NSArray * array = [font componentsSeparatedByString:@","];
			if ( 1 == array.count )
			{
				[self performSelector:@selector(setFont:) withObject:[UIFont systemFontOfSize:font.floatValue]];
			}
			else
			{
				UIFont * userFont = nil;
				
				NSString * size = nil;
				NSString * family = nil;
				NSString * attribute = nil;
				
				if ( array.count >= 3 )
				{
					attribute = ((NSString *)[array objectAtIndex:2]).trim;
				}
				if ( array.count >= 2 )
				{
					NSString * temp = ((NSString *)[array objectAtIndex:1]).trim;

					NSComparisonResult result1 = [temp compare:@"bold" options:NSCaseInsensitiveSearch];
					NSComparisonResult result2 = [temp compare:@"italic" options:NSCaseInsensitiveSearch];
					
					if ( NSOrderedSame == result1 || NSOrderedSame == result2 )
					{
						attribute = temp;
					}
					else
					{
						family = temp;
					}
				}
				if ( array.count >= 1 )
				{
					size = ((NSString *)[array objectAtIndex:0]).trim;
				}

				BOOL isSystem = YES;
				BOOL isItalic = NO;
				BOOL isBold = NO;
				
				if ( NSOrderedSame != [family compare:@"system" options:NSCaseInsensitiveSearch] )
				{
					isSystem = NO;
				}

				if ( NSOrderedSame == [attribute compare:@"bold" options:NSCaseInsensitiveSearch] )
				{
					isBold = YES;
				}
				else if ( NSOrderedSame == [attribute compare:@"italic" options:NSCaseInsensitiveSearch] )
				{
					isItalic = YES;
				}

				if ( isSystem )
				{
					if ( isBold )
					{
						userFont = [UIFont boldSystemFontOfSize:size.floatValue];
					}
					else if ( isItalic )
					{
						userFont = [UIFont italicSystemFontOfSize:size.floatValue];
					}
					else
					{
						userFont = [UIFont systemFontOfSize:size.floatValue];
					}
				}
				else
				{
					userFont = [UIFont fontWithName:family size:size.floatValue];
				}

				if ( nil == userFont )
				{
					userFont = [UIFont systemFontOfSize:14.0f];
				}

				[self performSelector:@selector(setFont:) withObject:userFont];
			}
		}
	}

// setTextAlignment
	
	if ( [self respondsToSelector:@selector(setTextAlignment:)] )
	{
		NSString * textAlignment = [properties stringOfAny:@[@"align", @"alignment", @"textAlign", @"text-align", @"textAlignment", @"text-alignment"]].trim;
		if ( textAlignment )
		{
			if ( NSOrderedSame == [textAlignment compare:@"left" options:NSCaseInsensitiveSearch] )
			{
				objc_msgSend( self, @selector(setTextAlignment:), UITextAlignmentLeft );
			}
			else if ( NSOrderedSame == [textAlignment compare:@"right" options:NSCaseInsensitiveSearch] )
			{
				objc_msgSend( self, @selector(setTextAlignment:), UITextAlignmentRight );
			}
			else if ( NSOrderedSame == [textAlignment compare:@"center" options:NSCaseInsensitiveSearch] )
			{
				objc_msgSend( self, @selector(setTextAlignment:), UITextAlignmentCenter );
			}
		}
	}
	
// setLineBreakMode
	
	if ( [self respondsToSelector:@selector(setLineBreakMode:)] )
	{
		NSString * lineBreakMode = [properties stringOfAny:@[@"lineBreak", @"wrap", @"trunk", @"break", @"lineBreakMode"]].trim;
		if ( lineBreakMode )
		{
			if ( NSOrderedSame == [lineBreakMode compare:@"word" options:NSCaseInsensitiveSearch] ||
				NSOrderedSame == [lineBreakMode compare:@"WordWrap" options:NSCaseInsensitiveSearch] ||
				NSOrderedSame == [lineBreakMode compare:@"word-wrap" options:NSCaseInsensitiveSearch] )
			{
				objc_msgSend( self, @selector(setLineBreakMode:), UILineBreakModeWordWrap );
			}
			else if ( NSOrderedSame == [lineBreakMode compare:@"char" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"CharacterWrap" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"character-wrap" options:NSCaseInsensitiveSearch] )
			{
				objc_msgSend( self, @selector(setLineBreakMode:), UILineBreakModeCharacterWrap );
			}
			else if ( NSOrderedSame == [lineBreakMode compare:@"Clip" options:NSCaseInsensitiveSearch] )
			{
				objc_msgSend( self, @selector(setLineBreakMode:), UILineBreakModeClip );
			}
			else if ( NSOrderedSame == [lineBreakMode compare:@"...a" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"HeadTruncation" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"head-truncation" options:NSCaseInsensitiveSearch] )
			{
				objc_msgSend( self, @selector(setLineBreakMode:), UILineBreakModeHeadTruncation );
			}
			else if ( NSOrderedSame == [lineBreakMode compare:@"a..." options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"TailTruncation" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"tail-truncation" options:NSCaseInsensitiveSearch] )
			{
				objc_msgSend( self, @selector(setLineBreakMode:), UILineBreakModeTailTruncation );
			}
			else if ( NSOrderedSame == [lineBreakMode compare:@"a..b" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"MiddleTruncation" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [lineBreakMode compare:@"middle-truncation" options:NSCaseInsensitiveSearch] )
			{
				objc_msgSend( self, @selector(setLineBreakMode:), UILineBreakModeMiddleTruncation );
			}
		}
	}
	
	
// setNumberOfLines
	
	if ( [self respondsToSelector:@selector(setNumberOfLines:)] )
	{
		NSString * numberOfLines = [properties stringOfAny:@[@"lines", @"numberOfLines", @"number-of-lines"]].trim;
		if ( numberOfLines )
		{
			objc_msgSend( self, @selector(setNumberOfLines:), numberOfLines.integerValue );
		}
	}
    
// setBackgroundImage
	
    NSString * backgroundImage = [properties stringOfAny:@[@"bg-image", @"bgImage", @"backgroundImage", @"background-image"]];
    if ( backgroundImage )
    {
        UIImage * image = nil;
     
        NSString * stretchInsets = [properties stringOfAny:@[@"bg-insets", @"bgInsets", @"bg-padding", @"bgPadding", @"backgroundPadding", @"background-padding", @"backgroundInsets", @"background-insets", @"stretchInsets", @"stretch-insets"]];
        if ( stretchInsets )
        {
			UIEdgeInsets insets = UIEdgeInsetsZero;
			
			stretchInsets = stretchInsets.trim.unwrap;
			if ( [stretchInsets hasPrefix:@"{"] )
			{
				insets = UIEdgeInsetsFromString(stretchInsets);
			}
			else
			{
				NSArray * array = [stretchInsets componentsSeparatedByString:@" "];
				if ( 1 == array.count )
				{
					CGFloat value = [[array objectAtIndex:0] floatValue];
					insets = UIEdgeInsetsMake( value, value, value, value );
				}
				else if ( 2 == array.count )
				{
					CGFloat value1 = [[array objectAtIndex:0] floatValue];
					CGFloat value2 = [[array objectAtIndex:1] floatValue];
					
					insets = UIEdgeInsetsMake( value2, value1, value2, value1 );
				}
				else if ( 4 == array.count )
				{
					CGFloat t = [[array objectAtIndex:0] floatValue];
					CGFloat r = [[array objectAtIndex:1] floatValue];
					CGFloat b = [[array objectAtIndex:2] floatValue];
					CGFloat l = [[array objectAtIndex:3] floatValue];
					
					insets = UIEdgeInsetsMake( t, l, b, r );
				}
			}

            image = [UIImage imageNamed:backgroundImage stretched:insets];
        }
        else
        {
            image = [UIImage imageNamed:backgroundImage];
        }
        
        if ( image )
        {
            self.backgroundImage = image;
        }
    }
	
// layer.cornerRadius
	
	NSString * cornerString = [properties stringOfAny:@[@"corner", @"corner-radius", @"cornerRadius"]];
	if ( cornerString )
	{
		self.layer.masksToBounds = YES;
		self.layer.cornerRadius = cornerString.floatValue;
	}
}

+ (BOOL)supportForSizeEstimating
{
	return NO;
}

- (CGSize)contentSizeByBound:(CGSize)bound
{
	return bound;
}

- (CGSize)contentSizeByWidth:(CGSize)bound
{
	return bound;
}

- (CGSize)contentSizeByHeight:(CGSize)bound
{
	return bound;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
