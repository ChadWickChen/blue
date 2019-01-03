//
//  CDRollLabel.h
//  366管家
//
//  Created by xhkj on 2017/4/17.
//  Copyright © 2017年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDRollLabel : UIScrollView

@property (nonatomic, strong) NSString *text; // 设置文字
@property (nonatomic, strong) UIColor  *textColor;
@property (nonatomic, strong) UIFont   *font;

@property(nonatomic,assign) float rollSpeed; // 滚动速度，默认0.5

/**
 *  初始化方法
 *  @param font  设置字体
 *  @param color 字体颜色
 */
-(instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color;

- (instancetype)initWithFrame:(CGRect)frame;

@end
