//
//  CDSheBeiCell.m
//  billboard
//
//  Created by chen on 2018/7/20.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "CDSheBeiCell.h"

@implementation CDSheBeiCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreen.width-15, 30)];
        self.nameLab.textAlignment=NSTextAlignmentLeft;
        self.nameLab.textColor=NameColour;
        self.nameLab.font=NameFont(16);
        [self addSubview:self.nameLab];
        
        self.detailLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 30, KScreen.width-15, 20)];
        self.detailLab.textAlignment=NSTextAlignmentLeft;
        self.detailLab.textColor=NameColour;
        self.detailLab.font=NameFont(12);
        [self addSubview:self.detailLab];
        
        UIView* lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 49, KScreen.width, 1)];
        lineView.backgroundColor=lineColour;
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
