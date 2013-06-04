//
// Created by  王 岩 on 13-6-3.
// Copyright (c) 2013  王 岩. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "cwLoginBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "lcBlogsController.h"
#import "lcLoginModel.h"

@interface cwLoginBoard_iPhone()

@property (nonatomic, strong) NSString *        sToken;

- (void) loginIn;

@end
@implementation cwLoginBoard_iPhone {

}

DEF_SIGNAL( BTN_LOGIN )

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal {
    if ([signal is:[BeeUIBoard CREATE_VIEWS]])
    {
        self.view.backgroundColor = [UIColor whiteColor];

        [self showNavigationBarAnimated:NO];
        [self showBarButton:UINavigationBar.BARBUTTON_LEFT title:@"Menu"];
        
        _nameField = [BeeUITextField new];
        _nameField.textAlignment = UITextAlignmentCenter;
        _nameField.textColor = [UIColor blackColor];
        _nameField.placeholder = @"user name";
        _nameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _nameField.layer.borderWidth = .5;

        _passField = [BeeUITextField new];
        _passField.textAlignment = UITextAlignmentCenter;
        _passField.textColor = [UIColor blackColor];
        _passField.placeholder = @"pass word";
        _passField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _passField.layer.borderWidth = .5;
        [self.view addSubview:_nameField];
        [self.view addSubview:_passField];

        _loginButton = [BeeUIButton new];
        _loginButton.title = @"Login";
        _loginButton.titleColor = [UIColor whiteColor];
        _loginButton.backgroundColor = [UIColor blackColor];
        [_loginButton addSignal:[[self class] BTN_LOGIN]
               forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginButton];
    }
    else if ([signal is:[BeeUIBoard DELETE_VIEWS]] )
    {
        SAFE_RELEASE_SUBVIEW( _nameField )
        SAFE_RELEASE_SUBVIEW( _passField )
        SAFE_RELEASE_SUBVIEW( _loginButton );
    }
    else if ([signal is:[BeeUIBoard LOAD_DATAS]] )
    {
    }
    else if ([signal is:[BeeUIBoard FREE_DATAS]] )
    {
        SAFE_RELEASE( _sToken );
    }
    else if ([signal is:[BeeUIBoard LAYOUT_VIEWS]] )
    {
        _nameField.frame = CGRectMake(30, 30, self.viewWidth - 30 * 2, 30);
        _passField.frame = CGRectOffset(_nameField.frame, 0, 30 + 15);
        _loginButton.frame = CGRectOffset(_passField.frame, 0, 30 + 15);
    }
}

- (void)handleUISignal_UINavigationBar:(BeeUISignal *)signal
{
    if ([signal is:[UINavigationBar BARBUTTON_LEFT_TOUCHED]] )
    {
        [[AppBoard_iPhone sharedInstance] toggleMenu];
    }
}

- (void) handleUISignal_cwLoginBoard_iPhone:(BeeUISignal *)signal
{
    if ([signal is:[self BTN_LOGIN]])
    {
        [self loginIn];
    }
}


- (void)handleMessage_lcBlogsController:(BeeMessage *)msg {
    if ([msg is:lcBlogsController.REMOTE])
    {
        NSString *action = msg.input[@"action"];
         if (msg.sending)
         {

         }
        else if (msg.succeed)
         {
             if ([action is:@"login"])
             {
                 [[lcLoginModel sharedInstance] loadFromDictionary:msg.output[@"response"]];
             }
         }
        else if (msg.failed)
         {}
        else if (msg.cancelled)
         {

         }
    }
}


- (void) loginIn
{
    [[self sendMessage:[lcBlogsController REMOTE]] input:

        @"action" ,    @"login",
        @"name" ,      _nameField.text,
        @"pass" ,      _passField.text,
                    nil
    ];
}

@end