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
//  AppBoard_iPhone.h
//  simpleBlog
//
//  Created by  王 岩 on 13-6-2.
//    Copyright (c) 2013年  王 岩. All rights reserved.
//

#import "Bee.h"

@interface AppBoard_iPhone : BeeUIBoard
{
    CGRect              _mainStackGroupFrame;
    BeeUIStack *		_menuStack;
    BeeUIStackGroup *	_mainStackGroup;
    BeeUIButton *		_mask;
    BOOL				_isMenuShown;
}

AS_SINGLETON( AppBoard_iPhone )

@property (nonatomic, assign) BOOL isMenuShown;

- (void)toggleBoard:(Class)boardClass;
- (void)toggleMenu;

@end

