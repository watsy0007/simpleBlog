//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  cwBlogsModel.m
//  simpleBlog
//
//  Created by  王 岩 on 13-6-3.
//    Copyright (c) 2013年  王 岩. All rights reserved.
//

#import "cwBlogsModel.h"

#pragma mark -

@implementation cwBlogsObject

- (void) unload
{
    SAFE_RELEASE( _created_date )
    SAFE_RELEASE( _title )
    SAFE_RELEASE( _visitCount )
    SAFE_RELEASE( _content )
    SAFE_RELEASE( _pk)
    
    [super unload];
}

@end

@implementation cwBlogsModel

DEF_NOTIFICATION( DATA_RELOAD )

- (void) load
{
    [super load];
    _blogs = [NSMutableArray new];
}

- (void) unload
{

    SAFE_RELEASE( _blogs )
    
    [super unload];
}

- (void) loadObjectsWithArray:(NSArray *) array
{
    for (NSDictionary * dict in array)
    {
        NSDictionary *objDict = dict[@"fields"];
        cwBlogsObject *blogObj = (cwBlogsObject *)[cwBlogsObject objectFromDictionary:objDict];
        blogObj.pk = dict[@"pk"];
        [_blogs addObject:blogObj];
    }

    [_blogs sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        cwBlogsObject *blog1 = (cwBlogsObject *)obj1;
        cwBlogsObject *blog2 = (cwBlogsObject *)obj2;

        return [blog1.created_date compare:blog2.created_date];
    }];


    [self postNotification:[[self class] DATA_RELOAD]];
}


- (void) reset
{
    [_blogs removeAllObjects];
}

- (NSInteger) count
{
    return [_blogs count];
}
- (NSInteger) page
{
    return [_blogs count] / 10 + 1;
}
- (cwBlogsObject *) objectAtIndex:(NSInteger) nIndex
{
    if (nIndex >= 0 && nIndex < [_blogs count])
    {
        return [_blogs objectAtIndex:nIndex];
    }
    return nil;
}

@end
