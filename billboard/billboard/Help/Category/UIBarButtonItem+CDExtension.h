//
//  UIBarButtonItem+CDExtension.h
//  HYLWarehouse
//
//  Created by chendong on 16/10/8.
//  Copyright © 2016年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CDExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
