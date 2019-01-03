//
//  CDBarButtonView.h
//  366管家
//
//  Created by xhkj on 2017/9/22.
//  Copyright © 2017年 chendong. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BarButtonViewPosition) {
    BarButtonViewPositionLeft,
    BarButtonViewPositionRight
};

@interface CDBarButtonView : UIView

@property (nonatomic, assign) BarButtonViewPosition position;

@end
