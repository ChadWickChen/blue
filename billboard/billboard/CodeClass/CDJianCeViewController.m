//
//  CDJianCeViewController.m
//  billboard
//
//  Created by chen on 2018/7/20.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "CDJianCeViewController.h"
// 通知特征值
static NSString * const kNotifyCharacteristicUUID = @"2AF0";
// 写特征值
static NSString * const kWriteCharacteristicUUID = @"2AF1";
#define channelOnPeropheralView @"ledperipheral"

@interface CDJianCeViewController ()
{
    NSMutableArray *peripheralDataArray;
    NSInteger index;
    
    NSInteger receiveCount;//记录接收次数
    
    NSMutableArray *peripheralErrorArray;//记录失败的设备
    NSMutableArray *peripheralOutTimeArray;//记录连接超时的设备
    NSMutableArray *fujianArray;//记录复检的设备
    UITextView* markText;
    UIScrollView* markScroll;
    NSMutableString* markStr;
    MBProgressHUD *hud;
    
    NSString* disconnectIdentifier;//判断主动断开1 设备断开2
}
@property (nonatomic,strong)CBCharacteristic *notiCharacteristic;
@property (nonatomic,strong)CBPeripheral *notiPeripheral;
@property (nonatomic,strong)CBCharacteristic *wriCharacteristic;
@property (nonatomic,strong)CBPeripheral *wriPeripheral;
//记录临时数据
@property (nonatomic,copy)NSString* receiveStr;
@property (nonatomic,copy)NSString* buttonState;
@property (nonatomic,copy)NSString* timeState;
//延时接收定时器
@property (nonatomic, strong) NSTimer *timer;
//复检标识
@property (nonatomic,copy)NSString* fujianIdentifier;

@end

@implementation CDJianCeViewController

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    if (self.notiPeripheral) {
        [baby cancelNotify:self.notiPeripheral characteristic:self.notiCharacteristic];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
//        self.deviceTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor=BgColour;
    self.title=@"设备检测";
    [self loadViews];
    [self loadNavButton];
    self.receiveStr=@"";
    self.buttonState=@"-1";
    self.timeState=@"0";
    self.fujianIdentifier=@"0";
    receiveCount=0;
    index=0;
    disconnectIdentifier=@"2";//初始设置为设备断开
    peripheralDataArray = [[NSMutableArray alloc]init];
    [peripheralDataArray addObjectsFromArray:_peripheralTmp];
    peripheralErrorArray= [[NSMutableArray alloc]init];
    peripheralOutTimeArray=[[NSMutableArray alloc]init];
    fujianArray=[[NSMutableArray alloc]init];
    markStr=[[NSMutableString alloc] init];
    //设置蓝牙委托
    [self babyDelegate];
//    [self connectPeripheral:peripheralDataArray[index]];
    [self connectFirstPeripheral];
//    [SVProgressHUD showWithStatus:@"设置颜色..."];
//    [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"设置颜色..."];
    [self startHudWithTitle:@"设置颜色..."];
    [MBProgressHUD HUDForView:self.navigationController.view].progress = (index)/(float)peripheralDataArray.count;
    self.title=[NSString stringWithFormat:@"完成情况:%ld/%ld",index,peripheralDataArray.count];
    [markStr appendFormat:@"设置颜色:\n"];
    [self updateMarkTextView];
    SSLog(@"设置颜色...%ld/%ld",index,peripheralDataArray.count);
}

-(void)loadNavButton
{
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [btn setTitle:@"复检" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(fujianClick) forControlEvents:(UIControlEventTouchUpInside)];
    btn.titleLabel.font=NameFont(14);
    
    UIBarButtonItem* rightBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem= rightBtn;
}

#pragma mark-- 复检操作
-(void)fujianClick
{
    if (fujianArray.count==0) {
        [SVProgressHUD showErrorWithStatus:@"复检设备不能为零!"];
    }else{
        self.fujianIdentifier=@"1";
        index=0;
        [self connectFirstPeripheral];
        [MBProgressHUD HUDForView:self.navigationController.view].progress = (index)/(float)fujianArray.count;
        if ([self.buttonState isEqualToString:@"-1"]) {
//            [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"设置颜色复检..."];
            [self startHudWithTitle:@"设置颜色复检..."];
            [markStr appendFormat:@"设置颜色复检:\n"];
            [self updateMarkTextView];
            SSLog(@"设置颜色复检...%ld/%ld",index,fujianArray.count);
        }
        else if ([self.buttonState isEqualToString:@"0"])
        {
//            [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"校正时间复检..."];
            [self startHudWithTitle:@"校正时间复检..."];
            [markStr appendFormat:@"校正时间复检:\n"];
            [self updateMarkTextView];
            SSLog(@"校正时间复检...%ld/%ld",index,fujianArray.count);
        }else if ([self.buttonState isEqualToString:@"1"])
        {
//            [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"二次检测复检..."];
            [self startHudWithTitle:@"二次检测复检..."];
            [markStr appendFormat:@"二次检测复检:\n"];
            [self updateMarkTextView];
            SSLog(@"二次检测复检...%ld/%ld",index,fujianArray.count);
        }else if ([self.buttonState isEqualToString:@"2"])
        {
//            [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"A1检测复检..."];
            [self startHudWithTitle:@"A1检测复检..."];
            [markStr appendFormat:@"A1检测复检:\n"];
            [self updateMarkTextView];
            SSLog(@"A1检测复检...%ld/%ld",index,fujianArray.count);
        }else if ([self.buttonState isEqualToString:@"3"])
        {
//            [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"open全开检测复检..."];
            [self startHudWithTitle:@"open全开检测复检..."];
            [markStr appendFormat:@"open全开检测复检:\n"];
            [self updateMarkTextView];
            SSLog(@"open全开检测复检...%ld/%ld",index,fujianArray.count);
        }else if ([self.buttonState isEqualToString:@"4"])
        {
//            [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"颜色轮变检测复检..."];
            [self startHudWithTitle:@"颜色轮变检测复检..."];
            [markStr appendFormat:@"颜色轮变检测复检:\n"];
            [self updateMarkTextView];
            SSLog(@"颜色轮变检测复检...%ld/%ld",index,fujianArray.count);
        }else if ([self.buttonState isEqualToString:@"5"])
        {
//            [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"数码管检测复检..."];
            [self startHudWithTitle:@"数码管检测复检..."];
            [markStr appendFormat:@"数码管检测复检:\n"];
            [self updateMarkTextView];
            SSLog(@"数码管检测复检...%ld/%ld",index,fujianArray.count);
        }else if ([self.buttonState isEqualToString:@"6"])
        {
//            [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"恢复出厂检测复检..."];
            [self startHudWithTitle:@"恢复出厂检测复检..."];
            [markStr appendFormat:@"恢复出厂检测复检:\n"];
            [self updateMarkTextView];
            SSLog(@"恢复出厂检测复检...%ld/%ld",index,fujianArray.count);
        }
    }
    
}

