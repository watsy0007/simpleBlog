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
//  AppBoard_iPhone.m
//  demo
//
//  Created by  王 岩 on 13-6-3.
//    Copyright (c) 2013年  王 岩. All rights reserved.
//

#import "AppBoard_iPhone.h"
#import "cwBlogsListBoard_iPhone.h"
#import "MenuBoard_iPhone.h"

#pragma mark -

#define kMenuWidth    240.0f
#define kDurationFast 0.35f
#define kDurationSlow 0.85f

#pragma mark -

@interface AppBoard_iPhone()
        AS_SIGNAL( MASK_TOUCHED )
@end

#pragma mark -

@implementation AppBoard_iPhone

DEF_SINGLETON( AppBoard_iPhone )

DEF_SIGNAL( MASK_TOUCHED )

@dynamic isMenuShown;

#pragma mark -

- (void)load
{
    [super load];
}

- (void)unload
{
    [super unload];
}

#pragma mark Signal

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [BeeUITipsCenter setDefaultContainerView:self.view];
        [BeeUITipsCenter setDefaultBubble:[UIImage imageNamed:@"alertBox.png"]];

        self.view.backgroundColor = [UIColor whiteColor];

        _menuStack = [[BeeUIStack stackWithFirstBoardClass:[MenuBoard_iPhone class]] retain];
        [self.view addSubview:_menuStack.view];

        _mainStackGroup = [[BeeUIStackGroup stackGroup] retain];
        _mainStackGroup.parentBoard = self;
        _mainStackGroup.view.layer.shadowColor = [UIColor blackColor].CGColor;
        _mainStackGroup.view.layer.shadowOpacity = 0.5f;
        _mainStackGroup.view.layer.shadowOffset = CGSizeMake(0, 0);
        _mainStackGroup.view.layer.shadowRadius = 5.0f;
        [self.view addSubview:_mainStackGroup.view];

        _mask = [[BeeUIButton alloc] init];
        _mask.hidden = YES;
        [_mask addSignal:self.MASK_TOUCHED forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_mask];

        [self toggleBoard:[cwBlogsListBoard_iPhone class]];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        [self unobserveAllNotifications];

        SAFE_RELEASE_SUBVIEW( _mask );
        SAFE_RELEASE( _menuStack );
        SAFE_RELEASE( _mainStackGroup );
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        CGRect menuStackFrame = self.viewBound;
        menuStackFrame.size.width = kMenuWidth;

        _menuStack.view.frame = menuStackFrame;
        _mainStackGroup.view.frame = self.viewBound;
        _mask.frame = _mainStackGroup.view.frame;
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
        _mainStackGroup.view.pannable = YES;
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
        _mainStackGroup.view.pannable = NO;
    }
    else if ( [signal is:BeeUIBoard.ORIENTATION_CHANGED] )
    {
    }
    else if ( [signal is:BeeUIBoard.ANIMATION_BEGIN] )
    {
    }
    else if ( [signal is:BeeUIBoard.ANIMATION_FINISH] )
    {
    }
    else if ( [signal is:BeeUIBoard.MODALVIEW_WILL_SHOW] )
    {
    }
    else if ( [signal is:BeeUIBoard.MODALVIEW_DID_SHOWN] )
    {
    }
    else if ( [signal is:BeeUIBoard.MODALVIEW_WILL_HIDE] )
    {
    }
    else if ( [signal is:BeeUIBoard.MODALVIEW_DID_HIDDEN] )
    {
    }
    else if ( [signal is:BeeUIBoard.POPOVER_WILL_PRESENT] )
    {
    }
    else if ( [signal is:BeeUIBoard.POPOVER_DID_PRESENT] )
    {
    }
    else if ( [signal is:BeeUIBoard.POPOVER_WILL_DISMISS] )
    {
    }
    else if ( [signal is:BeeUIBoard.POPOVER_DID_DISMISSED] )
    {
    }
}

- (void)handleUISignal_AppBoard_iPhone:(BeeUISignal *)signal
{
    [super handleUISignal:signal];

    if ( [signal is:AppBoard_iPhone.MASK_TOUCHED] )
    {
        [self toggleMenu];
    }
}

- (void)handleUISignal_UIView:(BeeUISignal *)signal
{
    [super handleUISignal:signal];

    if ( [signal is:UIView.PAN_START]  )
    {
        _mainStackGroupFrame = _mainStackGroup.view.frame;

        [self syncPanPosition];
    }
    else if ( [signal is:UIView.PAN_CHANGED]  )
    {
        [self syncPanPosition];
    }
    else if ( [signal is:UIView.PAN_STOP] || [signal is:UIView.PAN_CANCELLED] )
    {
        [self syncPanPosition];

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];

        CGFloat left = _mainStackGroup.view.left;
        if ( left <= (_mainStackGroup.view.width / 2.0f) )
        {
            _mainStackGroup.view.left = 0;
            self.isMenuShown = NO;
        }
        else if ( left > _mainStackGroup.view.width / 2.0f )
        {
            _mainStackGroup.view.left = kMenuWidth;
            self.isMenuShown = YES;
        }
        else
        {
            _mainStackGroup.view.frame = _mainStackGroupFrame;
        }

        [UIView commitAnimations];
    }
}

#pragma mark Message

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
}

#pragma mark Notification

- (void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
}

#pragma mark -

- (void)syncPanPosition
{
    if ( _mainStackGroup.view.left < 0 || ( _mainStackGroup.view.left == 0 && _mainStackGroup.view.panOffset.x < 0 ))
    {
        return;
    }
    else
    {
        _mainStackGroup.view.frame = CGRectOffset( _mainStackGroupFrame, _mainStackGroup.view.panOffset.x, 0 );
    }
}

- (void)toggleBoard:(Class)boardClass
{
    NSString * boardClassName = (NSString *)[NSString stringWithUTF8String:class_getName(boardClass)];
    if ( nil == boardClassName )
        return;

    BeeUIStack * stack = [_mainStackGroup reflect:boardClassName];
    if ( nil == stack )
    {
        stack = [BeeUIStack stack:boardClassName firstBoardClass:boardClass];

        CGRect stackFrame = self.view.frame;
        stackFrame.origin = CGPointZero;
        stack.view.frame = stackFrame;

        [_mainStackGroup append:stack];
    }

    [_mainStackGroup present:stack];

    if ( _isMenuShown )
    {
        [self toggleMenu];
    }
}

- (void)toggleMenu
{
    [UIView animateWithDuration:kDurationFast animations:^{
        _mainStackGroup.view.left = _isMenuShown ? 0 : kMenuWidth;
    } completion:^(BOOL finished) {
        _menuStack.view.width = _isMenuShown ? 320.0f : kMenuWidth;
        self.isMenuShown = !_isMenuShown;
    }];
}

- (BOOL)isMenuShown
{
    return _isMenuShown;
}

- (void)setIsMenuShown:(BOOL)isMenuShown
{
    _isMenuShown = isMenuShown;

    _mask.hidden = !_isMenuShown;
    _mask.frame = _mainStackGroup.view.frame;
}

@end
