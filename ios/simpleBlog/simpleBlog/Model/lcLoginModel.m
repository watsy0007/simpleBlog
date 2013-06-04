//
// Created by  王 岩 on 13-6-4.
// Copyright (c) 2013  王 岩. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "lcLoginModel.h"

@implementation lcLoginObject

- (void)unload
{
    [_token release];
    [_userid release];
    [super unload];
}

@end


@implementation lcLoginModel {

}

DEF_SINGLETON( lcLoginModel )

- (void)unload {
    [_status release];
    [_errcode release];
    [super unload];
}

- (void) loadFromDictionary:(NSDictionary *) dict
{
    self.userObj = [lcLoginObject objectFromDictionary:dict[@"userObj"]];
    self.status = dict[@"status"];
    self.errcode = dict[@"errcode"];
}

@end