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
//  NSObject+BeeJSON.m
//

#import "Bee_Precompile.h"
#import "Bee_Runtime.h"
#import "NSObject+BeeJSON.h"
#import "NSObject+BeeTypeConversion.h"
#import "NSDictionary+BeeExtension.h"
#import "JSONKit.h"
#include <objc/runtime.h>

#pragma mark -

@implementation NSObject(BeeJSON)

- (id)objectZerolize
{
	NSUInteger			propertyCount = 0;
	objc_property_t *	properties = class_copyPropertyList( [self class], &propertyCount );
	
	for ( NSUInteger i = 0; i < propertyCount; i++ )
	{
		const char *	name = property_getName(properties[i]);
		const char *	attr = property_getAttributes(properties[i]);
		
		NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
		NSUInteger		propertyType = [BeeTypeEncoding typeOfAttribute:attr];

		if ( BeeTypeEncoding.NSNUMBER == propertyType )
		{
			[self setValue:[NSNumber numberWithInt:0] forKey:propertyName];
		}
		else if ( BeeTypeEncoding.NSSTRING == propertyType )
		{
			[self setValue:@"" forKey:propertyName];
		}
		else if ( BeeTypeEncoding.NSARRAY == propertyType )
		{
			[self setValue:[NSMutableArray array] forKey:propertyName];
		}
		else if ( BeeTypeEncoding.NSDICTIONARY == propertyType )
		{
			[self setValue:[NSMutableDictionary dictionary] forKey:propertyName];
		}
		else if ( BeeTypeEncoding.NSDATE == propertyType )
		{
			[self setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:propertyName];
		}
		else if ( BeeTypeEncoding.OBJECT == propertyType )
		{
			Class clazz = [BeeTypeEncoding classOfAttribute:attr];
			if ( clazz )
			{
				NSObject * newObj = [[[clazz alloc] init] autorelease];
				[self setValue:newObj forKey:propertyName];
			}
			else
			{
				[self setValue:nil forKey:propertyName];
			}
		}
		else
		{
			[self setValue:nil forKey:propertyName];
		}
	}
	
	free( properties );

	return self;
}

+ (id)objectFromDictionary:(id)dict
{
	if ( nil == dict )
	{
		return nil;
	}
		
	if ( NO == [dict isKindOfClass:[NSDictionary class]] )
	{
		return nil;
	}
	
	return [(NSDictionary *)dict objectForClass:[self class]];
}