#pragma mark -蓝牙配置和操作
//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateStateAtChannel:channelOnPeropheralView block:^(CBCentralManager *central) {
        
        if (central.state != CBCentralManagerStatePoweredOn) {
            NSString* message;
            if (central.state==CBCentralManagerStateUnknown) {
                message=@"不可知状态";
            }else if(central.state==CBCentralManagerStateResetting){
                message=@"手机蓝牙正在重置";
            }else if(central.state==CBCentralManagerStateUnsupported){
                message=@"设备不支持的状态";
            }else if(central.state==CBCentralManagerStateUnauthorized){
                message=@"设备未授权状态";
            }else if(central.state==CBCentralManagerStatePoweredOff){
                message=@"手机蓝牙关闭";
            }
            SSLog(@"蓝牙状态改变:%@",message);
            [weakSelf lanyaStateChangeWithMessage:message];
            
        }
    }];
    
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@--连接成功",peripheral.name);
        SSLog(@"设备连接成功");
        [weakSelf stopTime];
#pragma mark-- 设定定时器，从读特征值开始到数据处理结束
//        [weakSelf startDingShiQi];
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        SSLog(@"设备连接失败");
//        [weakSelf cancelNotifyPeripheral];
//        [weakSelf connectNextPeripheral];
        [weakSelf chuliyichang:peripheral.name];
    }];
    
    //设置设备断开连接的委托
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        SSLog(@"设备断开连接");
//        [weakSelf cancelNotifyPeripheral];
//        [weakSelf connectNextPeripheral];
        [weakSelf chuliyichang:peripheral.name];
    }];
    
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"特征值:%@",characteristics.UUID.UUIDString);
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        if ([characteristics.UUID.UUIDString isEqualToString:kNotifyCharacteristicUUID]) {
            weakSelf.notiPeripheral=peripheral;
            weakSelf.notiCharacteristic=characteristics;
             [weakSelf chuliperipheral:peripheral characteristic:characteristics];
            SSLog(@"监听接收");
        }
        if ([characteristics.UUID.UUIDString isEqualToString:kWriteCharacteristicUUID]) {
            weakSelf.wriPeripheral=peripheral;
            weakSelf.wriCharacteristic=characteristics;
            [weakSelf sendZhiLing];
            
        }

        
    }];
    
    //设置写数据成功的block
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"写入数据成功:%@ and new value:%@",characteristic.UUID, characteristic.value);
        SSLog(@"写入数据成功");
        weakSelf.receiveStr=@"";
//        [weakSelf startDingShiQi];
    }];
    
    //设置通知状态改变的block
    [baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnPeropheralView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
}

#pragma mark-- 蓝牙状态改变
-(void)lanyaStateChangeWithMessage:(NSString* )message
{
    [self stopTime];
    [SVProgressHUD dismiss];
    [hud hideAnimated:YES];
    [peripheralErrorArray removeAllObjects];
    [peripheralOutTimeArray removeAllObjects];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"蓝牙状态改变"] message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alertVC addAction:OKAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark-- 开启定时器
-(void)startDingShiQi
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(dingshiqiClick) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark-- 处理从发送指令到接受数据超时的click
-(void)dingshiqiClick
{
    [self stopTime];
    SSLog(@"接收数据超时");
    disconnectIdentifier=@"1";
    [peripheralErrorArray addObject:self.notiPeripheral];
    [baby cancelPeripheralConnection:self.notiPeripheral];
//    receiveCount++;
//    if (receiveCount==1) {
//        receiveCount=0;
//        [peripheralErrorArray addObject:self.notiPeripheral.name];
//        [baby cancelPeripheralConnection:self.notiPeripheral];
//
//    }else{
//        [self sendZhiLing];
//    }
}

#pragma mark-- 循环发送指令
-(void)sendZhiLing
{
    if ([self.buttonState isEqualToString:@"-1"]) {//发送蓝色命令
        [self sendMessage:@"aa5555aa000000b8b102030004040404c33c"];
    }
    else if ([self.buttonState isEqualToString:@"0"])
    {
//        [self sendMessage:@"aa5555aa0000000fdd02c33c"];
        self.timeState=@"0";
        [self sendMessage:[NSString stringWithFormat:@"aa5555aa0000000fd102%@c33c",[self getHexStringFromYearMonth]]];
    }
    else if ([self.buttonState isEqualToString:@"1"])
    {
        [self sendMessage:@"aa5555aa0000000fdd02c33c"];
    }
    else if ([self.buttonState isEqualToString:@"2"])
    {
        [self sendMessage:@"aa5555aa000000a3a102c33c"];
    }
    else if ([self.buttonState isEqualToString:@"3"])
    {
        [self sendMessage:@"aa5555aa0000000fdb0201c33c"];
    }
    else if ([self.buttonState isEqualToString:@"4"])
    {//颜色轮变
        [self sendMessage:@"aa5555aa000000b8b102010001020401c33c"];
    }
    else if ([self.buttonState isEqualToString:@"5"])
    {
        [self sendMessage:@"aa5555aa0000000fb50201c33c"];
    }
    else if ([self.buttonState isEqualToString:@"6"])
    {
        [self sendMessage:@"aa5555aa0000000fb50202c33c"];
    }
}

#pragma mark-- 取消当前设备的通知
-(void)cancelNotifyPeripheral
{
    if (self.notiPeripheral) {
        [baby cancelNotify:self.notiPeripheral characteristic:self.notiCharacteristic];
    }
}

