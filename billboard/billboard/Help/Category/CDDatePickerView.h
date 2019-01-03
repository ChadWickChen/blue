//
//  CDDatePickerView.h
//  HYLWarehouse
//
//  Created by chendong on 17/2/3.
//  Copyright © 2017年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDDatePickerView;

@protocol CDDatePickerViewDelegate <NSObject>

- (void)didSelectDateResult:(NSString *)resultDate;

@end

@interface CDDatePickerView : UIView
@property (nonatomic ,weak) id<CDDatePickerViewDelegate> delegate;

/**
 显示PickerView
 */
- (void)show;

/**
 移除PickerView
 */
- (void)remove;
@end
