//
// Created by  王 岩 on 13-6-4.
// Copyright (c) 2013  王 岩. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface lcLoginObject : BeeModel

@property (nonatomic, strong) NSString *            token;
@property (nonatomic, strong) NSNumber *            userid;

@end

@interface lcLoginModel : BeeModel

AS_SINGLETON( lcLoginModel )

@property (nonatomic, strong) NSNumber *            status;
@property (nonatomic, strong) NSNumber *            errcode;
@property (nonatomic, strong) lcLoginObject *       userObj;

- (void) loadFromDictionary:(NSDictionary *) dict;

@end