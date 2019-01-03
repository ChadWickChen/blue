//
//  CDOnOffCell.m
//  billboard
//
//  Created by chen on 2018/6/12.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "CDOnOffCell.h"

@implementation CDOnOffCell

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
        
        self.timeView=[[UIView alloc]init];
        self.timeView.frame=CGRectMake(0, self.detailLab.y+self.detailLab.height, KScreen.width, 50);
        [self addSubview:self.timeView];
        
        UILabel* open=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 50)];
        [self.timeView addSubview:open];
        open.textColor=[UIColor whiteColor];
        open.textAlignment=NSTextAlignmentLeft;
        open.numberOfLines=2;
        open.font=NameFont(16);
        open.text=@"Open\nClose";
        
        self.timeLab=[[UILabel alloc]initWithFrame:CGRectMake(open.x+open.width, 0, KScreen.width-(open.x+open.width)-10, 50)];
        [self.timeView addSubview:self.timeLab];
        self.timeLab.textColor=[UIColor whiteColor];
        self.timeLab.textAlignment=NSTextAlignmentRight;
        self.timeLab.font=NameFont(16);
        
        UIView* lineView=[[UIView alloc]initWithFrame:CGRectMake(0, self.detailLab.y+self.detailLab.height-0.5, KScreen.width, 0.5)];
        lineView.backgroundColor=detailColour;
        [self addSubview:lineView];
        
        UIView* lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, self.timeView.y+self.timeView.height-0.5, KScreen.width, 0.5)];
        lineView1.backgroundColor=detailColour;
        [self addSubview:lineView1];
        
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
