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
//  UITextField+BeeUIStyle.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "UITextField+BeeUIStyle.h"
#import "UIView+BeeUIStyle.h"
#import "NSDictionary+BeeExtension.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation UITextField (BeeUIStyle)

- (void)applyStyleProperties:(NSDictionary *)properties
{
    [super applyStyleProperties:properties];
    
    NSString * placeholder = [properties stringOfAny:@[@"placeholder", @"placeHolder", @"place-holder"]];
    if ( placeholder )
    {
        [self setPlaceholder:placeholder];
    }
    
    NSString * returnKeyType = [properties stringOfAny:@[@"return", @"returnKeyType", @"returnType"]];
    if ( returnKeyType )
    {
        if ( NSOrderedSame == [returnKeyType compare:@"Done" options:NSCaseInsensitiveSearch] )
        {
            [self setReturnKeyType:UIReturnKeyDone];
        }
        else if ( NSOrderedSame == [returnKeyType compare:@"Search" options:NSCaseInsensitiveSearch] )
        {
            [self setReturnKeyType:UIReturnKeySearch];
        }
        else if ( NSOrderedSame == [returnKeyType compare:@"Join" options:NSCaseInsensitiveSearch] )
        {
            [self setReturnKeyType:UIReturnKeyJoin];
        }
        else if ( NSOrderedSame == [returnKeyType compare:@"Send" options:NSCaseInsensitiveSearch] )
        {
            [self setReturnKeyType:UIReturnKeySend];
        }
        else if ( NSOrderedSame == [returnKeyType compare:@"Next" options:NSCaseInsensitiveSearch] )
        {
            [self setReturnKeyType:UIReturnKeyNext];
        }
        else if ( NSOrderedSame == [returnKeyType compare:@"Go" options:NSCaseInsensitiveSearch] )
        {
            [self setReturnKeyType:UIReturnKeyGo];
        }
    }

    NSString * borderStyle = [properties stringOfAny:@[@"border", @"borderStyle", @"border-style"]];
    if ( borderStyle )
    {
        if ( NSOrderedSame == [borderStyle compare:@"None" options:NSCaseInsensitiveSearch] )
        {
            [self setBorderStyle:UITextBorderStyleNone];
        }
        else if ( NSOrderedSame == [borderStyle compare:@"Line" options:NSCaseInsensitiveSearch] )
        {
            [self setBorderStyle:UITextBorderStyleLine];
        }
        else if ( NSOrderedSame == [borderStyle compare:@"Bezel" options:NSCaseInsensitiveSearch] )
        {
            [self setBorderStyle:UITextBorderStyleBezel];
        }
        else if ( NSOrderedSame == [borderStyle compare:@"rounded" options:NSCaseInsensitiveSearch] ||
				 NSOrderedSame == [borderStyle compare:@"rounded-rect" options:NSCaseInsensitiveSearch] ||
				 NSOrderedSame == [borderStyle compare:@"RoundedRect" options:NSCaseInsensitiveSearch] )
        {
            [self setBorderStyle:UITextBorderStyleRoundedRect];
        }
    }
	
	NSString * clear = [properties stringOfAny:@[@"clear", @"clearButton", @"clearButtonMode", @"clear-button", @"clear-button-mode"]];
    if ( clear )
    {
		if ( NSOrderedSame == [clear compare:@"never" options:NSCaseInsensitiveSearch] )
		{
			self.clearButtonMode = UITextFieldViewModeNever;
		}
		else if ( NSOrderedSame == [clear compare:@"editing" options:NSCaseInsensitiveSearch] ||
				 NSOrderedSame == [clear compare:@"whileEditing" options:NSCaseInsensitiveSearch] ||
				 NSOrderedSame == [clear compare:@"while-editing" options:NSCaseInsensitiveSearch] )
		{
			self.clearButtonMode = UITextFieldViewModeWhileEditing;
		}
		else if ( NSOrderedSame == [clear compare:@"!editing" options:NSCaseInsensitiveSearch] ||
				 NSOrderedSame == [clear compare:@"unlessEditing" options:NSCaseInsensitiveSearch] ||
				 NSOrderedSame == [clear compare:@"unless-editing" options:NSCaseInsensitiveSearch] )
		{
			self.clearButtonMode = UITextFieldViewModeUnlessEditing;
		}
		else if ( NSOrderedSame == [clear compare:@"always" options:NSCaseInsensitiveSearch] )
		{
			self.clearButtonMode = UITextFieldViewModeAlways;
		}
	}

	if ( [self respondsToSelector:@selector(setMaxLength:)] )
	{
		NSString * maxLength = [properties stringOfAny:@[@"max", @"maxLength", @"max-length"]];
		if ( maxLength )
		{
			objc_msgSend( self, @selector(setMaxLength:), maxLength.integerValue );
		}
	}
}

+ (BOOL)supportForSizeEstimating
{
	return NO;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
