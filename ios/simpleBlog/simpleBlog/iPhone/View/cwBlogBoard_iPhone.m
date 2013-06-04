//
// Created by  王 岩 on 13-6-3.
// Copyright (c) 2013  王 岩. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "cwBlogBoard_iPhone.h"
#import "cwBlogsModel.h"
#import "cwViewCommon.h"

#import "../../../Pods/AttributedMarkdown/markdown_lib.h"
#import "../../../Pods/AttributedMarkdown/markdown_peg.h"


@interface  cwBlogBoard_iPhone()

@property (nonatomic, strong) BeeUITextView *markdownTextView;

- (NSMutableDictionary *) getMarkdownAttributes;

@end


@implementation cwBlogBoard_iPhone


- (void)load {
    [super load];
}

- (void)unload {
    SAFE_RELEASE( _blogObj );

    [super unload];
}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal {
    [super handleUISignal:signal];
    if ([signal is:[BeeUIBoard CREATE_VIEWS]])
    {
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.hintString = @"cwBlogBoard_iPhone";

        [self showNavigationBarAnimated:NO];

        _markdownTextView = [BeeUITextView new];
        _markdownTextView.editable = NO;
        _markdownTextView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_markdownTextView];
    }
    else if ([signal is:[BeeUIBoard DELETE_VIEWS] ])
    {
        SAFE_RELEASE_SUBVIEW( _markdownTextView )
    }
    else if ([signal is:[BeeUIBoard LOAD_DATAS]])
    {

        [self setTitle:_blogObj.title];
        NSMutableAttributedString * attr_out = markdown_to_attr_string(_blogObj.content, EXT_ALL, [cwViewCommon getMarkdownAttributes]);
        self.markdownTextView.attributedText = attr_out;

    }
    else if ([signal is:[BeeUIBoard FREE_DATAS]])
    {

    }
    else if ([signal is:[BeeUIBoard LAYOUT_VIEWS]] )
    {
        _markdownTextView.frame = self.view.bounds;
    }
}



@end