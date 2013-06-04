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
//  lcBlogsController.m
//  simpleBlog
//
//  Created by  王 岩 on 13-6-3.
//    Copyright (c) 2013年  王 岩. All rights reserved.
//

#import "lcBlogsController.h"
#import "lcLoginModel.h"

#pragma mark -

@implementation lcBlogsController

DEF_MESSAGE( REMOTE )



- (void)REMOTE:(BeeMessage *)msg
{
    NSString *sAction = [msg.input objectForKey:@"action"];
    if ( msg.sending )
	{
        if ([sAction is:@"blogs"])
        {
            msg.HTTP_POST( @"http://127.0.0.1:8000/api/blogs" )
            .PARAM(@"page",    @"1");
        }
        else if ([sAction is:@"login"])
        {
            NSString *name = msg.input[@"name"];
            NSString *pass = msg.input[@"pass"];

            msg.HTTP_POST ( @"http://127.0.0.1:8000/api/login" )
                    .PARAM( @"username" , name )
                    .PARAM( @"password", pass );
        }
        else if ([sAction is:@"addblog"] )
        {
            NSString * sTitle = msg.input[@"title"];
            NSString * sContent = msg.input[@"content"];

            msg.HTTP_POST ( @"http://127.0.0.1:8000/api/addblog" )

                    .PARAM ( @"title" ,     sTitle )
                    .PARAM ( @"content" ,   sContent)

                    .PARAM ( @"device" , @"iphone")
                    .PARAM ( @"userid" , [[lcLoginModel sharedInstance].userObj.userid stringValue])
                    .PARAM ( @"token" , [lcLoginModel sharedInstance].userObj.token);
        }

	}
	else if ( msg.succeed )
	{
        if ([sAction is:@"blogs"])
        {
            [msg.output setObject:msg.responseJSONArray forKey:@"response"];
        }

        else if ([sAction is:@"login"] )
        {
            CC(@"login return data : %@", msg.responseString);
            CC(@" dict : %@", msg.responseJSON);
            msg.output[@"response"] = msg.responseJSON;
        }

        else if ([sAction is:@"addblog"] )
        {
            CC(@"addblog return data : %@", msg.responseString);
            msg.output[@"response"] = msg.responseJSON;
        }
    
	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}

@end