#pragma mark-- 连接第一个设备
-(void)connectFirstPeripheral
{
    index=0;
    disconnectIdentifier=@"2";
    if ([self.fujianIdentifier isEqualToString:@"1"]) {
        [self connectPeripheral:fujianArray[index]];
    }else{
        [self connectPeripheral:peripheralDataArray[index]];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(connectErrorClick) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark-- 连接下一个设备
-(void)connectNextPeripheral
{
    index++;
    disconnectIdentifier=@"2";
    if ([self.fujianIdentifier isEqualToString:@"1"]) {//复检
        
        if (index==fujianArray.count) {//连接结束
            SSLog(@"连接结束");
            [SVProgressHUD dismiss];
            [hud hideAnimated:YES];
            self.title=@"设备检测";
            [markStr appendFormat:@"%@", [NSString stringWithFormat:@"成功:%ld,失败:%ld,连接超时:%ld;\n\n",fujianArray.count- peripheralErrorArray.count-peripheralOutTimeArray.count,peripheralErrorArray.count,peripheralOutTimeArray.count]];
            //        if (peripheralErrorArray.count==0) {//失败0
            //            [markStr appendFormat:@"%@", [NSString stringWithFormat:@"成功:%ld,失败:%ld\n\n\n",peripheralDataArray.count- peripheralErrorArray.count,peripheralErrorArray.count]];
            //        }else{
            //            [markStr appendFormat:@"%@", [NSString stringWithFormat:@"成功:%ld,失败:%ld(%@)\n\n\n",peripheralDataArray.count- peripheralErrorArray.count,peripheralErrorArray.count,[peripheralErrorArray componentsJoinedByString:@","]]];
            //        }
            
            [self updateMarkTextView];
//            NSMutableArray* tmpArr=[NSMutableArray arrayWithArray:fujianArray];
            [fujianArray removeAllObjects];
#pragma mark-- 处理复检数组（超时+失败）
            for (CBPeripheral* per in peripheralErrorArray) {
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                dic[@"peripheral"]=per;
                [fujianArray addObject:dic];
            }
            [fujianArray addObjectsFromArray:peripheralOutTimeArray];
//            [fujianArray addObjectsFromArray:peripheralErrorArray];
            [peripheralErrorArray removeAllObjects];
            [peripheralOutTimeArray removeAllObjects];
            
        }else{
            SSLog(@"完成情况:%ld/%ld",index,fujianArray.count);
            self.title=[NSString stringWithFormat:@"完成情况:%ld/%ld",index,fujianArray.count];
            [MBProgressHUD HUDForView:self.navigationController.view].progress = (index)/(float)fujianArray.count;
//            if ([self.buttonState isEqualToString:@"-1"]) {
//                [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"设置颜色复检..."];
//            }
//            else if ([self.buttonState isEqualToString:@"0"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"校正时间复检..."];
//            }else if ([self.buttonState isEqualToString:@"1"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"二次检测复检..."];
//            }else if ([self.buttonState isEqualToString:@"2"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"A1检测复检..."];
//            }else if ([self.buttonState isEqualToString:@"3"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"open全开检测复检..."];
//            }else if ([self.buttonState isEqualToString:@"4"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"颜色轮变检测复检..."];
//            }else if ([self.buttonState isEqualToString:@"5"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"数码管检测复检..."];
//            }else if ([self.buttonState isEqualToString:@"6"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)fujianArray.count status:@"恢复出厂检测复检..."];
//            }
            
            [self connectPeripheral:fujianArray[index]];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(connectErrorClick) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }else{
        
        if (index==peripheralDataArray.count) {//连接结束
            SSLog(@"连接结束");
            [SVProgressHUD dismiss];
            [hud hideAnimated:YES];
            self.title=@"设备检测";
            [markStr appendFormat:@"%@", [NSString stringWithFormat:@"成功:%ld,失败:%ld,连接超时:%ld;\n\n",peripheralDataArray.count- peripheralErrorArray.count-peripheralOutTimeArray.count,peripheralErrorArray.count,peripheralOutTimeArray.count]];
            //        if (peripheralErrorArray.count==0) {//失败0
            //            [markStr appendFormat:@"%@", [NSString stringWithFormat:@"成功:%ld,失败:%ld\n\n\n",peripheralDataArray.count- peripheralErrorArray.count,peripheralErrorArray.count]];
            //        }else{
            //            [markStr appendFormat:@"%@", [NSString stringWithFormat:@"成功:%ld,失败:%ld(%@)\n\n\n",peripheralDataArray.count- peripheralErrorArray.count,peripheralErrorArray.count,[peripheralErrorArray componentsJoinedByString:@","]]];
            //        }
            
            [self updateMarkTextView];
            [fujianArray removeAllObjects];
#pragma mark-- 处理复检数组（超时+失败）
            for (CBPeripheral* per in peripheralErrorArray) {
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                dic[@"peripheral"]=per;
                [fujianArray addObject:dic];
                
            }
            [fujianArray addObjectsFromArray:peripheralOutTimeArray];
            [peripheralErrorArray removeAllObjects];
            [peripheralOutTimeArray removeAllObjects];
            
        }else{
            SSLog(@"完成情况:%ld/%ld",index,peripheralDataArray.count);
            self.title=[NSString stringWithFormat:@"完成情况:%ld/%ld",index,peripheralDataArray.count];
            [MBProgressHUD HUDForView:self.navigationController.view].progress = (index)/(float)peripheralDataArray.count;
//            if ([self.buttonState isEqualToString:@"-1"]) {
//                [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"设置颜色..."];
//            }
//            else if ([self.buttonState isEqualToString:@"0"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"校正时间..."];
//            }else if ([self.buttonState isEqualToString:@"1"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"二次检测..."];
//            }else if ([self.buttonState isEqualToString:@"2"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"A1检测..."];
//            }else if ([self.buttonState isEqualToString:@"3"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"open全开检测..."];
//            }else if ([self.buttonState isEqualToString:@"4"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"颜色轮变检测..."];
//            }else if ([self.buttonState isEqualToString:@"5"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"数码管检测..."];
//            }else if ([self.buttonState isEqualToString:@"6"])
//            {
//                [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"恢复出厂检测..."];
//            }
            
            [self connectPeripheral:peripheralDataArray[index]];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(connectErrorClick) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
    
}

#pragma mark-- 连接设备失败、断开连接
-(void)chuliyichang:(NSString* )name
{
    if ([disconnectIdentifier isEqualToString:@"2"]) {//设备主动断开
        if ([self.fujianIdentifier isEqualToString:@"1"]) {
            CBPeripheral *peripheral=fujianArray[index][@"peripheral"];
            [peripheralErrorArray addObject:peripheral];
            
        }else{
            CBPeripheral *peripheral=peripheralDataArray[index][@"peripheral"];
            [peripheralErrorArray addObject:peripheral];
            
        }
    }
    [self cancelNotifyPeripheral];
    [self connectNextPeripheral];
}

#pragma mark-- 连接设备超时的处理
-(void)connectErrorClick
{
    SSLog(@"连接超时");
    [self stopTime];
    disconnectIdentifier=@"1";
    if ([self.fujianIdentifier isEqualToString:@"1"]) {
        CBPeripheral *peripheral=fujianArray[index][@"peripheral"];
        [peripheralOutTimeArray addObject:fujianArray[index]];
        [baby cancelPeripheralConnection:peripheral];
        
    }else{
        CBPeripheral *peripheral=peripheralDataArray[index][@"peripheral"];
        [peripheralOutTimeArray addObject:peripheralDataArray[index]];
        [baby cancelPeripheralConnection:peripheral];
    }
    
}

#pragma mark-- 处理蓝牙信道不通(废弃)
-(void)connectStartToWriteClick
{
    [self stopTime];
    disconnectIdentifier=@"1";
    if ([self.fujianIdentifier isEqualToString:@"1"]) {
        CBPeripheral *peripheral=fujianArray[index][@"peripheral"];
        [peripheralErrorArray addObject:peripheral];
        [baby cancelPeripheralConnection:peripheral];
        
    }else{
        CBPeripheral *peripheral=peripheralDataArray[index][@"peripheral"];
        [peripheralErrorArray addObject:peripheral];
        [baby cancelPeripheralConnection:peripheral];
    }
    
}

#pragma mark-- 连接设备
-(void)connectPeripheral:(NSDictionary *)dic
{
    CBPeripheral* peripheral=dic[@"peripheral"];
    baby.having(peripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
//    baby.having(peripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().begin();
}

-(void)loadViews
{
    markScroll=[[UIScrollView alloc]init];
    markScroll.frame=CGRectMake(10, ViewHeaderHeight, KScreen.width-20, KScreen.height-ViewHeaderHeight-200);
    [self.view addSubview:markScroll];
    
    UITextView* textV=[[UITextView alloc]init];
//    textV.frame=CGRectMake(10, ViewHeaderHeight, KScreen.width-20, KScreen.height-ViewHeaderHeight-200);
    textV.frame=CGRectMake(0, 0, KScreen.width-20, markScroll.height);
    textV.font=NameFont(16);
    textV.textColor=NameColour;
    textV.editable=NO;
    textV.scrollEnabled=NO;
    textV.backgroundColor=BgColour;
    [markScroll addSubview:textV];
    markText=textV;
    
    CGFloat btnW=KScreen.width/3;
    
    UIButton* btn1=[[UIButton alloc]init];
    btn1.frame=CGRectMake(10, KScreen.height-180, btnW-20, 40);
    [btn1 setTitle:@"校正时间" forState:(UIControlStateNormal)];
    btn1.titleLabel.font=NameFont(16);
    [btn1 setTitleColor:ColorWith(50, 190, 140, 1) forState:(UIControlStateNormal)];
    btn1.borderWidth=1;
    btn1.borderColor=ColorWith(50, 190, 140, 1);
    [btn1 addTarget:self action:@selector(jiaozhengTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn1];
    
    UIButton* btn2=[[UIButton alloc]init];
    btn2.frame=CGRectMake(10+btnW, KScreen.height-60, btnW-20, 40);
    [btn2 setTitle:@"二次时间" forState:(UIControlStateNormal)];
    btn2.titleLabel.font=NameFont(16);
    [btn2 setTitleColor:ColorWith(50, 190, 140, 1) forState:(UIControlStateNormal)];
    btn2.borderWidth=1;
    btn2.borderColor=ColorWith(50, 190, 140, 1);
    [btn2 addTarget:self action:@selector(erciTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn2];
    //10+btnW, KScreen.height-180, btnW-20, 40
    
    UIButton* btn3=[[UIButton alloc]init];
    btn3.frame=CGRectMake(10+btnW, KScreen.height-180, btnW-20, 40);
    //10+btnW*2, KScreen.height-180, btnW-20, 40
    [btn3 setTitle:@"A1命令" forState:(UIControlStateNormal)];
    btn3.titleLabel.font=NameFont(16);
    [btn3 setTitleColor:ColorWith(50, 190, 140, 1) forState:(UIControlStateNormal)];
    btn3.borderWidth=1;
    btn3.borderColor=ColorWith(50, 190, 140, 1);
    [btn3 addTarget:self action:@selector(a1Click) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn3];
    
    
    UIButton* btn4=[[UIButton alloc]init];
    btn4.frame=CGRectMake(10, KScreen.height-120, btnW-20, 40);
    //10, KScreen.height-120, btnW-20, 40
    [btn4 setTitle:@"open开" forState:(UIControlStateNormal)];
    btn4.titleLabel.font=NameFont(16);
    [btn4 setTitleColor:ColorWith(50, 190, 140, 1) forState:(UIControlStateNormal)];
    btn4.borderWidth=1;
    btn4.borderColor=ColorWith(50, 190, 140, 1);
    [btn4 addTarget:self action:@selector(ledOpenClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn4];
    
    UIButton* btn5=[[UIButton alloc]init];
    btn5.frame=CGRectMake(10+btnW*2, KScreen.height-180, btnW-20, 40);
    //10+btnW, KScreen.height-120, btnW-20, 40
    [btn5 setTitle:@"颜色轮变" forState:(UIControlStateNormal)];
    btn5.titleLabel.font=NameFont(16);
    [btn5 setTitleColor:ColorWith(50, 190, 140, 1) forState:(UIControlStateNormal)];
    btn5.borderWidth=1;
    btn5.borderColor=ColorWith(50, 190, 140, 1);
    [btn5 addTarget:self action:@selector(ledCloseClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn5];
    
    UIButton* btn6=[[UIButton alloc]init];
    btn6.frame=CGRectMake(10+btnW, KScreen.height-120, btnW-20, 40);
    //10+btnW*2, KScreen.height-120, btnW-20, 40
    [btn6 setTitle:@"数码管" forState:(UIControlStateNormal)];
    btn6.titleLabel.font=NameFont(16);
    [btn6 setTitleColor:ColorWith(50, 190, 140, 1) forState:(UIControlStateNormal)];
    btn6.borderWidth=1;
    btn6.borderColor=ColorWith(50, 190, 140, 1);
    [btn6 addTarget:self action:@selector(shumaguanClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn6];
    
    UIButton* btn7=[[UIButton alloc]init];
    btn7.frame=CGRectMake(10+btnW*2, KScreen.height-120, btnW-20, 40);
    [btn7 setTitle:@"恢复出厂" forState:(UIControlStateNormal)];
    btn7.titleLabel.font=NameFont(16);
    [btn7 setTitleColor:ColorWith(50, 190, 140, 1) forState:(UIControlStateNormal)];
    btn7.borderWidth=1;
    btn7.borderColor=ColorWith(50, 190, 140, 1);
    [btn7 addTarget:self action:@selector(resetClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn7];
    
    UIView* lineView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreen.height-190, KScreen.width, 1)];
    lineView.backgroundColor=ColorWith(50, 190, 140, 1);
    [self.view addSubview:lineView];
}

#pragma mark-- 校正时间
-(void)jiaozhengTimeClick
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:[NSString stringWithFormat:@"是否执行校正时间？"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self jiaozhengTimeClickClick];
        
    }];
    UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alertVC addAction:OKAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

-(void)jiaozhengTimeClickClick
{
    self.buttonState=@"0";
    self.fujianIdentifier=@"0";
    [self connectFirstPeripheral];
//    [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"校正时间..."];
    [self startHudWithTitle:@"校正时间..."];
    [MBProgressHUD HUDForView:self.navigationController.view].progress = (index)/(float)peripheralDataArray.count;
    [markStr appendFormat:@"校正时间:\n"];
    [self updateMarkTextView];
    SSLog(@"校正时间...%ld/%ld",index,peripheralDataArray.count);
}

#pragma mark-- 二次校正时间
-(void)erciTimeClick
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:[NSString stringWithFormat:@"是否执行二次校正时间?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self erciTimeClickClick];
        
    }];
    UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alertVC addAction:OKAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)erciTimeClickClick
{
    self.buttonState=@"1";
    self.fujianIdentifier=@"0";
    [self connectFirstPeripheral];
//    [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"二次检测..."];
    [self startHudWithTitle:@"二次检测..."];
    [MBProgressHUD HUDForView:self.navigationController.view].progress = (index)/(float)peripheralDataArray.count;
    [markStr appendFormat:@"二次检测:\n"];
    [self updateMarkTextView];
    SSLog(@"二次检测...%ld/%ld",index,peripheralDataArray.count);
}

#pragma mark-- A1命令
-(void)a1Click
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:[NSString stringWithFormat:@"是否执行A1命令？"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self a1ClickClick];
        
    }];
    UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alertVC addAction:OKAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)a1ClickClick
{
    self.buttonState=@"2";
    self.fujianIdentifier=@"0";
    [self connectFirstPeripheral];
//    [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"A1检测..."];
    [self startHudWithTitle:@"A1检测..."];
    [MBProgressHUD HUDForView:self.navigationController.view].progress = (index)/(float)peripheralDataArray.count;
    [markStr appendFormat:@"A1检测:\n"];
    [self updateMarkTextView];
    SSLog(@"A1检测...%ld/%ld",index,peripheralDataArray.count);
}

#pragma mark-- open开
-(void)ledOpenClick
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:[NSString stringWithFormat:@"是否执行open开？"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self ledOpenClickClick];
        
    }];
    UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alertVC addAction:OKAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)ledOpenClickClick
{
    self.buttonState=@"3";
    self.fujianIdentifier=@"0";
    [self connectFirstPeripheral];
//    [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"open全开检测..."];
    [self startHudWithTitle:@"open全开检测.."];
    [MBProgressHUD HUDForView:self.navigationController.view].progress = (index)/(float)peripheralDataArray.count;
    [markStr appendFormat:@"open全开检测:\n"];
    [self updateMarkTextView];
    SSLog(@"open全开检测...%ld/%ld",index,peripheralDataArray.count);
}

