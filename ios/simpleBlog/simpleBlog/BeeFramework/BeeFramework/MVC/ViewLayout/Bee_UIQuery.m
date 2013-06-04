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
//  Bee_UIQuery.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_Log.h"
#import "Bee_UIQuery.h"
#import "NSString+BeeExtension.h"
#import "UIView+BeeExtension.h"
#import "NSArray+BeeExtension.h"

#import "JSONKit.h"
#import <objc/runtime.h>
#import <objc/message.h>

#pragma mark -

@interface BeeUIQuery()
+ (NSMutableArray *)findViewsIn:(UIView * )rootView byExpression:(NSString *)tag;
@end

#pragma mark -

BeeUIQueryObjectBlockN __getQueryBlock( id context )
{
	// C
	
	BeeUIQueryContextBlock contextBlock = ^ BeeUIQueryObjectBlockN ( id context )
	{
		// OC Runtime

		id self = context;

		BeeUIQueryObjectBlockN resultBlock = ^ BeeUIQuery * ( id first, ... )
		{
			// OC Runtime with self

			BeeUIQuery * wrapper = [[[BeeUIQuery alloc] init] autorelease];
			if ( nil == wrapper )
				return nil;
			
			if ( [first isKindOfClass:[UIView class]] )
			{
				wrapper.object = first;
			}
			else if ( [first isKindOfClass:[UIViewController class]] )
			{
				wrapper.object = first;
			}
			else if ( [first isKindOfClass:[NSString class]] )
			{
				UIView * rootView = nil;

				if ( [self isKindOfClass:[UIView class]] )
				{
					rootView = (UIView *)self;
				}
				else if ( [self isKindOfClass:[UIViewController class]] )
				{
					rootView = ((UIViewController *)self).view;
				}
				else if ( [self isKindOfClass:[UIWindow class]] )
				{
					rootView = (UIView *)self;
				}

				if ( rootView )
				{
					wrapper.retainedObject = [BeeUIQuery findViewsIn:rootView byExpression:(NSString *)first];
				}
			}

			return wrapper;
		};

		return [[resultBlock copy] autorelease];
	};

	return contextBlock( context );
}

#pragma mark -

@implementation BeeUIQuery

@dynamic HIDE;
@dynamic SHOW;
@dynamic TOGGLE;

//@dynamic UNWRAP;
//@dynamic WRAP;

@dynamic text;
@dynamic texts;
@dynamic image;
@dynamic images;
@dynamic selected;

@dynamic APPEND;
@dynamic PREPEND;
@dynamic REMOVE;
@dynamic EMPTY;
@dynamic REPLACE_WITH;

@dynamic NUMBER;
@dynamic TEXT;
@dynamic IMAGE;
@dynamic RESOURCE;
@dynamic URL;
@dynamic VAL;

@dynamic ENABLE;
@dynamic DISABLE;

@dynamic EACH;
@dynamic FIND;
@dynamic FILTER;

@dynamic FIRST;
@dynamic LAST;
@dynamic NEXT;
@dynamic PREV;
@dynamic CHILDREN;
@dynamic PARENT;
@dynamic PARENTS;
@dynamic SIBLINGS;

@dynamic FOCUS;
@dynamic BLUR;

@dynamic SELECT;
@dynamic UNSELECT;

