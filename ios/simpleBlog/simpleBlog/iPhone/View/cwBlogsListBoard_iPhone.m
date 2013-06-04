//
//   ______    ______    ______    
//  /\  __ \  /\  ___\  /\  ___\   
//  \ \  __<  \ \  __\_ \ \  __\_ 
//   \ \_____\ \ \_____\ \ \_____\ 
//    \/_____/  \/_____/  \/_____/ 
//
//  Powered by BeeFramework
//
//
//  cwBlogsListBoard_iPhone.m
//  simpleBlog
//
//  Created by  王 岩 on 13-6-3.
//  Copyright (c) 2013年  王 岩. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "cwBlogsListBoard_iPhone.h"
#import "cwBlogsModel.h"
#import "cwBlogBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "cwAddBlogBoard_iPhone.h"
#import "lcLoginModel.h"
#import "lcBlogsController.h"


#pragma mark -

@implementation cwBlogListCell

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
    cwBlogsObject * obj = (cwBlogsObject *)data;

    CGSize size = [obj.title sizeWithFont:[UIFont systemFontOfSize:12] byWidth:bound.width - 10];

    return CGSizeMake(bound.width, size.height + 25);
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
    _titleLabel.frame = CGRectMake(5, 0, bound.width - 10, bound.height);
}

- (void)load {
    [super load];

    _titleLabel = [BeeUILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_titleLabel];
}

- (void)unload {

    SAFE_RELEASE_SUBVIEW( _titleLabel )

    [super unload];
}

- (void)dataDidChanged {
    if (self.cellData)
    {
        cwBlogsObject *obj = (cwBlogsObject *)self.cellData;
        _titleLabel.text = obj.title;
    }
}


@end

#pragma mark -

@interface cwBlogsListBoard_iPhone()

@property (nonatomic, strong) BeeUILoadingTipsView *    loadingTipsView;

- (void) loadBlogs:(BOOL) bReload;

@end

@implementation cwBlogsListBoard_iPhone

- (void)load
{
	[super load];
    
    _model = [cwBlogsModel new];

    [self observeNotification:[cwBlogsModel DATA_RELOAD]];
}

- (void)unload
{
    [self unobserveNotification:[cwBlogsModel DATA_RELOAD]];

    SAFE_RELEASE( _loadingTipsView );

    SAFE_RELEASE( _model );
    
	[super unload];
}

#pragma mark Signal

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.hintString = @"cwBlogsListBoard_iPhone";

        [self showNavigationBarAnimated:NO];
        [self setTitleString:@"simple Blog"];
        [self showBarButton:UINavigationBar.BARBUTTON_LEFT title:@"Menu"];
        [self showBarButton:UINavigationBar.BARBUTTON_RIGHT title:@"Add"];

        _scroll = [[BeeUIScrollView alloc] initWithFrame:CGRectZero];
        _scroll.dataSource = self;
        [self.view addSubview:_scroll];
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        _scroll.frame = self.viewBound;
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        [_scroll cancelReloadData];
        [self cancelRequests];
        [self cancelMessages];
        

        SAFE_RELEASE_SUBVIEW( _scroll );
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [self loadBlogs:YES];
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
}

- (void)handleUISignal_UINavigationBar:(BeeUISignal *)signal
{
    if ([signal is:[UINavigationBar BARBUTTON_RIGHT_TOUCHED]])
    {
        if ([[lcLoginModel sharedInstance] userObj] &&
                [[[lcLoginModel sharedInstance] userObj] userid])
        {
            cwAddBlogBoard_iPhone *addBoard = [cwAddBlogBoard_iPhone new];
            [self.stack pushBoard:addBoard animated:YES];
            [addBoard release];

        }
        else
        {
            [self presentFailureTips:@"please login first"];
        }
    }
    else if ([signal is:[UINavigationBar BARBUTTON_LEFT_TOUCHED]] )
    {
            [[AppBoard_iPhone sharedInstance] toggleMenu];
    }
}

- (void)handleUISignal_UIView:(BeeUISignal *)signal
{
    if ([signal.source isKindOfClass:[cwBlogListCell class]])
    {
        cwBlogListCell *cell = (cwBlogListCell *)signal.source;

        cwBlogBoard_iPhone *blogBoard = [cwBlogBoard_iPhone new];

        blogBoard.blogObj = [_model objectAtIndex:cell.tag];

        [self.stack pushBoard:blogBoard animated:YES];

        [blogBoard release];
    }
}

- (void)handleUISignal_cwBlogsListBoard_iPhone:(BeeUISignal *)signal
{
 
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
    return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    return [_model count];
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    cwBlogListCell * cell = [scrollView dequeueWithContentClass:[cwBlogListCell class]];
    cell.cellData = [_model objectAtIndex:index];
    [cell setTapEnabled:YES];
    cell.tag = index;
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    CGSize size = CGSizeMake( scrollView.width, 44.0f );

    return [cwBlogListCell sizeInBound:size forData:[_model objectAtIndex:index]];
}

#pragma mark Notification


- (void)handleNotification_cwBlogsModel:(NSNotification *)notification
{
    if ( [notification is:cwBlogsModel.DATA_RELOAD] )
    {
        [self.loadingTipsView dismiss];

        [_scroll reloadData];
    }
}

#pragma mark Message

- (void)handleMessage_lcBlogsController:(BeeMessage *)msg
{
    if (msg.sending)
    {
        self.loadingTipsView = (BeeUILoadingTipsView *)[self presentLoadingTips:@"loading..."];
        _loadingTipsView.timerSeconds = 9999;
    } else if (msg.succeed)
    {
        NSArray *array = msg.output[@"response"];
        [_model loadObjectsWithArray:array];
    }
    else if (msg.failed)
    {}
    else if (msg.cancelled)
    {}
}

#pragma mark - private method
- (void) loadBlogs:(BOOL) bReload
{
    if (bReload)
    {
        [_model reset];
    }

    [[self sendMessage:[lcBlogsController REMOTE]] input:
            @"action" ,     @"blogs",
            @"page",        __INT( [_model page] ),
            nil
    ];
}

@end
