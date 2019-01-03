//
//  pushButton.m
//  animationOne
//
//  Created by 战明 on 16/5/15.
//  Copyright © 2016年 zhanming. All rights reserved.
//

#import "pushButton.h"

@implementation pushButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.imageView.frame=CGRectMake(0, 5, self.frame.size.width, self.frame.size.height-25);
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
//    self.imageView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.titleLabel.frame=CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.frame.size.width, 20);
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
//    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height ,-self.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
//    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -self.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

@end
