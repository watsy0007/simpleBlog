//
//  cwConnMethod.h
//  simpleBlog
//
//  Created by  王 岩 on 13-6-3.
//  Copyright (c) 2013年  王 岩. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBaseURL                @"http://127.0.0.1:8000/api"

#define kGetAPIUrl(action)      [NSString stringWithFormat:@"%@/%@", kBaseURL, action]



@interface cwConnCenter : NSObject


@end
