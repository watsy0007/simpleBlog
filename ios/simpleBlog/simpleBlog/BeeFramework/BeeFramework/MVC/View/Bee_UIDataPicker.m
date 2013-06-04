//
//  Bee_UIDataPicker.m
//  lciMyBags
//
//  Created by  王 岩 on 13-5-15.
//  Copyright (c) 2013年  王 岩. All rights reserved.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_UIDataPicker.h"
#import "Bee_Precompile.h"
#import "Bee_UISignal.h"
#import "UIView+BeeExtension.h"
#import "UIView+BeeUISignal.h"

@interface BeeUIDataPicker()

- (void) initSelf;

@end

@implementation BeeUIDataPicker

DEF_SIGNAL( WILL_PRESENT )
DEF_SIGNAL( DID_PRESENT )
DEF_SIGNAL( WILL_DISMISS )
DEF_SIGNAL( DID_DISMISS )
DEF_SIGNAL( CHANGED )
DEF_SIGNAL( CONFIRMED )


#pragma mark - super method
- (id) init
{
    if (self = [super init])
    {
        [self initSelf];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initSelf];
    }
    return self;
}

- (void) initSelf
{
    self.delegate = self;
	self.title = @"\n\n\n\n\n\n";
	self.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    //	self.actionSheetStyle = UIActionSheetStyleDefault;
	self.cancelButtonIndex = [self addButtonWithTitle:@"确定"];
    
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    _picker.showsSelectionIndicator = YES;
    _picker.dataSource = self;
    _picker.delegate = self;
	[self addSubview:_picker];
	
	[self load];
}

- (void) dealloc
{
    [self unload];
    SAFE_RELEASE(_picker);

    [super dealloc];
}

- (void)showFromToolbar:(UIToolbar *)view
{
	_parentView = view;
	
	[self showInView:view];
}

- (void)showFromTabBar:(UITabBar *)view
{
	_parentView = view;
	
	[self showInView:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
	if ( item.target && [item.target isKindOfClass:[UIView class]] )
	{
		_parentView = item.target;
	}
	
	[super showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
	_parentView = view;
	
	[super showFromRect:rect inView:view animated:animated];
}

- (void)showInView:(UIView *)view
{
	_parentView = view;
	
	[super showInView:view];
}

#pragma mark - BeeUIDataPicker Property
- (BOOL) showsSelectionIndicator
{
    return [_picker showsSelectionIndicator];
}
- (void) setShowsSelectionIndicator:(BOOL)showsSelectionIndicator
{
    [_picker setShowsSelectionIndicator:showsSelectionIndicator];
}

#pragma mark - BeeUIDataPicker Method

+ (BeeUIDataPicker *)spawn
{
	return [[[BeeUIDataPicker alloc] init] autorelease];
}

+ (BeeUIDataPicker *)spawn:(NSString *)tagString
{
	BeeUIDataPicker * view = [[[BeeUIDataPicker alloc] init] autorelease];
	view.tagString = tagString;
	return view;
}


- (void)showInViewController:(UIViewController *)controller	// samw as presentForController:
{
    [self presentForController:controller];
}
- (void)presentForController:(UIViewController *)controller
{
    _parentView = controller.view;
	
	[self showInView:controller.view];
}
- (void)dismissAnimated:(BOOL)animated
{
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:animated];
}

#pragma mark - UIPickerViewDataSource and UIPickerViewDelegate

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_datasource &&
        [_datasource respondsToSelector:@selector(numberOfComponentsInPickerView:)])
    {
        return [(id<BeeUIDataPickerDelegate>)_datasource numberOfComponentsInPickerView:self];
    }
    
    return 0;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_datasource &&
        [_datasource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)])
    {
        return [(id<BeeUIDataPickerDelegate>)_datasource pickerView:self numberOfRowsInComponent:component];
    }
    return 0;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_datasource &&
        [_datasource respondsToSelector:@selector(pickerView:titleForRow:forComponent:)])
    {
        return [(id<BeeUIDataPickerDelegate>)_datasource pickerView:self titleForRow:row forComponent:component];
    }
    return @"";
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_datasource &&
        [_datasource respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)])
    {
        [(id<BeeUIDataPickerDelegate>)_datasource pickerView:self didSelectRow:row inComponent:component];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0;
}


#pragma mark -
#pragma mark UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ( buttonIndex == self.cancelButtonIndex )
	{
		if ( _parentView )
		{
			[_parentView sendUISignal:BeeUIDataPicker.CONFIRMED withObject:nil from:self];
		}
		else
		{
			[self sendUISignal:BeeUIDataPicker.CONFIRMED withObject:nil from:self];
		}
	}
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
}

// before animation and showing view
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIDataPicker.WILL_PRESENT withObject:nil from:self];
	}
	else
	{
		[self sendUISignal:BeeUIDataPicker.WILL_PRESENT withObject:nil from:self];
	}
}

- (void)didDateChanged
{
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIDataPicker.CHANGED withObject:nil from:self];
	}
	else
	{
		[self sendUISignal:BeeUIDataPicker.CHANGED withObject:nil from:self];
	}
}

// after animation
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIDataPicker.DID_PRESENT withObject:nil from:self];
	}
	else
	{
		[self sendUISignal:BeeUIDataPicker.DID_PRESENT withObject:nil from:self];
	}
}

// before animation and hiding view
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIDataPicker.WILL_DISMISS withObject:nil from:self];
	}
	else
	{
		[self sendUISignal:BeeUIDataPicker.WILL_DISMISS withObject:nil from:self];
	}
}

// after animation
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ( _parentView )
	{
		[_parentView sendUISignal:BeeUIDataPicker.DID_DISMISS withObject:nil from:self];
	}
	else
	{
		[self sendUISignal:BeeUIDataPicker.DID_DISMISS withObject:nil from:self];
	}
}
@end

#endif