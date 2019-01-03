//
//  CDPageTabItemButton.m
//  cdschool
//
//  Created by chen on 2018/6/11.
//  Copyright © 2018年 chendong. All rights reserved.
//

#import "CDPageTabItemButton.h"

@implementation CDPageTabItemButton

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if([_fillColor isKindOfClass:[UIColor class]]) {
        [_fillColor setFill];
        UIRectFillUsingBlendMode(CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*_process, rect.size.height), kCGBlendModeSourceIn);
    }
}

- (void)setProcess:(CGFloat)process {
    _process = process;
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
