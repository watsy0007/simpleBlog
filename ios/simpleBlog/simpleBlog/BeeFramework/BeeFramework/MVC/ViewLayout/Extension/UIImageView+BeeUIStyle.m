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
//  UIImageView+BeeUIStyle.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "UIImageView+BeeUIStyle.h"
#import "UIImage+BeeExtension.h"
#import "UIView+BeeUIStyle.h"
#import "NSDictionary+BeeExtension.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIImageView (BeeUIStyle)

- (void)applyStyleProperties:(NSDictionary *)properties
{
    [super applyStyleProperties:properties];
    
// setImage
	
    NSString * image = [properties stringOfAny:@[@"image"]];
    if ( image )
    {
		NSArray *	array = [image componentsSeparatedByString:@","];
		NSString *	imageName = [array objectAtIndex:0];

		if ( array.count > 1 )
		{
			for ( NSString * attr in [array subarrayWithRange:NSMakeRange(1, array.count - 1)] )
			{
				attr = attr.trim.unwrap;

				if ( NSOrderedSame == [attr compare:@"stretch" options:NSCaseInsensitiveSearch] ||
					NSOrderedSame == [attr compare:@"stretched" options:NSCaseInsensitiveSearch] )
				{
					if ( [self respondsToSelector:@selector(setStrech:)] )
					{
						objc_msgSend( self, @selector(setStrech:), YES );
					}
				}
				else if ( NSOrderedSame == [attr compare:@"round" options:NSCaseInsensitiveSearch] ||
						 NSOrderedSame == [attr compare:@"rounded" options:NSCaseInsensitiveSearch] )
				{
					if ( [self respondsToSelector:@selector(setRound:)] )
					{
						objc_msgSend( self, @selector(setRound:), YES );
					}
				}
				else if ( NSOrderedSame == [attr compare:@"gray" options:NSCaseInsensitiveSearch] ||
						 NSOrderedSame == [attr compare:@"grayed" options:NSCaseInsensitiveSearch] ||
						 NSOrderedSame == [attr compare:@"grayScale" options:NSCaseInsensitiveSearch] ||
						 NSOrderedSame == [attr compare:@"gray-scale" options:NSCaseInsensitiveSearch] )
				{
					if ( [self respondsToSelector:@selector(setGray:)] )
					{
						objc_msgSend( self, @selector(setGray:), YES );
					}
				}
			}
		}

		if ( [imageName hasPrefix:@"http://"] || [imageName hasPrefix:@"https://"] )
		{
			if ( [self respondsToSelector:@selector(readFromURL:)] )
			{
				[self performSelector:@selector(readFromURL:) withObject:imageName];
			}
		}
		else if ( [imageName hasPrefix:@"localhost://"] )
		{
			if ( [self respondsToSelector:@selector(readFromFile:)] )
			{
				imageName = [imageName substringFromIndex:@"localhost://".length];
				
				[self performSelector:@selector(readFromFile:) withObject:imageName];
			}			
		}
		else if ( [imageName hasPrefix:@"file://"] )
		{
			if ( [self respondsToSelector:@selector(readFromFile:)] )
			{
				imageName = [imageName substringFromIndex:@"file://".length];

				[self performSelector:@selector(readFromFile:) withObject:imageName];
			}
		}
		else if ( [imageName hasPrefix:@"res://"] )
		{
			if ( [self respondsToSelector:@selector(readFromURL:)] )
			{
				imageName = [imageName substringFromIndex:@"res://".length];
				
				[self performSelector:@selector(readFromURL:) withObject:imageName];
			}
		}
		else
		{
            UIImage * userImage = nil;

			NSString * stretchInsets = [properties stringOfAny:@[@"padding", @"insets", @"stretchInsets", @"stretch-insets"]];
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

                userImage = [UIImage imageNamed:imageName stretched:insets];
            }
            else
            {
                userImage = [UIImage imageNamed:imageName];
            }

			if ( userImage )
			{
				[self setImage:userImage];
			}
		}
    }

//    NSString * highlightedImage = [properties valueForKey:@"highlightedImage"];
//    if ( highlightedImage )
//    {
//        [self setHighlightedImage:[UIImage imageNamed:highlightedImage]];
//    }
}

+ (BOOL)supportForSizeEstimating
{
	return YES;
}

- (CGSize)contentSizeByBound:(CGSize)bound
{
	if ( nil == self.image )
		return CGSizeZero;

	if ( UIViewContentModeScaleAspectFill == self.contentMode )
	{
		return AspectFillSize( self.image.size, bound );
	}
	else if ( UIViewContentModeScaleAspectFit == self.contentMode )
	{
		return AspectFitSize( self.image.size, bound );
	}

	return self.image.size;
}

- (CGSize)contentSizeByWidth:(CGSize)bound
{
	if ( nil == self.image )
		return CGSizeZero;

	if ( UIViewContentModeScaleAspectFill == self.contentMode )
	{
		return AspectFillSizeByWidth( self.image.size, bound.width );
	}
	else if ( UIViewContentModeScaleAspectFit == self.contentMode )
	{
		return AspectFitSizeByWidth( self.image.size, bound.width );
	}

	return self.image.size;
}

- (CGSize)contentSizeByHeight:(CGSize)bound
{
	if ( nil == self.image )
		return CGSizeZero;

	if ( UIViewContentModeScaleAspectFill == self.contentMode )
	{
		return AspectFillSizeByHeight( self.image.size, bound.height );
	}
	else if ( UIViewContentModeScaleAspectFit == self.contentMode )
	{
		return AspectFitSizeByHeight( self.image.size, bound.height );
	}

	return self.image.size;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