#pragma mark-- open关
-(void)ledCloseClick
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:[NSString stringWithFormat:@"是否执行颜色轮变？"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self ledCloseClickClick];
        
    }];
    UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alertVC addAction:OKAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)ledCloseClickClick
{
    self.buttonState=@"4";
    self.fujianIdentifier=@"0";
    [self connectFirstPeripheral];
//    [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"颜色轮变检测..."];
    [self startHudWithTitle:@"颜色轮变检测.."];
    [MBProgressHUD HUDForView:self.navigationController.view].progress = (index)/(float)peripheralDataArray.count;
    [markStr appendFormat:@"颜色轮变检测:\n"];
    [self updateMarkTextView];
    SSLog(@"颜色轮变检测...%ld/%ld",index,peripheralDataArray.count);
}

#pragma mark-- 数码管
-(void)shumaguanClick
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:[NSString stringWithFormat:@"是否执行数码管检测？"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self shumaguanClickClick];
        
    }];
    UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alertVC addAction:OKAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)shumaguanClickClick
{
    self.buttonState=@"5";
    self.fujianIdentifier=@"0";
    [self connectFirstPeripheral];
//    [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"数码管检测..."];
    [self startHudWithTitle:@"数码管检测.."];
    [MBProgressHUD HUDForView:self.navigationController.view].progress = (index)/(float)peripheralDataArray.count;
    [markStr appendFormat:@"数码管检测:\n"];
    [self updateMarkTextView];
    SSLog(@"数码管检测...%ld/%ld",index,peripheralDataArray.count);
}

