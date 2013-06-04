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
//  BeeMockServer.m
//

#include <execinfo.h>

#import "Bee_Precompile.h"
#import "Bee_Log.h"
#import "Bee_MockServer.h"
#import "NSArray+BeeExtension.h"

#include <objc/runtime.h>
#include <execinfo.h>

#pragma mark -

@implementation BeeMockServer

DEF_SINGLETON( BeeMockServer )

static NSMutableArray * __servers = nil;

@synthesize mapping = _mapping;

+ (void)load
{
	if ( nil == __servers )
	{
		__servers = [[NSMutableArray alloc] init];
	}

	BeeMockServer * mock = [BeeMockServer sharedInstance];
	if ( mock )
	{
		[__servers addObject:mock];
	}

	NSUInteger	classesCount = 0;
	Class *		classes = objc_copyClassList( &classesCount );

	for ( unsigned int i = 0; i < classesCount; ++i )
	{
		Class classType = classes[i];
		if ( classType == [BeeMockServer class] )
			continue;

//		const char * imageName = class_getImageName( classType );
//		CC( @"image = %s", imageName );

		if ( NO == class_respondsToSelector( classType, @selector(doesNotRecognizeSelector:) ) )
			continue;
		if ( NO == class_respondsToSelector( classType, @selector(methodSignatureForSelector:) ) )
			continue;
		
		if ( [classType isSubclassOfClass:[BeeMockServer class]] )
		{
			mock = [[[classType alloc] init] autorelease];
			if ( mock )
			{
				[__servers addObject:mock];
			}
		}
	}
	
	free( classes );
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.mapping = [[[NSMutableArray alloc] init] autorelease];

		[self load];
	}
	
	return self;
}

- (void)dealloc
{
	[self unload];
	
	self.mapping = nil;

	[super dealloc];
}

- (void)load
{
}

- (void)unload
{
	[__servers removeObject:self];
}

- (BOOL)prehandle:(BeeRequest *)req
{
	return YES;
}

- (void)posthandle:(BeeRequest *)req
{
	
}

- (void)index:(BeeRequest *)req
{
	CC( @"unknown request '%@'", req.url.absoluteString );
}

+ (void)route:(BeeRequest *)req
{
	for ( BeeMockServer * server in __servers )
	{
		BOOL flag = [server route:req];
		if ( flag )
			return;
	}

	BOOL flag = [[BeeMockServer sharedInstance] route:req];
	if ( flag )
		return;

	[[BeeMockServer sharedInstance] index:req];
}

- (BOOL)route:(BeeRequest *)req
{
	NSString * url = req.url.absoluteString;

	if ( [url hasPrefix:@"mock://"] )
	{
		url = [url substringFromIndex:@"mock://".length];
		url = [@"/" stringByAppendingString:url];
	}

	for ( NSArray * array in _mapping )
	{
		BOOL matched = NO;

		NSString * rule = [array objectAtIndex:0];
		if ( [rule isEqualToString:url] )
		{
			matched = YES;
		}
		else
		{
			NSMutableString * expr = [NSMutableString string];
			[expr appendString:@"^"];
			[expr appendString:@"/?"];

			NSArray * segments = [rule componentsSeparatedByString:@"/"];
			for ( NSString * segment in segments )
			{
				if ( 0 == segment.length )
					continue;
				
				if ( [segment hasPrefix:@":"] )
				{
					[expr appendString:@"([a-z0-9_]+)"];
				}
				else
				{
					[expr appendString:segment];
				}
				
				if ( [segments lastObject] != segment )
				{
					[expr appendString:@"/"];
				}
			}
			
			[expr appendString:@"/?"];
			[expr appendString:@"$"];

			NSError * error = NULL;
			NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expr options:NSRegularExpressionCaseInsensitive error:&error];
			NSTextCheckingResult * result = [regex firstMatchInString:url options:0 range:NSMakeRange(0, [url length])];
			
			matched = (result && (regex.numberOfCaptureGroups + 1) == result.numberOfRanges) ? YES : NO;
		}
			
		if ( matched )
		{
			BeeMockServer *	target = (BeeMockServer *)[[array objectAtIndex:1] unsignedIntValue];
			SEL				action = (SEL)[[array objectAtIndex:2] unsignedIntValue];
			
			BOOL flag = [target prehandle:req];
			if ( flag )
			{
				if ( target && action )
				{
					[target performSelector:action withObject:req];
//					[target performSelectorInBackground:action withObject:req];
					
					// TODO:
					req.state = BeeRequest.STATE_SUCCEED;
					[req callResponders];
					
					[target posthandle:req];
				}
				else
				{
					NSString * selName = rule;
					
					if ( [selName hasPrefix:@"mock://"] )
					{
						selName = [selName substringFromIndex:@"mock://".length];
					}

					if ( selName.length > 1  && [selName hasPrefix:@"/"] )
					{
						selName = [selName substringFromIndex:@"/".length];
					}

					if ( selName.length > 1 && [selName hasSuffix:@"/"] )
					{
						selName = [selName substringToIndex:selName.length - 2];
					}

					selName = [selName stringByReplacingOccurrencesOfString:@":" withString:@""];
					selName = [selName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
					selName = [selName stringByReplacingOccurrencesOfString:@"?" withString:@"_"];
					selName = [selName stringByReplacingOccurrencesOfString:@"!" withString:@"_"];
					selName = [selName stringByReplacingOccurrencesOfString:@"&" withString:@"_"];
					selName = [selName stringByAppendingString:@":"];

					SEL selector = NSSelectorFromString(selName);
					if ( [self respondsToSelector:selector] )
					{
						[self performSelector:selector withObject:req];
	//					[target performSelectorInBackground:action withObject:req];
						
						// TODO:
						req.state = BeeRequest.STATE_SUCCEED;
						[req callResponders];
					}
					
					[self posthandle:req];
				}
				
				return YES;
			}
		}
	}

	return NO;
}

- (void)rule:(NSString *)url
{
	[self rule:url action:nil target:self];
}

- (void)rule:(NSString *)url action:(SEL)action
{
	[self rule:url action:action target:self];
}

- (void)rule:(NSString *)url action:(SEL)action target:(id)target
{
	NSArray * array = [NSArray arrayWithObjects:url,
					   [NSNumber numberWithUnsignedInt:(NSUInteger)target],
					   [NSNumber numberWithUnsignedInt:(NSUInteger)action], nil];
	[_mapping addObject:array];
}

@end
