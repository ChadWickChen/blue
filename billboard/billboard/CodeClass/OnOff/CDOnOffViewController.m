//
//  CDOnOffViewController.m
//  billboard
//
//  Created by chen on 2018/6/12.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "CDOnOffViewController.h"
#import "CDOnOffCell.h"
#import "CDOnOffModel.h"
#import "CDOffCell.h"
#import "XMRTimePiker.h"

@interface CDOnOffViewController ()<UITableViewDataSource,UITableViewDelegate,XMRTimePikerDelegate>
{
    NSIndexPath *currentIndexPath;
}
@property (nonatomic,strong)UITableView* deviceTableView;
//加载数据
@property (nonatomic,strong)NSMutableArray* dataArr;
//@property (nonatomic,strong)XMRTimePiker* timeView;

@end

@implementation CDOnOffViewController

//-(XMRTimePiker *)timeView
//{
//    if (_timeView==nil) {
//        _timeView = [[XMRTimePiker alloc] init];
//        _timeView.delegate=self;
//    }
//    return _timeView;
//}
#pragma mark-- tableView GETTER
-(UITableView *)deviceTableView{
    if (_deviceTableView==nil) {
        _deviceTableView=[UITableView new];
        _deviceTableView.delegate=self;
        _deviceTableView.dataSource=self;
        _deviceTableView.backgroundColor=BgColour;
        //        _personTableView.bounces=NO;
        _deviceTableView.frame=CGRectMake(0, 0, KScreen.width, KScreen.height-ViewHeaderHeight-ViewTabbarHeight-40);
        _deviceTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
    }
    return _deviceTableView;
}

#pragma mark--加载数据
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.deviceTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor=BgColour;
    [self loadViews];
    [self requestDataSource];
}

#pragma mark-- 加载数据
-(void)requestDataSource
{
    CDOnOffModel* model=[CDOnOffModel new];
    model.state=@"0";
    model.openTimeHour=@"09";
    model.openTimeMiniter=@"00";
    model.closeTimeHour=@"17";
    model.closeTimeMiniter=@"00";
    [self.dataArr addObject:model];
    
    CDOnOffModel* model1=[CDOnOffModel new];
    model1.state=@"1";
    model1.openTimeHour=@"09";
    model1.openTimeMiniter=@"00";
    model1.closeTimeHour=@"17";
    model1.closeTimeMiniter=@"00";
    [self.dataArr addObject:model1];
    
    CDOnOffModel* model2=[CDOnOffModel new];
    model2.state=@"2";
    model2.openTimeHour=@"09";
    model2.openTimeMiniter=@"00";
    model2.closeTimeHour=@"17";
    model2.closeTimeMiniter=@"00";
    [self.dataArr addObject:model2];
    
    CDOnOffModel* model3=[CDOnOffModel new];
    model3.state=@"0";
    model3.openTimeHour=@"09";
    model3.openTimeMiniter=@"00";
    model3.closeTimeHour=@"17";
    model3.closeTimeMiniter=@"00";
    [self.dataArr addObject:model3];
    
    CDOnOffModel* model4=[CDOnOffModel new];
    model4.state=@"0";
    model4.openTimeHour=@"09";
    model4.openTimeMiniter=@"00";
    model4.closeTimeHour=@"17";
    model4.closeTimeMiniter=@"00";
    [self.dataArr addObject:model4];
    
    CDOnOffModel* model5=[CDOnOffModel new];
    model5.state=@"0";
    model5.openTimeHour=@"09";
    model5.openTimeMiniter=@"00";
    model5.closeTimeHour=@"17";
    model5.closeTimeMiniter=@"00";
    [self.dataArr addObject:model5];
    
    CDOnOffModel* model6=[CDOnOffModel new];
    model6.state=@"0";
    model6.openTimeHour=@"09";
    model6.openTimeMiniter=@"00";
    model6.closeTimeHour=@"17";
    model6.closeTimeMiniter=@"00";
    [self.dataArr addObject:model6];
    [self.deviceTableView reloadData];
}

