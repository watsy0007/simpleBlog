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
//  Bee_UILayoutScrollView.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_UIStyle.h"
#import "Bee_UIQuery.h"
#import "Bee_UILayoutGridCell.h"
#import "Bee_UILayoutScrollView.h"
#import "UIView+BeeExtension.h"
#import "UIView+BeeUILayout.h"
#import "NSArray+BeeExtension.h"

#import "JSONKit.h"
#import <objc/runtime.h>

#pragma mark -

@implementation BeeUILayoutScrollView

@synthesize cellLines = _cellLines;
@synthesize cellDatas = _cellDatas;
@synthesize cellClass = _cellClass;

+ (BOOL)supportForResourceLoading
{
	return NO;
}

- (void)load
{
    [super load];
	
	_cellLines = 1;
	_cellDatas = nil;
	_cellClass = [BeeUILayoutGridCell class];
}

- (void)unload
{
    [super unload];
}

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return _cellLines;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	if ( _cellDatas )
	{
		if ( [_cellDatas isKindOfClass:[NSArray class]] )
		{
			return ((NSArray *)_cellDatas).count;
		}
		else
		{
			return 1;
		}
	}
	
	return 0;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	BeeUILayoutGridCell * cell = [scrollView dequeueWithContentClass:self.cellClass];
	
	if ( _cellDatas )
	{
		if ( [_cellDatas isKindOfClass:[NSArray class]] )
		{
			cell.cellData = [((NSArray *)_cellDatas) objectAtIndex:index];
		}
		else
		{
			cell.cellData = _cellDatas;
		}
	}
	else
	{
		cell.cellData = nil;
	}

	return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	NSObject * cellData = nil;
	
	if ( _cellDatas )
	{
		if ( [_cellDatas isKindOfClass:[NSArray class]] )
		{
			cellData = [((NSArray *)_cellDatas) objectAtIndex:index];
		}
		else
		{
			cellData = _cellDatas;
		}
	}
	
	return [self.cellClass sizeInBound:scrollView.bounds.size forData:cellData];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
