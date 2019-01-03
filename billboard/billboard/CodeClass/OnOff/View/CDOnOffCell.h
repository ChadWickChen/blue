//
//  CDOnOffCell.h
//  billboard
//
//  Created by chen on 2018/6/12.
//  Copyright © 2018年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDOnOffCell : UITableViewCell
@property (nonatomic,strong)UILabel* nameLab;
@property (nonatomic,strong)UISegmentedControl* segment;
@property (nonatomic,strong)UILabel* detailLab;
@property (nonatomic,strong)UIView* timeView;
@property (nonatomic,strong)UILabel* timeLab;
@end