+ (NSMutableArray *)findViewsIn:(UIView * )rootView byExpression:(NSString *)tag
{
	NSMutableArray * result = [NSMutableArray nonRetainingArray];
	
	NSArray * tags = [tag componentsSeparatedByString:@","];
	for ( NSString * subTag in tags )
	{
		subTag = subTag.trim;
		
		if ( [subTag isEqualToString:@"*"] )
		{
			[result addObjectsFromArray:rootView.subviews];
		}
		else if ( [subTag hasPrefix:@"#"] )
		{
			subTag = [subTag substringFromIndex:1];
			
			if ( subTag.length >= 3 && [subTag hasPrefix:@"/"] && [subTag hasSuffix:@"/"] )
			{
				NSString * regex = [subTag substringWithRange:NSMakeRange(1, subTag.length - 2)];
				
				NSArray * objs = [rootView viewWithTagMatchRegex:regex];
				if ( objs && objs.count )
				{
					[result addObjectsFromArray:objs];
				}
			}
			else
			{
				NSObject * obj = [rootView viewWithTagString:subTag];
				if ( obj )
				{
					[result addObject:obj];
				}
			}
		}
		else if ( [subTag hasPrefix:@"."] )
		{
			Class clazz = NSClassFromString( [subTag substringFromIndex:1] );
			if ( nil == clazz )
			{
				clazz = [UIView class];
			}
			
			if ( clazz )
			{
				NSMutableArray * array2 = [NSMutableArray nonRetainingArray];
				for ( UIView * view in rootView.subviews )
				{
					if ( [view isKindOfClass:clazz] )
					{
						[array2 addObject:view];
					}
				}
				
				[result addObjectsFromArray:array2];
			}
		}
		else
		{
			NSArray * paths = [subTag componentsSeparatedByString:@">"];
			if ( paths.count > 1 )
			{
				UIView * subview = rootView;
				
				for ( NSString * path in paths )
				{
					subview = [subview viewWithTagString:path.trim];
					if ( nil == subview )
						break;
				}
				
				if ( subview )
				{
					[result addObject:subview];
				}
			}
			else
			{
				if ( subTag.length >= 3 && [subTag hasPrefix:@"/"] && [subTag hasSuffix:@"/"] )
				{
					NSString * regex = [subTag substringWithRange:NSMakeRange(1, subTag.length - 2)];
					
					NSArray * objs = [rootView viewWithTagMatchRegex:regex];
					if ( objs && objs.count )
					{
						[result addObjectsFromArray:objs];
					}
				}
				else
				{
					UIView * subview = [rootView viewWithTagString:subTag];
					if ( subview )
					{
						[result addObject:subview];
					}
				}
			}
		}
	}
	
#if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	if ( 0 == result.count )
	{
		CC( @"No subviews matched by '%@'", tag );
	}
#endif	// #if defined(__BEE_DEVELOPMENT__) && __BEE_DEVELOPMENT__
	
	return result;
}

- (BeeUIQueryObjectBlock)HIDE
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			v.hidden = YES;
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)SHOW
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			v.hidden = NO;
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)TOGGLE
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			v.hidden = v.hidden ? NO : YES;
		}
		return self;
	};
	
	return [[block copy] autorelease];	
}

//- (BeeUIQueryObjectBlock)UNWRAP
//{
//	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
//	{
//		// TODO:
//		return self;
//	};
//	
//	return [[block copy] autorelease];
//}
//
//- (BeeUIQueryObjectBlockCS)WRAP
//{
//	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
//	{
//		// TODO:
//		return self;
//	};
//	
//	return [[block copy] autorelease];
//}