#pragma mark-- 恢复出厂设置
-(void)resetClick
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:[NSString stringWithFormat:@"是否执行恢复出厂设置？"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self resetClickClick];
        
    }];
    UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alertVC addAction:OKAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)resetClickClick
{
    self.buttonState=@"6";
    self.fujianIdentifier=@"0";
    [self connectFirstPeripheral];
//    [SVProgressHUD showProgress:(index)/(float)peripheralDataArray.count status:@"恢复出厂检测..."];
    [self startHudWithTitle:@"恢复出厂检测.."];
    [MBProgressHUD HUDForView:self.navigationController.view].progress = (index)/(float)peripheralDataArray.count;
    [markStr appendFormat:@"恢复出厂检测:\n"];
    [self updateMarkTextView];
    SSLog(@"恢复出厂检测...%ld/%ld",index,peripheralDataArray.count);
}

#pragma mark-- 发送指令
-(void)sendMessage:(NSString* )message
{
    SSLog(@"发送指令%@",message);
    NSLog(@"发送指令----%@",message);
    disconnectIdentifier=@"2";
    [self startDingShiQi];//发送指令定时器
    self.receiveStr=@"";
    NSData* data=[self hexToBytes:message];
    [self.wriPeripheral writeValue:data forCharacteristic:self.wriCharacteristic type:CBCharacteristicWriteWithResponse];
}


