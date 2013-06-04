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
//  Bee_UILayoutGridCell.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UIStyle.h"
#import "Bee_UIQuery.h"
#import "Bee_UILayoutGridCell.h"
#import "UIView+BeeExtension.h"
#import "UIView+BeeUILayout.h"
#import "NSArray+BeeExtension.h"

#import "JSONKit.h"
#import <objc/runtime.h>

#pragma mark -

@interface BeeUILayoutGridCell(Private)
+ (BeeUILayoutGridCell *)temporaryCell;
@end

#pragma mark -

@implementation BeeUILayoutGridCell

+ (BOOL)supportForResourceLoading
{
	return YES;
}

+ (NSString *)resourceExtension
{
	return @"xml";
}

+ (NSString *)resourceName
{
	return [NSString stringWithFormat:@"%@.%@", [[self class] description], [[self class] resourceExtension]];
}

+ (BeeUILayoutGridCell *)temporaryCell
{
	static BeeUILayoutGridCell * __tempCell = nil;
	if ( nil == __tempCell )
	{
		__tempCell = [[[self class] alloc] init];
		__tempCell.frame = CGRectZero;
	}
    else
    {
        if ( [__tempCell isNotKindOfClass:[self class]] )
        {
            [__tempCell release];
            __tempCell = [[[self class] alloc] init];
            __tempCell.frame = CGRectZero;
        }
    }
	return __tempCell;
}

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
	BeeUILayoutGridCell * cell = [self temporaryCell];
	if ( cell )
	{
		cell.cellData = data;

		CGRect cellFrame = [cell.layout estimateFrameBy:CGSizeMakeBound(bound)];
		return cellFrame.size;		
	}

	return [super sizeInBound:bound forData:data];
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
    self.RELAYOUT();
}

- (void)load
{
    [super load];

	self.FROM_RESOURCE( [[self class] resourceName] );
}

- (void)unload
{
    [super unload];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
