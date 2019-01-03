//
//  CDBlueTestViewController.m
//  billboard
//
//  Created by chen on 2018/7/18.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "CDBlueTestViewController.h"
#import "BabyBluetooth.h"
#import "CDSheBeiCell.h"
#import "CDJianCeViewController.h"
#import "CDSettingViewController.h"
#import "CDLogListViewController.h"

@interface CDBlueTestViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *peripheralDataArray;
    BabyBluetooth *baby;
    UILabel* countLab;
    int saomiaoTime;
//    int shebeirssi;
}
@property (nonatomic,strong)UITableView* menuTableView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int shebeirssi;
@end

@implementation CDBlueTestViewController

#pragma mark-- tableView GETTER
-(UITableView *)menuTableView{
    if (_menuTableView==nil) {
        _menuTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ViewHeaderHeight+40, KScreen.width, KScreen.height-ViewHeaderHeight-50-40) style:UITableViewStylePlain];
        _menuTableView.delegate=self;
        _menuTableView.dataSource=self;
        _menuTableView.backgroundColor=BgColour;
        _menuTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
    }
    return _menuTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.menuTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor=BgColour;
    self.title=@"蓝牙测试";
    peripheralDataArray = [[NSMutableArray alloc]init];
    
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    
    [self loadViews];
    [self loadNavButton];
    //设置蓝牙委托
    [self babyDelegate];
    //设置log
    SSLoggerStart();
    SSLoggerCleanLog([[NSDate date] dateByAddingTimeInterval:-60*60*24*7.0]);
    SSLoggerCatchCrash();
}

-(void)loadNavButton
{
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [btn setTitle:@"设置" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(addTime) forControlEvents:(UIControlEventTouchUpInside)];
    btn.titleLabel.font=NameFont(14);
    
    UIBarButtonItem* rightBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem= rightBtn;
    
    UIButton *leftbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftbtn setTitle:@"日志" forState:(UIControlStateNormal)];
    [leftbtn addTarget:self action:@selector(logClick) forControlEvents:(UIControlEventTouchUpInside)];
    leftbtn.titleLabel.font=NameFont(14);

    UIBarButtonItem* leftBtn=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem= leftBtn;
}

-(void)addTime
{
    CDSettingViewController* vc=[[CDSettingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入扫描时间" preferredStyle:UIAlertControllerStyleAlert];
//
//    //增加取消按钮；
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//
//
//    }]];
//    //增加确定按钮；
//    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        //获取第1个输入框；
//        UITextField *userNameTextField = alertController.textFields.firstObject;
//        self->saomiaoTime=[userNameTextField.text intValue];
////        NSLog(@"支付密码 = %@",userNameTextField.text);
//
//    }]];
//    //定义第一个输入框；
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//
//        textField.placeholder = @"请输入扫描时间";
//        textField.keyboardType = UIKeyboardTypeNumberPad;
//
//    }];
//    [self presentViewController:alertController animated:true completion:nil];
}

-(void)logClick
{
    CDLogListViewController* vc=[[CDLogListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -蓝牙配置和操作
//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }
    }];
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
    }];
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        weakSelf.shebeirssi=[[UserDefaultUtil valueForKey:@"xinhao"] intValue];
        if (weakSelf.shebeirssi) {
            if ([peripheralName hasPrefix:@"GLI"] &&  abs([RSSI intValue])>=weakSelf.shebeirssi) {
                return YES;
            }
            return NO;
        }else{
            if ([peripheralName hasPrefix:@"GLI"]&&  abs([RSSI intValue])>=45) {
                return YES;
            }
            return NO;
        }
        //最常用的场景是查找某一个前缀开头的设备
//                if ([peripheralName hasPrefix:@"GLI"] ) {
//                    return YES;
//                }
//                return NO;
        
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
//        if (peripheralName.length >0) {
//            return YES;
//        }
//        return NO;
    }];

    
}

