//
//  CDImageTextView.m
//  366管家
//
//  Created by xhkj on 2017/3/27.
//  Copyright © 2017年 chendong. All rights reserved.
//

#import "CDImageTextView.h"
#import <Masonry.h>
@interface CDImageTextView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation CDImageTextView
- (instancetype)init
{
    if (self = [super init]) {
        self.imageView = [[UIImageView alloc]init];
        self.imageView.userInteractionEnabled = NO;
        [self addSubview:self.imageView];
        
        self.label = [[UILabel alloc]init];
        self.label.userInteractionEnabled = NO;
        self.label.font = NameFont(16);
        self.label.textColor=ColorWith(51, 51, 51, 1);
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(20);
        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.mas_equalTo(10);
            make.trailing.mas_equalTo(-20);
            make.bottom.equalTo(self.label.mas_top).offset(-10);
        }];
    }
    return self;
}

+ (instancetype)IconImageTextView:(NSString *)image title:(NSString *)title
{
    CDImageTextView* view = [[self alloc]init];
    view.imageView.image=[UIImage imageNamed:image];
    view.label.text = title;
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