-(void)chuliperipheral:(CBPeripheral* )peripheral characteristic:(CBCharacteristic* )characteristics
{
    [baby notify:peripheral characteristic:characteristics block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        
        NSLog(@"监听通知======");
//        NSString * str  =[[NSString alloc] initWithData:characteristics.value encoding:NSUTF8StringEncoding];
        NSLog(@"new value %@",[self hexadecimalString:characteristics.value]);
        NSString* str=[self hexadecimalString:characteristics.value];
        SSLog(@"%@",str);
        //断包处理
        if (!([str hasPrefix:@"aa5555aa"] && [str hasSuffix:@"c33c"])) {
            self.receiveStr=[NSString stringWithFormat:@"%@%@",self.receiveStr,str];
            if ([self.receiveStr hasPrefix:@"aa5555aa"] && [self.receiveStr hasSuffix:@"c33c"]) {
                [self chuliData:self.receiveStr];
            }else{
                
            }
        }else{
            [self chuliData:str];

        }
        
    }];
}

#pragma mark-- 处理数据
-(void)chuliData:(NSString* )str
{
    [self stopTime];
    disconnectIdentifier=@"1";
    NSLog(@"****处理好的数据***%@",str);
    SSLog(@"**%@",str);
    self.receiveStr=@"";
    if ([self.buttonState isEqualToString:@"-1"]) {
        if (str.length==26) {
            NSString *temStr = [str substringWithRange:NSMakeRange(20,2)];
            if ([temStr isEqualToString:@"96"]) {
                //            [SVProgressHUD dismiss];
                [baby cancelPeripheralConnection:self.notiPeripheral];
            }else{
                [baby cancelPeripheralConnection:self.notiPeripheral];
                [peripheralErrorArray addObject:self.notiPeripheral];
            }
        }else{//回执错误
            NSLog(@"回执错误------%@",str);
            [baby cancelPeripheralConnection:self.notiPeripheral];
            [peripheralErrorArray addObject:self.notiPeripheral];
        }
    }
    if ([self.buttonState isEqualToString:@"0"]) {//校正时间
        if ([self.timeState isEqualToString:@"0"]) {
            if (str.length==26) {
                self.timeState=@"1";
               [self sendMessage:@"aa5555aa000000b8b102030001010101c33c"];
                
            }else{//回执错误
                NSLog(@"回执错误------%@",str);
//                self.timeState=@"0";
                self.timeState=@"2";
                [self sendMessage:@"aa5555aa000000b8b102030000000000c33c"];
                [peripheralErrorArray addObject:self.notiPeripheral];
            }
        }
        else if ([self.timeState isEqualToString:@"1"]){//发绿色命令
            self.timeState=@"0";
            if (str.length==26) {
                NSString *temStr = [str substringWithRange:NSMakeRange(20,2)];
                if ([temStr isEqualToString:@"96"]) {
                    //            [SVProgressHUD dismiss];
                    [baby cancelPeripheralConnection:self.notiPeripheral];
                }else{
                    [baby cancelPeripheralConnection:self.notiPeripheral];
                    [peripheralErrorArray addObject:self.notiPeripheral];
                }
            }else{//回执错误
                NSLog(@"回执错误------%@",str);
                [baby cancelPeripheralConnection:self.notiPeripheral];
                [peripheralErrorArray addObject:self.notiPeripheral];
            }
        }else if ([self.timeState isEqualToString:@"2"]){//发红色命令回复
            self.timeState=@"0";
            [baby cancelPeripheralConnection:self.notiPeripheral];
            
        }
        
    }
    if ([self.buttonState isEqualToString:@"1"]) {//二次检测
        if ([self.timeState isEqualToString:@"0"]) {
            if (str.length==38) {
                self.timeState=@"1";
                NSString *temStr = [str substringWithRange:NSMakeRange(20,14)];
                [self chulierciTime:temStr];
            }else{
                [baby cancelPeripheralConnection:self.notiPeripheral];
                [peripheralErrorArray addObject:self.notiPeripheral];
            }
        }else if ([self.timeState isEqualToString:@"1"]){//收粉色颜色命令
            self.timeState=@"0";
            if (str.length==26) {
                NSString *temStr = [str substringWithRange:NSMakeRange(20,2)];
                if ([temStr isEqualToString:@"96"]) {
                    //            [SVProgressHUD dismiss];
                    [baby cancelPeripheralConnection:self.notiPeripheral];
                }else{
                    [baby cancelPeripheralConnection:self.notiPeripheral];
                    [peripheralErrorArray addObject:self.notiPeripheral];
                }
            }else{//回执错误
                NSLog(@"回执错误------%@",str);
                [baby cancelPeripheralConnection:self.notiPeripheral];
                [peripheralErrorArray addObject:self.notiPeripheral];
            }
            
        }else if ([self.timeState isEqualToString:@"2"]){//收白色颜色命令
            self.timeState=@"0";
            [baby cancelPeripheralConnection:self.notiPeripheral];
            [peripheralErrorArray addObject:self.notiPeripheral];
        }
        
        
    }
    if ([self.buttonState isEqualToString:@"2"]) {//a1检测
//        [SVProgressHUD dismiss];
        if (str.length==36) {
            [self sendMessage:@"aa5555aa000000b8b102000001010101c33c"];
        }else{
            if (str.length==26) {
                NSString *temStr = [str substringWithRange:NSMakeRange(20,2)];
                if ([temStr isEqualToString:@"96"]) {
                    //            [SVProgressHUD dismiss];
                    [baby cancelPeripheralConnection:self.notiPeripheral];
                }else{
                    [baby cancelPeripheralConnection:self.notiPeripheral];
                    [peripheralErrorArray addObject:self.notiPeripheral];
                }
            }else{//回执错误
                NSLog(@"回执错误------%@",str);
                [baby cancelPeripheralConnection:self.notiPeripheral];
                [peripheralErrorArray addObject:self.notiPeripheral];
            }
//            [baby cancelPeripheralConnection:self.notiPeripheral];
        }
        
    }
    if ([self.buttonState isEqualToString:@"3"]) {//open开检测
//        [SVProgressHUD dismiss];
        if (str.length==26) {
            //            [self sendMessage:@"aa5555aa000000b8b102000001010101c33c"];
            NSString *temStr = [str substringWithRange:NSMakeRange(20,2)];
            if ([temStr isEqualToString:@"96"]) {
                //            [SVProgressHUD dismiss];
                [baby cancelPeripheralConnection:self.notiPeripheral];
            }else{
                [baby cancelPeripheralConnection:self.notiPeripheral];
                [peripheralErrorArray addObject:self.notiPeripheral];
            }
        }else{//回执错误
            NSLog(@"回执错误------%@",str);
            [baby cancelPeripheralConnection:self.notiPeripheral];
            [peripheralErrorArray addObject:self.notiPeripheral];
        }
    }
    if ([self.buttonState isEqualToString:@"4"]) {//open关检测
//        [SVProgressHUD dismiss];
        if (str.length==26) {
//            [self sendMessage:@"aa5555aa000000b8b102000001010101c33c"];
            NSString *temStr = [str substringWithRange:NSMakeRange(20,2)];
            if ([temStr isEqualToString:@"96"]) {
                //            [SVProgressHUD dismiss];
                [baby cancelPeripheralConnection:self.notiPeripheral];
            }else{
                [baby cancelPeripheralConnection:self.notiPeripheral];
                [peripheralErrorArray addObject:self.notiPeripheral];
            }
        }else{//回执错误
            NSLog(@"回执错误------%@",str);
            [baby cancelPeripheralConnection:self.notiPeripheral];
            [peripheralErrorArray addObject:self.notiPeripheral];
        }
        
    }
    if ([self.buttonState isEqualToString:@"5"]) {//数码管检测
//        [SVProgressHUD dismiss];
        if (str.length==26) {
            //            [self sendMessage:@"aa5555aa000000b8b102000001010101c33c"];
            NSString *temStr = [str substringWithRange:NSMakeRange(20,2)];
            if ([temStr isEqualToString:@"96"]) {
                //            [SVProgressHUD dismiss];
                [baby cancelPeripheralConnection:self.notiPeripheral];
            }else{
                [baby cancelPeripheralConnection:self.notiPeripheral];
                [peripheralErrorArray addObject:self.notiPeripheral];
            }
        }else{//回执错误
            NSLog(@"回执错误------%@",str);
            [baby cancelPeripheralConnection:self.notiPeripheral];
            [peripheralErrorArray addObject:self.notiPeripheral];
        }
        
    }
    if ([self.buttonState isEqualToString:@"6"]) {//恢复出厂设置
//        [SVProgressHUD dismiss];
        if (str.length==26) {
            //            [self sendMessage:@"aa5555aa000000b8b102000001010101c33c"];
            NSString *temStr = [str substringWithRange:NSMakeRange(20,2)];
            if ([temStr isEqualToString:@"96"]) {
                //            [SVProgressHUD dismiss];
                [baby cancelPeripheralConnection:self.notiPeripheral];
            }else{
                [baby cancelPeripheralConnection:self.notiPeripheral];
                [peripheralErrorArray addObject:self.notiPeripheral];
            }
        }else{//回执错误
            NSLog(@"回执错误------%@",str);
            [baby cancelPeripheralConnection:self.notiPeripheral];
            [peripheralErrorArray addObject:self.notiPeripheral];
        }
        
    }
    
}

