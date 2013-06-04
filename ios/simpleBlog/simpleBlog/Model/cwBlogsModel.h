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
//  cwBlogsModel.h
//  simpleBlog
//
//  Created by  王 岩 on 13-6-3.
//    Copyright (c) 2013年  王 岩. All rights reserved.
//

#import "Bee_Model.h"

#pragma mark -

@interface cwBlogsObject : BeeModel

@property (nonatomic, strong) NSDate *      created_date;
@property (nonatomic, strong) NSString *    title;
@property (nonatomic, strong) NSNumber *    visitCount;
@property (nonatomic, strong) NSString *    content;

//外部获取
@property (nonatomic, strong) NSString *    pk;

@end

@interface cwBlogsModel : BeeModel
{
    NSMutableArray *        _blogs;
}

AS_NOTIFICATION( DATA_RELOAD )

- (void) loadObjectsWithArray:(NSArray *) array;

- (void) reset;
- (NSInteger) count;
- (NSInteger) page;
- (cwBlogsObject *) objectAtIndex:(NSInteger) nIndex;

@end
