//
//  XMRTimePiker.m
//  时间选择器
//
//  Created by xiaxing on 16/7/19.
//  Copyright © 2016年 xiaxing. All rights reserved.
//

#import "XMRTimePiker.h"

#define selfGreen [UIColor colorWithRed:69/255.0 green:181/255.0 blue:55/255.0 alpha:0.8]
//iPhone 6
#define self6WidthRate [UIScreen mainScreen].bounds.size.width/375.0

#define selfBacground [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]

#define selfWidth [UIScreen mainScreen].bounds.size.width

#define selfHeight [UIScreen mainScreen].bounds.size.height

#define selfWidthRate [UIScreen mainScreen].bounds.size.width/320.0

#define selfHeightRate [UIScreen mainScreen].bounds.size.height/568.0

#define self6WidthRate [UIScreen mainScreen].bounds.size.width/375.0

#define self6HeightRate [UIScreen mainScreen].bounds.size.height/667.0
//颜色16进制
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

#define XMRECT6(rect) CGRectMake(rect.origin.x*self6WidthRate, rect.origin.y*self6HeightRate, rect.size.width*self6WidthRate, rect.size.height*self6HeightRate)

#define XMRECT(rect) CGRectMake(rect.origin.x*selfWidthRate, rect.origin.y*selfHeightRate, rect.size.width*selfWidthRate, rect.size.height*selfHeightRate)

@implementation XMRTimePiker{
    
    //    row
    NSInteger left0_row;
    NSInteger left1_row;
    NSInteger right0_row;
    NSInteger right1_row;
    // pickerView
    
    UIPickerView * _pickerView_left;
    // pickerView
    
    UIPickerView * _pickerView_right;
    // 小时
    
    NSArray * _hours_Arr;
    // 分钟
    NSArray * _min_arr;
   
}

