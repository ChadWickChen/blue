//
//  CDMainViewController.m
//  billboard
//
//  Created by chen on 2018/6/12.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "CDMainViewController.h"
#import "XXPageTabView.h"
#import "CDEffectsViewController.h"
#import "CDColorsViewController.h"
#import "CDHoursViewController.h"
#import "CDOnOffViewController.h"
@interface CDMainViewController ()<XXPageTabViewDelegate>
@property (nonatomic, strong) XXPageTabView *pageTabView;
@end

@implementation CDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Set on/off times";
    self.view.backgroundColor=BgColour;
    [self loadchildrens];
    [self loadNavcBtn];
    [self loadViews];
    [self loadBottomView];
}

-(void)loadchildrens
{
    CDOnOffViewController* totalVc=[[CDOnOffViewController alloc]init];
    CDHoursViewController* payVc=[[CDHoursViewController alloc]init];
    CDColorsViewController* waitVc=[[CDColorsViewController alloc]init];
    CDOnOffViewController* receiveVc=[[CDOnOffViewController alloc]init];
    [self addChildViewController:totalVc];
    [self addChildViewController:payVc];
    [self addChildViewController:waitVc];
    [self addChildViewController:receiveVc];
}

#pragma mark-- 加载navigation
-(void)loadNavcBtn
{
    
}

-(void)loadViews
{
    self.pageTabView=[[XXPageTabView alloc]initWithChildControllers:self.childViewControllers childTitles:@[@"On/Off",@"Hours",@"Colors",@"Effects"] childImgs:@[@"e_1",@"e_2",@"e_3",@"e_4"] childSelectImgs:@[@"e_1_1",@"e_2_1",@"e_3_1",@"e_4_1"]];
    self.pageTabView.frame = CGRectMake(0, ViewHeaderHeight, self.view.frame.size.width, KScreen.height-ViewHeaderHeight-ViewTabbarHeight);
//    self.pageTabView.backgroundColor=BgColour;
    self.pageTabView.tabBackgroundColor=ColorWith(45, 44, 44, 1);
    self.pageTabView.bodyBackgroundColor=BgColour;
    //    self.pageTabView.delegate = self;
    self.pageTabView.titleStyle = XXPageTabTitleStyleDefault;
    self.pageTabView.indicatorStyle = XXPageTabIndicatorStyleFollowText;
    self.pageTabView.maxNumberOfPageItems = 4;
    self.pageTabView.delegate=self;
    self.pageTabView.tabItemFont = NameFont(14);
    
    //    self.pageTabView.indicatorWidth = 20;
    self.pageTabView.selectedColor=[UIColor whiteColor];
    self.pageTabView.unSelectedColor=ColorWith(170, 169, 169, 1);
    [self.view addSubview:self.pageTabView];
}

-(void)loadBottomView
{
    UIView* bottomView=[[UIView alloc]init];
    bottomView.frame=CGRectMake(0, KScreen.height-ViewTabbarHeight, KScreen.width, ViewTabbarHeight);
    bottomView.backgroundColor=ColorWith(45, 44, 44, 1);
    [self.view addSubview:bottomView];
    
    UIButton* updateBtn=[[UIButton alloc]init];
    updateBtn.frame=CGRectMake(10, 5, bottomView.width-20, bottomView.height-10);
    [updateBtn setTitle:@"Update" forState:(UIControlStateNormal)];
    updateBtn.backgroundColor=xingqiColour;
    [updateBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    updateBtn.titleLabel.font=NameFont(16);
    updateBtn.cornerRadius=5;
    [bottomView addSubview:updateBtn];
}

- (void)pageTabViewDidEndChange
{
    if (self.pageTabView.selectedTabIndex==0) {
        self.title=@"Set on/off times";
    }else if (self.pageTabView.selectedTabIndex==1) {
        self.title=@"Set sign hours";
    }else if (self.pageTabView.selectedTabIndex==2) {
        self.title=@"Set sign colors";
    }else{
        self.title=@"Set sign effects";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
