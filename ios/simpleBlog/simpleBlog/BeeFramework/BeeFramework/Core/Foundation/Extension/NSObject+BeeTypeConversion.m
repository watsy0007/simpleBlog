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
//  NSObject+BeeTicker.m
//

#import "Bee_Precompile.h"
#import "Bee_Singleton.h"
#import "NSObject+BeeTypeConversion.h"
#import "NSArray+BeeExtension.h"

#pragma mark -

@implementation NSObject(BeeTypeConversion)

- (BOOL)isNotKindOfClass:(Class)aClass
{
	return NO == [self isKindOfClass:aClass];
}

- (NSNumber *)asNSNumber
{
	if ( [self isKindOfClass:[NSNumber class]] )
	{
		return (NSNumber *)self;
	}
	else if ( [self isKindOfClass:[NSString class]] )
	{
		return [NSNumber numberWithInteger:[(NSString *)self integerValue]];
	}
	else if ( [self isKindOfClass:[NSDate class]] )
	{
		return [NSNumber numberWithDouble:[(NSDate *)self timeIntervalSince1970]];
	}
	else if ( [self isKindOfClass:[NSNull class]] )
	{
		return [NSNumber numberWithInteger:0];
	}

	return nil;
}

- (NSString *)asNSString
{
	if ( [self isKindOfClass:[NSString class]] )
	{
		return (NSString *)self;
	}
	else if ( [self isKindOfClass:[NSData class]] )
	{
		NSData * data = (NSData *)self;
		return [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
	}
	else
	{
		return [NSString stringWithFormat:@"%@", self];	
	}
}

- (NSDate *)asNSDate
{
	if ( [self isKindOfClass:[NSDate class]] )
	{
		return (NSDate *)self;
	}
	else if ( [self isKindOfClass:[NSString class]] )
	{
		NSTimeZone * local = [NSTimeZone localTimeZone];

		NSString * format = @"yyyy-MM-dd HH:mm:ss";
        if ([[self asNSString] length] < [format length])
        {
            format = @"yyyy-MM-dd";
        }
		NSString * text = [(NSString *)self substringToIndex:format.length];

		NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:format];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

		return [NSDate dateWithTimeInterval:(3600 + [local secondsFromGMT])
								  sinceDate:[dateFormatter dateFromString:text]];
	}
	else
	{
		return [NSDate dateWithTimeIntervalSince1970:[self asNSNumber].doubleValue];
	}
	
	return nil;	
}

- (NSArray *)asNSArray
{
	if ( [self isKindOfClass:[NSArray class]] )
	{
		return (NSArray *)self;
	}
	
	return nil;
}

- (NSArray *)asNSArrayWithClass:(Class)clazz
{
	if ( [self isKindOfClass:[NSArray class]] )
	{
		NSMutableArray * results = [NSMutableArray array];

		for ( NSObject * elem in (NSArray *)self )
		{
			if ( [elem isKindOfClass:[NSDictionary class]] )
			{
				NSObject * obj = [[self class] objectFromDictionary:elem];
				[results addObject:obj];
			}
		}
		
		return results;
	}

	return nil;
}

- (NSMutableArray *)asNSMutableArray
{
	if ( [self isKindOfClass:[NSMutableArray class]] )
	{
		return (NSMutableArray *)self;
	}
	
	return nil;
}

- (NSMutableArray *)asNSMutableArrayWithClass:(Class)clazz
{
	NSArray * array = [self asNSArrayWithClass:clazz];
	if ( nil == array )
		return nil;

	return [NSMutableArray arrayWithArray:array];
}

- (NSDictionary *)asNSDictionary
{
	if ( [self isKindOfClass:[NSDictionary class]] )
	{
		return (NSDictionary *)self;
	}

	return nil;
}

- (NSMutableDictionary *)asNSMutableDictionary
{
	if ( [self isKindOfClass:[NSMutableDictionary class]] )
	{
		return (NSMutableDictionary *)self;
	}
	
	NSDictionary * dict = [self asNSDictionary];
	if ( nil == dict )
		return nil;

	return [NSMutableDictionary dictionaryWithDictionary:dict];
}

@end
