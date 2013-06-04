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
//  Bee_UITemplate.m
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_Precompile.h"
#import "Bee_Log.h"
#import "Bee_UITemplate.h"

#import "UIView+BeeExtension.h"

#import "TouchXML.h"

#import "Bee_UITemplateAndroid.h"
#import "Bee_UITemplateHTML.h"
#import "Bee_UITemplateJSON.h"
#import "Bee_UITemplateOmniGraffle.h"
#import "Bee_UITemplateXML.h"

#import <objc/runtime.h>

#pragma mark -

@implementation BeeUITemplate

@synthesize name = _name;
@synthesize rootLayout = _rootLayout;
@synthesize rootStyles = _rootStyles;

static NSMutableDictionary * __templateClasses = nil;
static NSMutableDictionary * __templateCache = nil;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.name = nil;
		self.rootLayout = nil;
		self.rootStyles = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	self.name = nil;
	self.rootLayout = nil;
	self.rootStyles = nil;

	[super dealloc];
}

+ (BeeUITemplate *)templateForType:(NSString *)type
{
	if ( nil == __templateClasses )
	{
		[self registerTemplateClass:[BeeUITemplateXML class] forType:@"xml"];
		[self registerTemplateClass:[BeeUITemplateHTML class] forType:@"html"];
		[self registerTemplateClass:[BeeUITemplateHTML class] forType:@"htm"];
		[self registerTemplateClass:[BeeUITemplateJSON class] forType:@"json"];
		[self registerTemplateClass:[BeeUITemplateOmniGraffle class] forType:@"omni"];
	}
	
	BeeUITemplate * template = nil;
	
	for ( NSString * key in __templateClasses.allKeys )
	{
		if ( NSOrderedSame != [key compare:type options:NSCaseInsensitiveSearch] )
			continue;
		
		NSString * className = [__templateClasses objectForKey:key.lowercaseString];
		if ( className )
		{
			Class classType = NSClassFromString( className );
			if ( classType )
			{
				template = [[classType alloc] init];
				break;
			}
		}
	}
	
	return template;
}

+ (void)registerTemplateClass:(Class)clazz forType:(NSString *)type
{
	if ( nil == __templateClasses )
	{
		__templateClasses = [[NSMutableDictionary alloc] init];
	}
	
	NSString * className = [NSString stringWithUTF8String:class_getName(clazz)];
	if ( className )
	{
		[__templateClasses setObject:className forKey:type.lowercaseString];
	}
}

+ (void)unregisterTemplateClassForType:(NSString *)type
{
	[__templateClasses removeObjectForKey:type.lowercaseString];
}

+ (BeeUITemplate *)fromResource:(NSString *)resName
{
	CC( @"template load, %@", resName );
	
	if ( nil == __templateCache )
	{
		__templateCache = [[NSMutableDictionary alloc] init];
	}

	BeeUITemplate *	template = [__templateCache objectForKey:resName];
	if ( template )
		return template;
	
	NSString *	extension = [resName pathExtension];
	NSString *	fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
	NSString *	resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
	NSData *	data = nil;
	
	data = [NSData dataWithContentsOfFile:resPath];
	if ( nil == data || 0 == data.length )
		return nil;

	template = [BeeUITemplate templateForType:extension];
	if ( nil == template )
		return nil;
	
	[template parse:data];

	[__templateCache setObject:template forKey:resName];
	return template;
}

+ (BeeUITemplate *)fromFile:(NSString *)fileName
{
	CC( @"template load, %@", fileName );
	
	// TODO:
	return nil;
}

+ (BeeUITemplate *)preloadResource:(NSString *)resName
{
	CC( @"template preload, %@", resName );
	
	if ( nil == __templateCache )
	{
		__templateCache = [[NSMutableDictionary alloc] init];
	}

	BeeUITemplate *	template = [__templateCache objectForKey:resName];
	if ( nil == template )
	{
		template = [BeeUITemplate fromResource:resName];
		if ( template && template.name )
		{
			[__templateCache setObject:template forKey:resName];
		}
	}
	
	return template;
}

+ (BeeUITemplate *)preloadFile:(NSString *)fileName
{
	CC( @"template preload, %@", fileName );
	
	// TODO:

	return nil;
}

+ (void)clearCache
{
	[__templateCache removeAllObjects];
}

- (BOOL)parse:(NSData *)data
{
	return NO;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