- (id)objectToDictionary
{
	NSMutableDictionary * result = [NSMutableDictionary dictionary];
	
	if ( [self isKindOfClass:[NSDictionary class]] )
	{
		NSDictionary * dict = (NSDictionary *)self;

		for ( NSString * key in dict.allKeys )
		{
			NSObject * obj = [dict objectForKey:key];
			if ( obj )
			{
				NSUInteger propertyType = [BeeTypeEncoding typeOfObject:obj];
				if ( BeeTypeEncoding.NSNUMBER == propertyType )
				{
					[result setObject:obj forKey:key];
				}
				else if ( BeeTypeEncoding.NSSTRING == propertyType )
				{
					[result setObject:obj forKey:key];
				}
				else if ( BeeTypeEncoding.NSARRAY == propertyType )
				{
					NSMutableArray * array = [NSMutableArray array];
					
					for ( NSObject * elem in (NSArray *)obj )
					{
						[array addObject:[elem objectToDictionary]];
					}
					
					[result setObject:array forKey:key];
				}
				else if ( BeeTypeEncoding.NSDICTIONARY == propertyType )
				{
					NSMutableDictionary * dict = [NSMutableDictionary dictionary];
					
					for ( NSString * key in ((NSDictionary *)obj).allKeys )
					{
						NSObject * val = [(NSDictionary *)obj objectForKey:key];
						[dict setObject:[val objectToDictionary] forKey:key];
					}
					
					[result setObject:dict forKey:key];
				}
				else if ( BeeTypeEncoding.NSDATE == propertyType )
				{
					[result setObject:[obj description] forKey:key];
				}
				else
				{
					obj = [obj objectToDictionary];
					if ( obj )
					{
						[result setObject:obj forKey:key];
					}
					else
					{
						[result setObject:[NSDictionary dictionary] forKey:key];
					}
				}
			}
			else
			{
				[result setObject:[NSNull null] forKey:key];
			}
		}
	}
	else
	{
		NSUInteger			propertyCount = 0;
		objc_property_t *	properties = class_copyPropertyList( [self class], &propertyCount );
		
		for ( NSUInteger i = 0; i < propertyCount; i++ )
		{
			const char *	name = property_getName(properties[i]);
			const char *	attr = property_getAttributes(properties[i]);
			
			NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			NSUInteger		propertyType = [BeeTypeEncoding typeOf:attr];
			
			NSObject * obj = [self valueForKey:propertyName];
			if ( obj )
			{
				if ( BeeTypeEncoding.NSNUMBER == propertyType )
				{
					[result setObject:obj forKey:propertyName];
				}
				else if ( BeeTypeEncoding.NSSTRING == propertyType )
				{
					[result setObject:obj forKey:propertyName];
				}
				else if ( BeeTypeEncoding.NSARRAY == propertyType )
				{
					NSMutableArray * array = [NSMutableArray array];
					
					for ( NSObject * elem in (NSArray *)obj )
					{
						[array addObject:[elem objectToDictionary]];
					}
					
					[result setObject:array forKey:propertyName];
				}
				else if ( BeeTypeEncoding.NSDICTIONARY == propertyType )
				{
					NSMutableDictionary * dict = [NSMutableDictionary dictionary];
					
					for ( NSString * key in ((NSDictionary *)obj).allKeys )
					{
						NSObject * val = [(NSDictionary *)obj objectForKey:key];
						[dict setObject:[val objectToDictionary] forKey:key];
					}
					
					[result setObject:dict forKey:propertyName];
				}
				else if ( BeeTypeEncoding.NSDATE == propertyType )
				{
					[result setObject:[obj description] forKey:propertyName];
				}
				else
				{
					obj = [obj objectToDictionary];
					if ( obj )
					{
						[result setObject:obj forKey:propertyName];
					}
					else
					{
						[result setObject:[NSDictionary dictionary] forKey:propertyName];
					}
				}
			}
			else
			{
				[result setObject:[NSNull null] forKey:propertyName];
			}
		}
		
		free( properties );
	}
	
	return result;
}

+ (id)objectFromString:(id)str
{
	if ( nil == str )
	{
		return nil;
	}
	
	if ( NO == [str isKindOfClass:[NSString class]] )
	{
		return nil;
	}
	
	NSObject * obj = [(NSString *)str objectFromJSONString];
	if ( obj && [obj isKindOfClass:[NSDictionary class]] )
	{
		return [(NSDictionary *)obj objectForClass:[self class]];
	}

	return nil;
}

- (id)objectToString
{
	// TODO:
	return nil;
}

- (id)objectToJSONObject
{
	NSUInteger type = [BeeTypeEncoding typeOfObject:self];
	
	if ( BeeTypeEncoding.NSNUMBER == type )
	{
		return self;
	}
	else if ( BeeTypeEncoding.NSSTRING == type )
	{
		return self;
	}
	else if ( BeeTypeEncoding.NSDATE == type )
	{
		return self;
	}
	else if ( BeeTypeEncoding.NSARRAY == type )
	{
		NSMutableArray * result = [NSMutableArray array];
		for ( NSObject * elem in (NSArray *)self )
		{
			NSObject * newObj = [elem objectToJSONObject];
			if ( newObj )
			{
				[result addObject:newObj];
			}
		}
		return result;
	}
	else if ( BeeTypeEncoding.NSDICTIONARY == type )
	{
		NSMutableDictionary * result = [NSMutableDictionary dictionary];
		for ( NSString * key in ((NSDictionary *)self).allKeys )
		{
			NSObject * newObj = [[(NSDictionary *)self objectForKey:key] objectToJSONObject];
			if ( newObj )
			{
				[result setObject:newObj forKey:key];
			}
		}
		return result;
	}
	else if ( BeeTypeEncoding.OBJECT == type )
	{
		return [self objectToDictionary];
	}

	return nil;
}

- (id)objectToJSONData
{
	NSDictionary *	dict = [self objectToJSONObject];
	NSData *		json = [dict JSONData];
	
	return [NSMutableData dataWithData:json];
}

- (id)objectToJSONString
{
	NSDictionary *	dict = [self objectToJSONObject];
	NSString *		json = [dict JSONString];
	
	return [NSMutableString stringWithString:json];
}

@end