- (BeeUIQueryObjectBlockCS)BEFORE
{
	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
	{
		if ( nil == clazz )
		{
			clazz = [UIView class];
		}
		
		if ( clazz != [UIView class] && NO == [clazz isSubclassOfClass:[UIView class]] )
			return self;
		
		for ( UIView * v in self.views )
		{
			if ( nil == v.superview )
				continue;
			
			UIView * view = [[[clazz alloc] initWithFrame:CGRectZero] autorelease];
			if ( view )
			{
				view.tagString = tag;
				[v.superview insertSubview:view belowSubview:v];
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockCS)AFTER
{
	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
	{
		if ( nil == clazz )
		{
			clazz = [UIView class];
		}

		if ( clazz != [UIView class] && NO == [clazz isSubclassOfClass:[UIView class]] )
			return self;
		
		for ( UIView * v in self.views )
		{
			if ( nil == v.superview )
				continue;
			
			UIView * view = [[[clazz alloc] initWithFrame:CGRectZero] autorelease];
			if ( view )
			{
				view.tagString = tag;
				[v.superview insertSubview:view aboveSubview:v];
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockCS)APPEND
{
	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
	{
		if ( nil == clazz )
		{
			clazz = [UIView class];
		}

		if ( clazz != [UIView class] && NO == [clazz isSubclassOfClass:[UIView class]] )
			return self;

		for ( UIView * v in self.views )
		{
			UIView * view = [[[clazz alloc] initWithFrame:CGRectZero] autorelease];
			if ( view )
			{
				view.tagString = tag;
				[v addSubview:view];
				[v bringSubviewToFront:view];
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockCS)PREPEND
{
	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
	{
		if ( nil == clazz )
		{
			clazz = [UIView class];
		}

		if ( clazz != [UIView class] && NO == [clazz isSubclassOfClass:[UIView class]] )
			return self;

		for ( UIView * v in self.views )
		{
			UIView * view = [[[clazz alloc] initWithFrame:CGRectZero] autorelease];
			if ( view )
			{
				view.tagString = tag;
				[v addSubview:view];
				[v sendSubviewToBack:view];
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)REMOVE
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			[v removeFromSuperview];
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)EMPTY
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			[v removeAllSubviews];
		}
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockS)REPLACE_ALL
{
	BeeUIQueryObjectBlockS block = ^ BeeUIQuery * ( NSString * tag )
	{
		// TODO:
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockCS)REPLACE_WITH
{
	BeeUIQueryObjectBlockCS block = ^ BeeUIQuery * ( Class clazz, NSString * tag )
	{
		if ( nil == clazz )
		{
			clazz = [UIView class];
		}

		for ( UIView * v in self.views )
		{
			UIView * parentView = v.superview;
			if ( parentView )
			{
				UIView * newView = [[[clazz alloc] init] autorelease];
				if ( newView )
				{
					newView.tagString = tag;
					
					[parentView insertSubview:newView aboveSubview:v];
					[v removeFromSuperview];
				}
			}
		}

		return self;
	};

	return [[block copy] autorelease];
}

- (BOOL)selected
{
	UIView * view = self.view;
	
	if ( view && [view respondsToSelector:@selector(selected)] )
	{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

		return (BOOL)objc_msgSend( view, @selector(selected) );
		
#pragma clang diagnostic pop
	}

	return NO;
}

- (NSString *)text
{
	UIView * view = self.view;

	if ( view && [view respondsToSelector:@selector(text)] )
	{
		NSObject * result = [view performSelector:@selector(text)];
		if ( result && [result isKindOfClass:[NSString class]] )
			return (NSString *)result;
	}

	return nil;
}

- (NSArray *)texts
{
	NSMutableArray * array = [NSMutableArray nonRetainingArray];
	
	for ( UIView * view in self.views )
	{
		if ( view && [view respondsToSelector:@selector(text)] )
		{
			NSObject * result = [view performSelector:@selector(text)];
			if ( result && [result isKindOfClass:[NSString class]] )
			{
				[array addObject:result];
			}
		}
	}
	
	return array;
}

- (UIImage *)image
{
	UIView * view = self.view;
	
	if ( view && [view respondsToSelector:@selector(image)] )
	{
		NSObject * result = [view performSelector:@selector(image)];
		if ( result && [result isKindOfClass:[UIImage class]] )
			return (UIImage *)result;
	}
	
	return nil;
}

- (NSArray *)images
{
	NSMutableArray * array = [NSMutableArray nonRetainingArray];
	
	for ( UIView * view in self.views )
	{
		if ( view && [view respondsToSelector:@selector(image)] )
		{
			NSObject * result = [view performSelector:@selector(image)];
			if ( result && [result isKindOfClass:[UIImage class]] )
			{
				[array addObject:result];
			}
		}
	}
	
	return array;
}

- (BeeUIQueryValueBlockN)NUMBER
{
	BeeUIQueryValueBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		if ( first && [first isKindOfClass:[NSNumber class]] )
		{
			NSString * text = [(NSNumber *)first description];
			
			for ( UIView * v in self.views )
			{
				if ( [v respondsToSelector:@selector(setText:)] )
				{
					[v performSelector:@selector(setText:) withObject:text];
				}
				else if ( [v respondsToSelector:@selector(setTitle:)] )
				{
					[v performSelector:@selector(setTitle:) withObject:text];
				}
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryValueBlockN)TEXT
{
	BeeUIQueryValueBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		if ( first && [first isKindOfClass:[NSString class]] )
		{
			va_list args;
			va_start( args, first );
			
			NSString * text = [[[NSString alloc] initWithFormat:first arguments:args] autorelease];
			
			va_end( args );

			for ( UIView * v in self.views )
			{
				if ( [v respondsToSelector:@selector(setText:)] )
				{
					[v performSelector:@selector(setText:) withObject:text];
				}
				else if ( [v respondsToSelector:@selector(setTitle:)] )
				{
					[v performSelector:@selector(setTitle:) withObject:text];
				}
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryValueBlockN)IMAGE
{
	BeeUIQueryValueBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		if ( first )
		{
			if ( [first isKindOfClass:[NSString class]] )
			{
				NSString * imageName = (id)first;

				if ( [imageName hasPrefix:@"http://"] || [imageName hasPrefix:@"https://"] )
				{
					for ( UIView * v in self.views )
					{
						if ( [v respondsToSelector:@selector(readFromURL:)] )
						{
							[v performSelector:@selector(readFromURL:) withObject:imageName];
						}
					}
				}
				else if ( [imageName hasPrefix:@"localhost://"] )
				{
					imageName = [imageName substringFromIndex:@"localhost://".length];

					for ( UIView * v in self.views )
					{
						if ( [v respondsToSelector:@selector(readFromFile:)] )
						{
							[v performSelector:@selector(readFromFile:) withObject:imageName];
						}
					}
				}
				else if ( [imageName hasPrefix:@"file://"] )
				{
					imageName = [imageName substringFromIndex:@"file://".length];
						
					for ( UIView * v in self.views )
					{
						if ( [v respondsToSelector:@selector(readFromFile:)] )
						{
							[v performSelector:@selector(readFromFile:) withObject:imageName];
						}
					}
				}
				else if ( [imageName hasPrefix:@"res://"] )
				{
					imageName = [imageName substringFromIndex:@"res://".length];
					
					for ( UIView * v in self.views )
					{
						if ( [v respondsToSelector:@selector(readFromURL:)] )
						{
							[v performSelector:@selector(readFromURL:) withObject:imageName];
						}
					}
				}
				else
				{
					UIImage * userImage = [UIImage imageNamed:imageName];
					if ( userImage )
					{
						for ( UIView * v in self.views )
						{
							if ( [v respondsToSelector:@selector(setImage:)] )
							{
								[v performSelector:@selector(setImage:) withObject:userImage];
							}
						}
					}
				}
			}
		}
		else
		{
			for ( UIView * v in self.views )
			{
				[v performSelector:@selector(setImage:) withObject:nil];
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryValueBlockN)URL
{
	BeeUIQueryValueBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		if ( first && [first isKindOfClass:[NSString class]] )
		{
			for ( UIView * v in self.views )
			{
				if ( [v respondsToSelector:@selector(setUrl:)] )
				{
					[v performSelector:@selector(setUrl:) withObject:first];
				}
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryValueBlockN)RESOURCE
{
	BeeUIQueryValueBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		if ( first && [first isKindOfClass:[NSString class]] )
		{
			for ( UIView * v in self.views )
			{
				if ( [v respondsToSelector:@selector(setResource:)] )
				{
					[v performSelector:@selector(setResource:) withObject:first];
				}
			}
		}

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockN)VAL
{
	BeeUIQueryObjectBlockN block = ^ BeeUIQuery * ( id first, ... )
	{
		// TODO:
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)ENABLE
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			v.userInteractionEnabled = YES;

			if ( [v respondsToSelector:@selector(setEnabled:)] )
			{
				objc_msgSend( v, @selector(setEnabled:), YES );
			}
		}
		return self;
	};

	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)DISABLE
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			v.userInteractionEnabled = NO;
			
			if ( [v respondsToSelector:@selector(setEnabled:)] )
			{
				objc_msgSend( v, @selector(setEnabled:), NO );
			}
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockX)EACH
{
	BeeUIQueryObjectBlockX block = ^ BeeUIQuery * ( void (^block)(UIView *) )
	{
		for ( UIView * v in self.views )
		{
			block( v );
		}
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)FIRST
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.object = [self.views objectAtIndex:0];
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)LAST
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.object = [self.views lastObject];
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockS)FIND
{
	BeeUIQueryObjectBlockS block = ^ BeeUIQuery * ( NSString * tag )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];

		for ( UIView * v in self.views )
		{
			NSArray * results = [BeeUIQuery findViewsIn:v byExpression:tag];
			if ( results && results.count )
			{
				[array addObjectsFromArray:results];
			}	
		}

		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlockS)FILTER
{
	BeeUIQueryObjectBlockS block = ^ BeeUIQuery * ( NSString * tag )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];

		for ( UIView * v in self.views )
		{
			if ( [tag isEqualToString:@"*"] )
			{
				[array addObject:v];
			}
			else if ( [tag hasPrefix:@"#"] )
			{
				if ( [v.tagString isEqualToString:[tag substringFromIndex:1]] )
				{
					[array addObject:v];
				}
			}
			else if ( [tag hasPrefix:@"."] )
			{
				Class clazz = NSClassFromString( [tag substringFromIndex:1] );
				if ( nil == clazz )
				{
					clazz = [UIView class];
				}

				if ( clazz && [v isKindOfClass:clazz] )
				{
					[array addObject:v];
				}
			}
			else
			{
				if ( [v.tagString isEqualToString:tag] )
				{
					[array addObject:v];
				}
			}
		}

		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)NEXT
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];
		
		for ( UIView * v in self.views )
		{
			UIView * sibling = [v nextSibling];
			if ( sibling )
			{
				[array addObject:sibling];
			}
		}

		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)PREV
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];
		
		for ( UIView * v in self.views )
		{
			UIView * sibling = [v prevSibling];
			if ( sibling )
			{
				[array addObject:sibling];
			}
		}
		
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)PARENT
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];
		
		for ( UIView * v in self.views )
		{
			if ( v.superview )
			{
				[array addObject:v.superview];
			}
		}

		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)CHILDREN
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];

		for ( UIView * v in self.views )
		{
			[array addObjectsFromArray:v.subviews];
		}
		
		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (void)walkThroughSuperviews:(UIView *)view forArray:(NSMutableArray *)array
{
	if ( nil == view.superview )
		return;
	
	[array addObject:view.superview];
	
	[self walkThroughSuperviews:view.superview forArray:array];
}

- (BeeUIQueryObjectBlock)PARENTS
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];

		for ( UIView * v in self.views )
		{
			[self walkThroughSuperviews:v forArray:array];
		}

		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)SIBLINGS
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		NSMutableArray * array = [NSMutableArray nonRetainingArray];

		for ( UIView * v in self.views )
		{
			if ( v.superview )
			{
				[array addObjectsFromArray:v.superview.subviews];
				[array removeObject:v];	
			}
		}

		BeeUIQuery * q = [[[BeeUIQuery alloc] init] autorelease];
		q.retainedObject = array;
		return q;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)FOCUS
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			BOOL focus = [v becomeFirstResponder];
			if ( focus )
			{
				break;
			}
		}

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)BLUR
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			BOOL focus = [v resignFirstResponder];
			if ( focus )
			{
				break;
			}
		}
		
		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)SELECT
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			if ( [v respondsToSelector:@selector(setSelected:)] )
			{
				objc_msgSend( v, @selector(setSelected:), YES );
			}
		}

		return self;
	};
	
	return [[block copy] autorelease];
}

- (BeeUIQueryObjectBlock)UNSELECT
{
	BeeUIQueryObjectBlock block = ^ BeeUIQuery * ( void )
	{
		for ( UIView * v in self.views )
		{
			if ( [v respondsToSelector:@selector(setSelected:)] )
			{
				objc_msgSend( v, @selector(setSelected:), NO );
			}
		}

		return self;
	};
	
	return [[block copy] autorelease];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