-(instancetype)init{
    
   self=[super init];
    
    if (self) {
        
        _hours_Arr=@[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
        
        _min_arr=@[@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"];
        
        self.frame=CGRectMake(0, selfHeight, selfWidth, selfHeight);
        self.backgroundColor=ColorWith(0, 0, 0, 0.7);
        [self createUI];
    }

    return self;

}

-(void)createUI{

    // 背景白色View
    
    UIView * white_view=[[UIView alloc]initWithFrame:XMRECT6(CGRectMake(50, 220,375-100, 300))];
    
    white_view.backgroundColor=[UIColor whiteColor];
    
    white_view.layer.cornerRadius=10;
    
    [self addSubview:white_view];
    
    //选择时间标题
    
    UILabel * title_label=[[UILabel alloc]initWithFrame:XMRECT6(CGRectMake((275-150)/2, 21, 150, 30))];
    
    title_label.text=@"Select a time";
    
    title_label.textColor=UIColorFromRGB(0x383838);
    
    title_label.textAlignment=NSTextAlignmentCenter;
    
    [white_view addSubview:title_label];
    //营业时间和打烊时间标题
    
    for (int i=0; i<2; i++) {
        
        UILabel * label=[[UILabel alloc]initWithFrame:XMRECT6(CGRectMake(30+116*i, 60, 100, 30))];
        
        label.font=[UIFont systemFontOfSize:14];
        
        label.textColor=UIColorFromRGB(0x383838);
        
        label.textAlignment=NSTextAlignmentCenter;
        
        [white_view addSubview:label];
        
        if (i==0) {
            
            label.text=@"Open time";
            
        }else{
            
            label.text=@"Close time";
        }
        
    }
    //   分割线
    
    UILabel * button_line=[[UILabel alloc]initWithFrame:CGRectMake(0, 250*self6HeightRate, 275*self6WidthRate, 1)];
    
    button_line.backgroundColor=selfBacground;
    
    [white_view addSubview:button_line];
    
    
    //  选择营业时间
    
    //                    _pickerView_left=[[UIPickerView alloc]initWithFrame:XMRECT6(CGRectMake(20,80, 275-40,150))];
    
    _pickerView_left=[[UIPickerView alloc]initWithFrame:XMRECT6(CGRectMake(30,100,100,130))];
    
    _pickerView_left.delegate=self;
    
    _pickerView_left.dataSource=self;
    
    _pickerView_left.backgroundColor=UIColorFromRGB(0xfbfbfb);
    
    [white_view addSubview:_pickerView_left];
    
    
    _pickerView_right=[[UIPickerView alloc]initWithFrame:XMRECT6(CGRectMake(140,100,100,130))];
    
    _pickerView_right.delegate=self;
    
    _pickerView_right.dataSource=self;
    
    _pickerView_right.backgroundColor=UIColorFromRGB(0xfbfbfb);
    
    [white_view addSubview:_pickerView_right];
    
    //   选中的背景图绿色
    
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:(CGRectMake(30*self6WidthRate,152*self6HeightRate,2,26))];
    
    [imageView setImage:[UIImage imageNamed:@"bjzsx"]];
    
    [white_view addSubview:imageView];
    
    UILabel * green_dian=[[UILabel alloc]initWithFrame:XMRECT(CGRectMake(70, 125,30,30))];
    
    green_dian.text=@":";
    
    green_dian.textColor=selfGreen;
    
    green_dian.font=[UIFont systemFontOfSize:14];
    
    [white_view addSubview:green_dian];
    
    
    //    选中背景图红色
    
    UIImageView * imageView_red=[[UIImageView alloc]initWithFrame:(CGRectMake(140*self6WidthRate,152*self6HeightRate,2,26))];
    
    [imageView_red setImage:[UIImage imageNamed:@"hbjzsx"]];
    
    [white_view addSubview:imageView_red];
    
    UILabel * red_dian=[[UILabel alloc]initWithFrame:XMRECT(CGRectMake(160, 125,30,30))];
    
    red_dian.text=@":";
    
    red_dian.textColor=[UIColor redColor];
    
    red_dian.font=[UIFont systemFontOfSize:14];
    
    [white_view addSubview:red_dian];
    
    //   取消和设置按钮
    
    for (int i=0; i<2; i++) {
        
        UIButton * button=[[UIButton alloc]initWithFrame:XMRECT6(CGRectMake(275/2*i,250,275/2, 50))];
        
        [button setTitleColor:selfGreen forState:UIControlStateNormal];
        
        [white_view addSubview:button];
        
        if (i==0) {
            
            [button setTitle:@"Cancel" forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
            
            
        }else{
            
            [button setTitle:@"Confirm" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //按钮分割线
    
    UILabel * bnt_line=[[UILabel alloc]initWithFrame:CGRectMake(275/2*self6WidthRate, 250*self6HeightRate , 1,50*self6HeightRate)];
    
    [bnt_line setBackgroundColor:selfBacground];
    
    [white_view addSubview:bnt_line];
    
}
-(void)cancel{

 [self removeFromSuperview];
    
}
-(void)timeClick{
    
    if ([[_hours_Arr objectAtIndex:[_pickerView_left selectedRowInComponent:0]]intValue]>=[[_hours_Arr objectAtIndex:[_pickerView_right selectedRowInComponent:0]]intValue]){
        
        if ([[_hours_Arr objectAtIndex:[_pickerView_left selectedRowInComponent:0]]intValue]>[[_hours_Arr objectAtIndex:[_pickerView_right selectedRowInComponent:0]]intValue]) {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Prompt" message:@"Time setting error" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil, nil];
            
            [alert show];
        }else{
            if ([[_min_arr objectAtIndex:[_pickerView_left selectedRowInComponent:1]] intValue]>=[[_min_arr objectAtIndex:[_pickerView_right selectedRowInComponent:1]] intValue]) {
                
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Prompt" message:@"Time setting error" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil, nil];
                
                [alert show];
            }else{
                
                [self time];
            }
        }
        
        
    }
    else{
        [self time];
    }
    
    
    [self removeFromSuperview];
}
-(void)time{
    
    if (_delegate&&[_delegate respondsToSelector:@selector(XMSelectTimesViewSetOneLeft:andOneRight:andTowLeft:andTowRight:)]) {
        
        NSString *OneLeft = [_hours_Arr objectAtIndex:[_pickerView_left selectedRowInComponent:0]];
        NSString *OneRight = [_min_arr objectAtIndex:[_pickerView_left selectedRowInComponent:1]];
        NSString *TowLeft = [_hours_Arr objectAtIndex:[_pickerView_right selectedRowInComponent:0]];
        NSString *TowRight = [_min_arr objectAtIndex:[_pickerView_right selectedRowInComponent:1]];
        
        [_delegate XMSelectTimesViewSetOneLeft:OneLeft andOneRight:OneRight andTowLeft:TowLeft andTowRight:TowRight];
        
    }
}

-(void)showTime{
    
    
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    
    self.frame=CGRectMake(0,0,selfWidth, selfHeight);
    
    [window addSubview:self];
    
//    self.frame=CGRectMake(0, selfHeight, selfWidth, selfHeight);
//    [UIView animateWithDuration:0.5 animations:^{
//
//        UIWindow * window=[UIApplication sharedApplication].keyWindow;
//
//        self.frame=CGRectMake(0,0,selfWidth, selfHeight);
//
//        [window addSubview:self];
//
//    } completion:^(BOOL finished) {
//
//
//    }];
}
- (void)SetOldShowTimeOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight andTowLeft:(NSString *)towLeft andTowRight:(NSString *)towRight {
    NSLog(@"oneLeft-%@ oneRight-%@ towLeft-%@ towRight-%@",oneLeft,oneRight,towLeft,towRight);

    for(int i=0; i<_hours_Arr.count; i++ ){
        if( [oneLeft isEqual: _hours_Arr[i]]){
            
            left0_row=i;
            
        }
    }
    for(int i=0; i<_hours_Arr.count; i++ ){
        if ([towLeft isEqual:_hours_Arr[i]]){
            
            right0_row=i;
            
        }
    }
        
//        if( [oneLeft isEqual: _hours_Arr[i]]){
//            
//            left0_row=i;
//            
//        }
//        else if ([towLeft isEqual:_hours_Arr[i]]){
//            
//            right0_row=i;
//            
//        }
    
    for (int j=0; j<_min_arr.count; j++) {
        
        if( [oneRight isEqual: _min_arr[j]]){
            
            left1_row=j;
            
        }
    }
    for (int j=0; j<_min_arr.count; j++) {
        
        if ([towRight isEqual:_min_arr[j]]){
            
            right1_row=j;
            
        }
    }
    [_pickerView_left selectRow:left0_row inComponent:0 animated:true];
    
    [_pickerView_left selectRow:left1_row inComponent:1 animated:true];
    
    [_pickerView_right selectRow:right0_row inComponent:0 animated:YES];
    
    [_pickerView_right selectRow:right1_row inComponent:1 animated:YES];
}
#pragma mark ========================================pikerViewdelegate====================
//一共多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
//每列对应多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _hours_Arr.count;
    } else if (component == 1) {
        return _min_arr.count;
    }else
    {
        return  0;
    }
    
    //    else {
    //        return self.townArray.count;
    //    }
}
//每列每行显示的数据是什么
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [_hours_Arr objectAtIndex:row];
    } else if (component == 1) {
        return [_min_arr objectAtIndex:row];
    }else{
        
        return 0;
    }
    
}
////组建的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 50*self6WidthRate;
    } else if (component == 1) {
        return 50*self6WidthRate;
    }else{
        
        return 0;
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView==_pickerView_left) {
        
        if (component==0) {
            
            left0_row=row;
            
            [_pickerView_left reloadComponent:0];
            
        }else{
            
            left1_row=row;
            
            [_pickerView_left reloadComponent:1];
            
        }
        
    } else if (pickerView==_pickerView_right){
        
        if (component==0) {
            
            right0_row=row;
            
            [_pickerView_right reloadComponent:0];
            
        }else{
            
            right1_row=row;
            
            [_pickerView_right reloadComponent:1];
            
        }
        
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumScaleFactor = 8;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        
        pickerView.layer.borderWidth=0.5;
        
        pickerLabel.tag=row;
        
        pickerView.layer.borderColor=selfBacground.CGColor;
        
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
        
        if (_pickerView_left==pickerView) {
            
            if (component==0&&left0_row==row) {
                
                pickerLabel.textColor=selfGreen;
                
            }else if (component==1&&left1_row==row){
                
                pickerLabel.textColor=selfGreen;
                
            }
            
        }else if (_pickerView_right==pickerView){
            
            if (component==0&&right0_row==row) {
                
                pickerLabel.textColor=[UIColor redColor];
                
            }else if (component==1&&right1_row==row){
                
                pickerLabel.textColor=[UIColor redColor];
                
            }
        }
        
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}



@end