#pragma mark-- 处理校正时间(废弃)
-(void)chuliTime:(NSString* )time
{

    NSLog(@"---%@",[self convertHexStrToString:time]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmss"];
    NSDate *date = [dateFormatter dateFromString:[self convertHexStrToString:time]];
//    NSDate *date = [dateFormatter dateFromString:@"180724110146"];
    NSLog(@"=====%@",date);
    NSTimeInterval intervalNow = [date timeIntervalSinceNow];
    NSLog(@"距离当前多少秒---%f",intervalNow);
    double panduanTime=fabs(intervalNow);
    if (panduanTime>5) {//时钟不正常
        [self sendMessage:@"aa5555aa000000b8b102030007070707c33c"];
//        [peripheralErrorArray addObject:self.notiPeripheral];
    }else{
        [self sendMessage:@"aa5555aa000000b8b102030001010101c33c"];
    }
}

#pragma mark-- 处理二次校正时间
-(void)chulierciTime:(NSString* )time
{
    NSLog(@"---%@",[self convertHexStrToString:time]);
//    NSMutableString* ercitime=[[NSMutableString alloc]initWithString:[self convertHexStrToString:time]];
//    [ercitime insertString:@":" atIndex:8];
//    [ercitime insertString:@":" atIndex:11];
//    [ercitime insertString:@" " atIndex:6];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
//    [dateFormatter setLocale:locale];
    NSDate *date = [dateFormatter dateFromString:[self convertHexStrToString:time]];
    NSLog(@"===设备时间:%@",[dateFormatter stringFromDate:date]);
    NSLog(@"===当前时间:%@",[dateFormatter stringFromDate:[NSDate date]]);
    SSLog(@"===设备时间:%@",[dateFormatter stringFromDate:date]);
    SSLog(@"===当前时间:%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSTimeInterval intervalNow = [date timeIntervalSinceNow];
    NSLog(@"距离当前多少秒---%f",intervalNow);
    double panduanTime=fabs(intervalNow);
    int erci=[[UserDefaultUtil valueForKey:@"erci"] intValue];
    if (panduanTime>(double)(erci?erci:5)) {//时钟不正常
        self.timeState=@"2";
        [self sendMessage:@"aa5555aa000000b8b102030002020202c33c"];
//        [peripheralErrorArray addObject:self.notiPeripheral.name];
    }else{
        self.timeState=@"1";
        [self sendMessage:@"aa5555aa000000b8b102030006060606c33c"];
    }
}

#pragma mark-- 定时器停止
- (void)stopTime{
    if (self.timer) {
        if ([self.timer respondsToSelector:@selector(isValid)]){
            if ([self.timer isValid]){
                [self.timer invalidate];
            }
        }
    }
}

#pragma mark-- 更新记录框内容
-(void)updateMarkTextView
{
    markText.text=nil;
    markText.text=markStr;
//    CGSize size=[self sizeWithText:markStr font:NameFont(16) maxSize:CGSizeMake(KScreen.width-20, MAXFLOAT)];
//    if (size.height>markScroll.height) {
//        markScroll.contentSize=CGSizeMake(0, size.height+40);
//        markText.height=size.height+100;
//        markScroll.contentOffset=CGPointMake(0, size.height+40-markScroll.height);
//    }
    
    CGSize sizeToFit = [markText sizeThatFits:CGSizeMake(KScreen.width-20, MAXFLOAT)];
    if (sizeToFit.height>markScroll.height) {
        markScroll.contentSize=CGSizeMake(0, sizeToFit.height);
        markText.height=sizeToFit.height;
        markScroll.contentOffset=CGPointMake(0, sizeToFit.height-markScroll.height);
    }
    
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark-- 工具包

#pragma mark-- 加载hud
-(void)startHudWithTitle:(NSString* )title
{
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.backgroundView.backgroundColor=ColorWith(15, 15, 15, 0.6);
    hud.label.text = title;
    [hud.button setTitle:@"下一个" forState:UIControlStateNormal];
    [hud.button addTarget:self action:@selector(cancelWork:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark-- 点击hud按钮进行下一个操作
-(void)cancelWork:(UIButton* )button
{
    [self stopTime];
    disconnectIdentifier=@"1";
    if ([self.fujianIdentifier isEqualToString:@"1"]) {
        if (index<fujianArray.count) {
            CBPeripheral *peripheral=fujianArray[index][@"peripheral"];
            [peripheralErrorArray addObject:peripheral];
            [baby cancelPeripheralConnection:peripheral];
        }
    }else{
        if (index<peripheralDataArray.count) {
            CBPeripheral *peripheral=peripheralDataArray[index][@"peripheral"];
            [peripheralErrorArray addObject:peripheral];
            [baby cancelPeripheralConnection:peripheral];
        }
    }
}

//将传入的NSData类型转换成NSString并返回
- (NSString*)hexadecimalString:(NSData *)data{
    
    NSString* result;
    
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    
    if(!dataBuffer){
        
        return nil;
        
    }
    
    NSUInteger dataLength = [data length];
    
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for(int i = 0; i < dataLength; i++){
        
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
        
    }
    
    result = [NSString stringWithString:hexString];
    
    return result;
}

#pragma mark-- 解析时间
- (NSString *)convertHexStrToString:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    NSString* printStr=@"";
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        
        NSString *hexCharStr = [str substringWithRange:range];
        if (i!=6) {
           printStr = [printStr stringByAppendingFormat:@"%02lu", strtoul([hexCharStr UTF8String],0,16)];
        }
        
        range.location += range.length;
        range.length = 2;
    }
    
    return printStr;
}

//把16进制字符串转换成NSData
-(NSData *)hexString:(NSString *)hexString {
    int j=0;
    Byte bytes[20];
    ///3ds key的Byte 数组， 128位
    for(int i=0; i<[hexString length]; i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
//        NSLog(@"int_ch=%d",int_ch);
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:20];
    
    return newData;
}

#pragma mark-- 获取当前时间的16进制字符
-(NSString* )getHexStringFromYearMonth{
    
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yy"];
//    NSLog(@"-----%@",[formatter stringFromDate:date]);
    NSString* year=[self getHexByDecimal:[[formatter stringFromDate:date] integerValue]];
    [formatter setDateFormat:@"MM"];
//    NSLog(@"-----%@",[formatter stringFromDate:date]);
    NSString* month=[self getHexByDecimal:[[formatter stringFromDate:date] integerValue]];
    [formatter setDateFormat:@"dd"];
//    NSLog(@"-----%@",[formatter stringFromDate:date]);
    NSString* day=[self getHexByDecimal:[[formatter stringFromDate:date] integerValue]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:date];
    NSArray * arrWeek=[NSArray arrayWithObjects:[NSNull null],@"07",@"01",@"02",@"03",@"04",@"05",@"06", nil];
//    NSLog(@"-----%@",[arrWeek objectAtIndex:[comps weekday]]);
    NSString* week=[self getHexByDecimal:[[arrWeek objectAtIndex:[comps weekday]] integerValue]];
    
    [formatter setDateFormat:@"HH"];
//    NSLog(@"-----%@",[formatter stringFromDate:date]);
    NSString* hour=[self getHexByDecimal:[[formatter stringFromDate:date] integerValue]];
    [formatter setDateFormat:@"mm"];
//    NSLog(@"-----%@",[formatter stringFromDate:date]);
    NSString* miniter=[self getHexByDecimal:[[formatter stringFromDate:date] integerValue]];
    [formatter setDateFormat:@"ss"];
//    NSLog(@"-----%@",[formatter stringFromDate:date]);
    NSString* sed=[self getHexByDecimal:[[formatter stringFromDate:date] integerValue]];
//    NSLog(@"%@%@%@%@%@%@%@",year,month,day,week,hour,miniter,sed);
    return [NSString stringWithFormat:@"%@%@%@%@%@%@%@",year,month,day,week,hour,miniter,sed];
}

//字符串转换16进制：
- (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    if ([hex length]==2) {
        return hex;
    }else{
        return [NSString stringWithFormat:@"0%@",hex];
    }
}

//16进制字符串转byte格式
-(NSData*) hexToBytes:(NSString *)str{
    
    NSMutableData* data = [NSMutableData data];
    
    int idx;
    
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        
        NSRange range = NSMakeRange(idx, 2);
        
        NSString* hexStr = [str substringWithRange:range];
        
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        
        unsigned int intValue;
        
        [scanner scanHexInt:&intValue];
        
        [data appendBytes:&intValue length:1];
        
    }
    
    return data;
    
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
