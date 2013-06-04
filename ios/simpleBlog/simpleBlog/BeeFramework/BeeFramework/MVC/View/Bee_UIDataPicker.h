//
//  Bee_UIDataPicker.h
//  lciMyBags
//
//  Created by  王 岩 on 13-5-15.
//  Copyright (c) 2013年  王 岩. All rights reserved.
//

#import "Bee_Precompile.h"
#import "Bee_UISignal.h"

@protocol BeeUIDataPickerDelegate;

@interface BeeUIDataPicker : UIActionSheet
<
    UIActionSheetDelegate,
    UIPickerViewDataSource,
    UIPickerViewDelegate
>

{
    UIPickerView *                              _picker;
}


AS_SIGNAL( WILL_PRESENT )       // 将要显示
AS_SIGNAL( DID_PRESENT )        // 已经显示
AS_SIGNAL( WILL_DISMISS )       // 将要隐藏
AS_SIGNAL( DID_DISMISS )        // 已经隐藏
AS_SIGNAL( CONFIRMED )          // 确认


@property (nonatomic, assign) id                datasource;
@property (nonatomic, assign) UIView *			parentView;
@property (nonatomic, assign) BOOL              showsSelectionIndicator;

/*
 *
 *data
 *如果不想使用delegate，可以直接设置这里
 *通过 selectData 获取
 *程序悠闲使用delegate方法
 *array结构
 *
 */
//@property (nonatomic, strong) NSArray *         pData;

@property (nonatomic, assign) id                selectData;

+ (BeeUIDataPicker *)spawn;
+ (BeeUIDataPicker *)spawn:(NSString *)tagString;

- (void)showInViewController:(UIViewController *)controller;	// samw as presentForController:
- (void)presentForController:(UIViewController *)controller;
- (void)dismissAnimated:(BOOL)animated;



@end



@protocol BeeUIDataPickerDelegate <NSObject>

- (NSInteger) numberOfComponentsInPickerView:(BeeUIDataPicker *)pickerView;
- (NSInteger) pickerView:(BeeUIDataPicker *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString *)pickerView:(BeeUIDataPicker *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void) pickerView:(BeeUIDataPicker *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end
