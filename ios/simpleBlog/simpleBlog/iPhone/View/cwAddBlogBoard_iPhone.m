//
// Created by  王 岩 on 13-6-3.
// Copyright (c) 2013  王 岩. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "cwAddBlogBoard_iPhone.h"
#import "lcBlogsController.h"


@implementation cwAddBlogBoard_iPhone {

}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal {

    if ([signal is:[BeeUIBoard CREATE_VIEWS]])
    {
         self.view.backgroundColor = [UIColor whiteColor];

        _titleField = [BeeUITextField new];
        _titleField.placeholder = @"title";
        [self.view addSubview:_titleField];
        _titleField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _titleField.layer.borderWidth = 0.5;

        _contentView = [BeeUITextView new];
        _contentView.placeholder = @"content";
        _contentView.layer.borderWidth = 0.5;
        _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.view addSubview:_contentView];

        [self showBarButton:UINavigationBar.BARBUTTON_RIGHT title:@"Done"];


    }
    else if ([signal is:[BeeUIBoard DELETE_VIEWS]] )
    {
        SAFE_RELEASE_SUBVIEW( _titleField )
        SAFE_RELEASE_SUBVIEW( _contentView )
    }
    else if ([signal is:[BeeUIBoard LOAD_DATAS]] )
    {

    }
    else if ([signal is:[BeeUIBoard FREE_DATAS]] )
    {}
    else if ([signal is:[BeeUIBoard LAYOUT_VIEWS]])
    {
        _titleField.frame = CGRectMake(15, 15, self.viewWidth - 30, 30);
        _contentView.frame = CGRectMake(15, CGRectGetMaxY(_titleField.frame) + 15,
                _titleField.width, self.viewHeight - 216 - CGRectGetMaxY(_titleField.frame) - 15);
        [_titleField becomeFirstResponder];
    }

}

- (void)handleUISignal_UINavigationBar:(BeeUISignal *)signal {
    if ([signal is:[UINavigationBar BARBUTTON_RIGHT_TOUCHED]])
    {
        if ([_titleField.text empty])
        {
            [self presentFailureTips:@"title can't be nil"];
            return;
        }
        else if ([_contentView.text empty])
        {
            [self presentFailureTips:@"content can't be nil"];
            return;
        }


        [[self sendMessage:[lcBlogsController REMOTE]] input:
                @"action" ,  @"addblog",
                @"title" ,   _titleField.text,
                @"content" , _contentView.text ,
                nil
        ];
    }
}

- (void)handleMessage_lcBlogsController:(BeeMessage *)msg {
    if ([msg is:[lcBlogsController REMOTE]])
    {
        if (msg.sending)
        {

        }
        else if (msg.succeed)
        {
            NSDictionary * dict = msg.output[@"response"];
            if ( [dict[@"status"] intValue] == 1 )
            {
                [self presentSuccessTips:@"add blog ok"];
            }
            else
            {
                [self presentFailureTips:@"add blog failed"];
            }
        }
        else if (msg.failed)
        {

        }
        else if (msg.cancelled)
        {}

    }
}

@end