//
//  CDTextField.m
//  HYLWarehouse
//
//  Created by chendong on 16/10/9.
//  Copyright © 2016年 chendong. All rights reserved.
//

#import "CDTextField.h"
static NSString * const CDPlacerholderColorKeyPath = @"_placeholderLabel.textColor";
@implementation CDTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 设置光标颜色和文字颜色一致
    self.tintColor = [UIColor whiteColor];
    
    // 不成为第一响应者
    [self resignFirstResponder];
}

/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    // 修改占位文字颜色
    [self setValue:self.textColor forKeyPath:CDPlacerholderColorKeyPath];
    return [super becomeFirstResponder];
}

/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    // 修改占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:CDPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
