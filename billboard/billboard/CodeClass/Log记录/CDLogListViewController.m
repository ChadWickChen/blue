//
//  CDLogListViewController.m
//  billboard
//
//  Created by chen on 2018/8/16.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "CDLogListViewController.h"
#import "CDTextViewController.h"

@interface CDLogListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView* personTableView;
//加载数据
@property (nonatomic,strong)NSMutableArray* dataArr;
@end

@implementation CDLogListViewController

#pragma mark-- tableView GETTER
-(UITableView *)personTableView{
    if (_personTableView==nil) {
        _personTableView=[UITableView new];
        _personTableView.delegate=self;
        _personTableView.dataSource=self;
        _personTableView.backgroundColor=BgColour;
        _personTableView.frame=CGRectMake(0, ViewHeaderHeight, KScreen.width, KScreen.height-ViewHeaderHeight);
        _personTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
    }
    return _personTableView;
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
    self.title=@"Log目录";
    self.view.backgroundColor=BgColour;
    if (@available(iOS 11.0, *)) {
        self.personTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self loadViews];
    [self requestDataSource];
    [self loadNavButton];
}

-(void)loadNavButton
{
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [btn setTitle:@"清空" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(clearClick) forControlEvents:(UIControlEventTouchUpInside)];
    btn.titleLabel.font=NameFont(14);
    
    UIBarButtonItem* rightBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem= rightBtn;
}

-(void)clearClick
{
    if (self.dataArr.count==0) {
        [SVProgressHUD showInfoWithStatus:@"没有记录!"];
        return;
    }
    if (self.dataArr.count==1) {
        [SVProgressHUD showInfoWithStatus:@"当前记录不能清空!"];
        return;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:[NSString stringWithFormat:@"是否清空记录？"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self qingkongClick];
        
    }];
    UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alertVC addAction:OKAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)qingkongClick
{
    [SVProgressHUD show];
    SSLoggerCleanLog([NSDate distantFuture]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"清除成功!"];
        [self requestDataSource];
    });
    
}

-(void)requestDataSource
{
    [self.dataArr removeAllObjects];
    NSMutableArray* list= [[SSLogger shareManger]getLogFileNameList];
    NSArray *result = [list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [obj2 compare:obj1]; //降序
        
    }];
    [self.dataArr addObjectsFromArray:result];
    [self.personTableView reloadData];
}

-(void)loadViews
{
    [self.view addSubview:self.personTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

#pragma mark-- tableView delegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString* identifer=@"dingweicell";
    UITableViewCell*  cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell=[[UITableViewCell alloc] init];
    }
    cell.textLabel.text=self.dataArr[indexPath.row];
    cell.textLabel.font=NameFont(16);
    cell.textLabel.textColor=NameColour;
    UILabel* lineLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 49, KScreen.width-10, 1)];
    lineLab.backgroundColor=lineColour;
    [cell.contentView addSubview:lineLab];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CDTextViewController* vc=[[CDTextViewController alloc]init];
    vc.fileName=self.dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
