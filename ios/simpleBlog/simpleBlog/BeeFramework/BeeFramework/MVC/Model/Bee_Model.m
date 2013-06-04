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
//  Bee_Model.h
//

#import "Bee_Precompile.h"
#import "Bee_Model.h"
#import "Bee_Controller.h"
#import "Bee_Network.h"
#import "NSArray+BeeExtension.h"
#import "NSObject+BeeMessage.h"

#import "JSONKit.h"

#pragma mark -

@implementation BeeModel

@synthesize name = _name;
@synthesize observers = _observers;

static NSMutableArray *	__models = nil;

+ (void)load
{
	if ( nil == __models )
	{
		__models = [[NSMutableArray nonRetainingArray] retain];
	}
}

+ (id)model
{
	return [[[[self class] alloc] init] autorelease];
}

+ (NSMutableArray *)models
{
	return __models;
}

+ (NSMutableArray *)modelByClass:(Class)clazz
{
	if ( 0 == __models.count )
		return nil;

	NSMutableArray * array = [NSMutableArray array];
	
	for ( BeeModel * model in __models )
	{
		if ( [model isKindOfClass:clazz] )
		{
			[array addObject:model];
		}
	}
	
	return array;
}

+ (NSMutableArray *)modelByName:(NSString *)name
{
	if ( 0 == __models.count )
		return nil;

	NSMutableArray * array = [NSMutableArray array];
	
	for ( BeeModel * model in __models )
	{
		if ( [model.name isEqualToString:name] )
		{
			[array addObject:model];
		}
	}

	return array;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		[__models addObject:self];

		[self initSelf];
		[self load];
	}
	return self;
}

- (void)initSelf
{
	_name = [[[self class] description] retain];
	_observers = [[NSMutableArray alloc] init];	
}

- (void)load
{
	if ( [self respondsToSelector:@selector(unserialize)] )
	{
		[self unserialize];
	}
}

- (void)unload
{
	if ( [self respondsToSelector:@selector(serialize)] )
	{
		[self serialize];
	}
}

- (void)serialize
{	
}

- (void)unserialize
{
}

- (void)addObserver:(id)obj
{
	if ( NO == [_observers containsObject:obj] )
	{
		[_observers addObject:obj];
	}
}

- (void)removeObserver:(id)obj
{
	if ( [_observers containsObject:obj] )
	{
		[_observers removeObject:obj];
	}
}

- (void)dealloc
{
	[self unload];
	[self cancelMessages];
	[self cancelRequests];

	[_observers removeAllObjects];
	[_observers release];
	[_name release];

	[__models removeObject:self];
	
	[super dealloc];
}

- (void)posthandleMessage:(BeeMessage *)msg
{
	// forward all messages to observers

	for ( NSObject * obj in _observers )
	{
		[msg forwardResponder:obj];
	}
}

- (void)posthandleRequest:(BeeRequest *)request
{
	// forward all requests to observers

	for ( NSObject * obj in _observers )
	{
		[request forwardResponder:obj];
	}
}

@end