-(void)loadViews
{
    [self.view addSubview:self.deviceTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier=@"onoffCell";
    static NSString* offidentifier=@"offCell";
    CDOnOffModel* model=self.dataArr[indexPath.row];
    if ([model.state isEqualToString:@"2"]) {
        CDOnOffCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[CDOnOffCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=BgColour;
        }
        if (indexPath.row==0) {
            cell.nameLab.text=@"Monday";
        }else if(indexPath.row==1) {
            cell.nameLab.text=@"Tuesday";
        }else if(indexPath.row==2) {
            cell.nameLab.text=@"Wednesday";
        }else if(indexPath.row==3) {
            cell.nameLab.text=@"Thursday";
        }else if(indexPath.row==4) {
            cell.nameLab.text=@"Friday";
        }else if(indexPath.row==5) {
            cell.nameLab.text=@"Saturday";
        }else{
            cell.nameLab.text=@"Sunday";
        }
        if ([model.state isEqualToString:@"0"]) {
            [cell.segment setSelectedSegmentIndex:0];
            cell.detailLab.text=@"Your sign will not be lit for the duration of this day.";
        }
        else if ([model.state isEqualToString:@"1"])
        {
            [cell.segment setSelectedSegmentIndex:1];
            cell.detailLab.text=@"Your sign will remain lit for the duration of this day.";
        }else{
            [cell.segment setSelectedSegmentIndex:2];
            cell.detailLab.text=@"Your sign will only be lit between the hours below.";
        }
        cell.timeLab.text=[NSString stringWithFormat:@"%@:%@-%@:%@",model.openTimeHour,model.openTimeMiniter,model.closeTimeHour,model.closeTimeMiniter];
        [cell.segment addTarget:self action:@selector(changeMapAction:) forControlEvents:(UIControlEventValueChanged)];
        UITapGestureRecognizer *tapAr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeClick:)];
        tapAr.cancelsTouchesInView = NO;
        [cell.timeView addGestureRecognizer:tapAr];
        return cell;
    }else{
        CDOffCell* cell=[tableView dequeueReusableCellWithIdentifier:offidentifier];
        if (!cell) {
            cell=[[CDOffCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:offidentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=BgColour;
        }
        if (indexPath.row==0) {
            cell.nameLab.text=@"Monday";
        }else if(indexPath.row==1) {
            cell.nameLab.text=@"Tuesday";
        }else if(indexPath.row==2) {
            cell.nameLab.text=@"Wednesday";
        }else if(indexPath.row==3) {
            cell.nameLab.text=@"Thursday";
        }else if(indexPath.row==4) {
            cell.nameLab.text=@"Friday";
        }else if(indexPath.row==5) {
            cell.nameLab.text=@"Saturday";
        }else{
            cell.nameLab.text=@"Sunday";
        }
        if ([model.state isEqualToString:@"0"]) {
            [cell.segment setSelectedSegmentIndex:0];
            cell.detailLab.text=@"Your sign will not be lit for the duration of this day.";
        }
        else if ([model.state isEqualToString:@"1"])
        {
            [cell.segment setSelectedSegmentIndex:1];
            cell.detailLab.text=@"Your sign will remain lit for the duration of this day.";
        }else{
            [cell.segment setSelectedSegmentIndex:2];
            cell.detailLab.text=@"Your sign will only be lit between the hours below.";
        }
        [cell.segment addTarget:self action:@selector(changeMapAction:) forControlEvents:(UIControlEventValueChanged)];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDOnOffModel* model=self.dataArr[indexPath.row];
    if ([model.state isEqualToString:@"2"]) {
        return 190;
    }else{
        return 140;
    }
}

- (void)changeMapAction:(UISegmentedControl *)segment
{
//    NSLog(@"===%ld",segment.selectedSegmentIndex);
    CGPoint point =[segment convertPoint:segment.bounds.origin toView:self.deviceTableView];
    NSIndexPath *indexPath =[self.deviceTableView indexPathForRowAtPoint:point];
    CDOnOffModel* model=self.dataArr[indexPath.row];
    model.state=[NSString stringWithFormat:@"%ld",segment.selectedSegmentIndex];
    [self.deviceTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)timeClick:(UIGestureRecognizer* )ges
{
    CGPoint point = [ges locationInView:self.deviceTableView];
    NSIndexPath *indexPath =[self.deviceTableView indexPathForRowAtPoint:point];
    currentIndexPath=indexPath;
    CDOnOffModel* model=self.dataArr[indexPath.row];
    XMRTimePiker *timeView = [[XMRTimePiker alloc] init];
    timeView.delegate=self;
    [timeView SetOldShowTimeOneLeft:model.openTimeHour andOneRight:model.openTimeMiniter andTowLeft:model.closeTimeHour andTowRight:model.closeTimeMiniter];
    [timeView showTime];
}

#pragma mark-- 时间选择器代理
-(void)XMSelectTimesViewSetOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight andTowLeft:(NSString *)towLeft andTowRight:(NSString *)towRight
{
    CDOnOffModel* model=self.dataArr[currentIndexPath.row];
    model.openTimeHour=oneLeft;
    model.openTimeMiniter=oneRight;
    model.closeTimeHour=towLeft;
    model.closeTimeMiniter=towRight;
    [self.deviceTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:currentIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
