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
//  cwBlogsListBoard_iPhone.h
//  simpleBlog
//
//  Created by  王 岩 on 13-6-3.
//  Copyright (c) 2013年  王 岩. All rights reserved.
//

#import "Bee.h"



@class cwBlogsModel;

#pragma mark -

@interface cwBlogListCell : BeeUIGridCell
{
    BeeUILabel *            _titleLabel;
}

@end

#pragma mark -

@interface cwBlogsListBoard_iPhone : BeeUIBoard
{
    BeeUIScrollView *	_scroll;

    cwBlogsModel *      _model;
}
@end
