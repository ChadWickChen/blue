//
//  CDOffCell.m
//  billboard
//
//  Created by chen on 2018/6/13.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "CDOffCell.h"

@implementation CDOffCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, KScreen.width, 50)];
        [self addSubview:self.nameLab];
        self.nameLab.textColor=xingqiColour;
        self.nameLab.textAlignment=NSTextAlignmentCenter;
        self.nameLab.font=NameFont(24);
        
        self.segment = [[UISegmentedControl alloc] initWithItems:@[@"Closed", @"24Hours", @"Hourly"]];
        self.segment.frame=CGRectMake(10, self.nameLab.y+self.nameLab.height+5, KScreen.width-20, 30);
        //        self.segment.backgroundColor=BgColour;
        self.segment.tintColor = [UIColor whiteColor];
        self.segment.borderColor=[UIColor whiteColor];
        self.segment.borderWidth=1.0f;
        self.segment.cornerRadius=5;
        //    选中的颜色
        [self.segment setTitleTextAttributes:@{NSForegroundColorAttributeName:BgColour} forState:UIControlStateSelected];
        //    未选中的颜色
        [self.segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [self.segment setSelectedSegmentIndex:0];
        [self addSubview:self.segment];
        
        self.detailLab=[[UILabel alloc]initWithFrame:CGRectMake(10, self.segment.y+self.segment.height+10, KScreen.width-20, 30)];
        [self addSubview:self.detailLab];
        self.detailLab.textColor=detailColour;
        self.detailLab.textAlignment=NSTextAlignmentLeft;
        self.detailLab.font=NameFont(12);
        
        UIView* lineView=[[UIView alloc]initWithFrame:CGRectMake(0, self.detailLab.y+self.detailLab.height-0.5, KScreen.width, 0.5)];
        lineView.backgroundColor=detailColour;
        [self addSubview:lineView];
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
