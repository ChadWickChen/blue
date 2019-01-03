//
//  UIBarButtonItem+CDExtension.m
//  HYLWarehouse
//
//  Created by chendong on 16/10/8.
//  Copyright © 2016年 chendong. All rights reserved.
//

#import "UIBarButtonItem+CDExtension.h"

@implementation UIBarButtonItem (CDExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

@end