#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSArray *peripherals = [peripheralDataArray valueForKey:@"peripheral"];
    if(![peripherals containsObject:peripheral]) {
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        [item setValue:advertisementData forKey:@"advertisementData"];
        [peripheralDataArray addObject:item];
        countLab.text=[NSString stringWithFormat:@"搜索到的设备:%lu个",(unsigned long)peripheralDataArray.count];
        [self.menuTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)loadViews
{
    [self.view addSubview:self.menuTableView];
    UIView *headView=[[UIView alloc]init];
    headView.frame=CGRectMake(0, ViewHeaderHeight, KScreen.width, 40);
    headView.backgroundColor=ColorWith(127, 127, 127, 1);
    [self.view addSubview:headView];
    
    countLab=[[UILabel alloc]init];
    countLab.frame=CGRectMake(15, 0, KScreen.width, 40);
    countLab.font=NameFont(14);
    countLab.textColor=NameColour;
    [headView addSubview:countLab];
    
    UIView *bottomView=[[UIView alloc]init];
    bottomView.frame=CGRectMake(0, KScreen.height-50, KScreen.width, 50);
    [self.view addSubview:bottomView];
    
    UIButton* scanBtn=[[UIButton alloc]init];
    scanBtn.frame=CGRectMake(0, 0, KScreen.width/2, 50);
    [scanBtn setTitle:@"扫描设备" forState:(UIControlStateNormal)];
    scanBtn.titleLabel.font=NameFont(16);
    [scanBtn setTitleColor:ColorWith(50, 190, 140, 1) forState:(UIControlStateNormal)];
    [scanBtn addTarget:self action:@selector(scanClick) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:scanBtn];
    
    UIButton* jianceBtn=[[UIButton alloc]init];
    jianceBtn.frame=CGRectMake(KScreen.width/2, 0, KScreen.width/2, 50);
    [jianceBtn setTitle:@"开始检测" forState:(UIControlStateNormal)];
    jianceBtn.titleLabel.font=NameFont(16);
    [jianceBtn setTitleColor:ColorWith(50, 190, 140, 1) forState:(UIControlStateNormal)];
    [jianceBtn addTarget:self action:@selector(jianceClick) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:jianceBtn];
    
    
    UIView* lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreen.width, 1)];
    lineView.backgroundColor=lineColour;
    [bottomView addSubview:lineView];
    
    UIView* lineView1=[[UIView alloc]initWithFrame:CGRectMake(KScreen.width/2, 0, 1, 50)];
    lineView1.backgroundColor=lineColour;
    [bottomView addSubview:lineView1];
}

#pragma mark -table委托 table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return peripheralDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     static NSString* identifier=@"deviceCell";
    CDSheBeiCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[CDSheBeiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    NSDictionary *advertisementData = [item objectForKey:@"advertisementData"];
    NSNumber *RSSI = [item objectForKey:@"RSSI"];
    //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
    NSString *peripheralName;
    if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
        peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
        peripheralName = peripheral.name;
    }else{
        peripheralName = [peripheral.identifier UUIDString];
    }
    
    cell.nameLab.text = peripheralName;
    //信号和服务
    cell.detailLab.text = [NSString stringWithFormat:@"RSSI:%@",RSSI];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)scanClick
{
    [peripheralDataArray removeAllObjects];
    [self.menuTableView reloadData];
    countLab.text=@"";
    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    saomiaoTime=[[UserDefaultUtil valueForKey:@"saomiao"] intValue];
    baby.scanForPeripherals().begin().stop(saomiaoTime?saomiaoTime:10);
    [SVProgressHUD showWithStatus:@"开始扫描..."];
//    [self startHudWithTitle:@"开始扫描检测设备不能为零..."];
//    [MBProgressHUD HUDForView:self.navigationController.view].progress = 0.3f;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:saomiaoTime?saomiaoTime:10 target:self selector:@selector(autoTimerFire) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

-(void)jianceClick
{
    if (peripheralDataArray.count==0) {
        [SVProgressHUD showErrorWithStatus:@"检测设备不能为零!"];
        return;
    }
    
//    [[SSLogger shareManger]cleanLogBeforeCount:5];
    CDJianCeViewController* vc=[[CDJianCeViewController alloc]init];
    vc.peripheralTmp = peripheralDataArray;
    vc->baby = self->baby;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)autoTimerFire
{
    [self stopTime];
    [SVProgressHUD dismiss];
//    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"扫描结束，共发现设备:%ld",peripheralDataArray.count]];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:[NSString stringWithFormat:@"扫描结束\n共发现设备:%ld",peripheralDataArray.count] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //                    NSLog(@"点击了知道了");
        
    }];
    [alertVC addAction:OKAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)stopTime{
    if (self.timer) {
        if ([self.timer respondsToSelector:@selector(isValid)]){
            if ([self.timer isValid]){
                [self.timer invalidate];
            }
        }
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
