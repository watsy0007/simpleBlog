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
//  MenuBoard_iPhone.m
//  demo
//
//  Created by  王 岩 on 13-6-3.
//    Copyright (c) 2013年  王 岩. All rights reserved.
//

#import "AppBoard_iPhone.h"
#import "MenuBoard_iPhone.h"
#import "cwBlogsListBoard_iPhone.h"
#import "cwLoginBoard_iPhone.h"

#pragma mark -

@interface MenuBoard_iPhone()
{
    NSMutableArray *	_datas;
    BeeUIScrollView *	_scroll;
}
@end

#pragma mark -

@interface MenuCell_iPhone : BeeUIGridCell
{
    BeeUILabel *            _titleLabel;
}
        AS_SIGNAL( TAPPED )
@end

#pragma mark -

@implementation MenuCell_iPhone

DEF_SIGNAL( TAPPED )

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
    [super layoutInBound:bound forCell:cell];
    
    _titleLabel.frame = CGRectMake(0, 0, bound.width, bound.height);
}

- (void)load
{
    [super load];
    
    _titleLabel = [BeeUILabel new];
    _titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_titleLabel];
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    
    self.tappable = YES;
    self.tapSignal = MenuCell_iPhone.TAPPED;
}

- (void)unload
{
    SAFE_RELEASE_SUBVIEW( _titleLabel );
    [super unload];
}

- (void)dataDidChanged
{
    NSArray * array = self.cellData;
    if ( array )
    {
        NSString * title = [array objectAtIndex:0];
        NSString * clazz = [array objectAtIndex:1];

        self.hintString = title;
        self.hintColor = [UIColor darkGrayColor];
        _titleLabel.text = title;
    }
}

@end

#pragma mark -

@implementation MenuBoard_iPhone

DEF_SINGLETON( MenuBoard_iPhone )

- (void)load
{
    [super load];

    _datas = [[NSMutableArray alloc] init];
    [_datas addObject:@[@"Blogs",	@"cwBlogsListBoard_iPhone"]];
    [_datas addObject:@[@"Login",	@"cwLoginBoard_iPhone"]];
}

- (void)unload
{
    [_datas removeAllObjects];
    [_datas release];

    [super unload];
}

#pragma mark Signal

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        self.view.hintString = @"This is menu";
        self.view.backgroundColor = [UIColor darkGrayColor];

//		[self showNavigationBarAnimated:NO];
//		[self setTitleString:@"MenuBoard_iPhone"];
//      [self showBarButton:UINavigationBar.BARBUTTON_LEFT title:<#STRING#>];
//		[self showBarButton:UINavigationBar.BARBUTTON_RIGHT title:<#STRING#>];

        _scroll = [[BeeUIScrollView alloc] initWithFrame:CGRectZero];
        _scroll.dataSource = self;
        [self.view addSubview:_scroll];
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        _scroll.frame = CGRectToBound(self.view.frame);
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        [_scroll cancelReloadData];

        SAFE_RELEASE_SUBVIEW( _scroll );
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
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

- (void)handleUISignal_MenuCell_iPhone:(BeeUISignal *)signal
{
    [super handleUISignal:signal];

    MenuCell_iPhone * cell = signal.source;

    if ( [signal is:MenuCell_iPhone.TAPPED] )
    {
        NSString * title = [(NSArray *)cell.cellData objectAtIndex:0];
        NSString * clazz = [(NSArray *)cell.cellData objectAtIndex:1];

        [[AppBoard_iPhone sharedInstance] toggleBoard:NSClassFromString(clazz)];
    }
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
    return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    return _datas.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    NSArray * menuData = [_datas safeObjectAtIndex:index];
    if ( menuData )
    {
        NSString * title = [menuData objectAtIndex:0];
        NSString * clazz = [menuData objectAtIndex:1];

        MenuCell_iPhone * cell = [scrollView dequeueWithContentClass:[MenuCell_iPhone class]];
        cell.cellData = menuData;
        return cell;
    }

    return nil;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    return CGSizeMake( scrollView.width, 44.0f );
}

#pragma mark Notification

- (void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
}

#pragma mark Message

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
}

@end
