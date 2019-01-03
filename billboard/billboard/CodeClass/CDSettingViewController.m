//
//  CDSettingViewController.m
//  billboard
//
//  Created by chen on 2018/8/8.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "CDSettingViewController.h"

@interface CDSettingViewController ()
{
    //用户名 密码
    UITextField* nameText;
    UITextField* passText;
    UITextField* timeText;
}

@end

@implementation CDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BgColour;
    self.title=@"设置";
    [self loadViews];
    [self loadNavButton];
}

-(void)loadNavButton
{
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [btn setTitle:@"保存" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(saveClick) forControlEvents:(UIControlEventTouchUpInside)];
    btn.titleLabel.font=NameFont(14);
    
    UIBarButtonItem* rightBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem= rightBtn;
}

-(void)loadViews
{
    UILabel* name_1=[[UILabel alloc]initWithFrame:CGRectMake(10, ViewHeaderHeight+30, 80, 30)];
    name_1.text=@"扫描时间:";
    name_1.textColor=ColorWith(51, 51, 51, 1);
    name_1.font=NameFont(16);
    [self.view addSubview:name_1];
    
    /*加用户名输入框*/
    nameText=[UITextField new];
    nameText.frame=CGRectMake(name_1.x+name_1.width, ViewHeaderHeight+30, KScreen.width-(name_1.x+name_1.width)-10, 30);
    nameText.backgroundColor=[UIColor whiteColor];
    nameText.placeholder=@"请输入扫描时间";
    nameText.textColor=ColorWith(0, 0, 0, 1);
    nameText.tintColor=ColorWith(0, 0, 0, 1);
    nameText.font=NameFont(16);
    nameText.borderWidth=0.5;
    nameText.borderColor=NameColour;
    nameText.keyboardType = UIKeyboardTypeNumberPad;
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:nameText];
    
    
    UILabel* pass=[[UILabel alloc]initWithFrame:CGRectMake(10, nameText.y+nameText.height+30, 80, 30)];
    pass.text=@"信号强度:";
    pass.textColor=ColorWith(51, 51, 51, 1);
    pass.font=NameFont(16);
    [self.view addSubview:pass];
    
    /*加用户名输入框*/
    passText=[UITextField new];
    passText.frame=CGRectMake(name_1.x+name_1.width, nameText.y+nameText.height+30, KScreen.width-(name_1.x+name_1.width)-10, 30);
    passText.backgroundColor=[UIColor whiteColor];
    passText.placeholder=@"请输入信号强度";
    passText.textColor=ColorWith(0, 0, 0, 1);
    passText.tintColor=ColorWith(0, 0, 0, 1);
    passText.font=NameFont(16);
    passText.borderWidth=0.5;
    passText.borderColor=NameColour;
    passText.keyboardType = UIKeyboardTypeNumberPad;
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    passText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passText];
    
    
    UILabel* time=[[UILabel alloc]initWithFrame:CGRectMake(10, passText.y+passText.height+30, 80, 30)];
    time.text=@"二次时间:";
    time.textColor=ColorWith(51, 51, 51, 1);
    time.font=NameFont(16);
    [self.view addSubview:time];
    
    /*加用户名输入框*/
    timeText=[UITextField new];
    timeText.frame=CGRectMake(name_1.x+name_1.width, passText.y+passText.height+30, KScreen.width-(name_1.x+name_1.width)-10, 30);
    timeText.backgroundColor=[UIColor whiteColor];
    timeText.placeholder=@"请输入二次时间";
    timeText.textColor=ColorWith(0, 0, 0, 1);
    timeText.tintColor=ColorWith(0, 0, 0, 1);
    timeText.font=NameFont(16);
    timeText.borderWidth=0.5;
    timeText.borderColor=NameColour;
    timeText.keyboardType = UIKeyboardTypeNumberPad;
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    timeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:timeText];
    
    NSString* saomiao=[UserDefaultUtil valueForKey:@"saomiao"];
    NSString* xinhao=[UserDefaultUtil valueForKey:@"xinhao"];
    NSString* erci=[UserDefaultUtil valueForKey:@"erci"];
    if (saomiao&& saomiao.length!=0) {
        nameText.text=saomiao;
    }else{
        nameText.text=@"10";
    }
    if (xinhao&& xinhao.length!=0) {
        passText.text=xinhao;
    }else{
        passText.text=@"45";
    }
    if (erci && erci.length!=0) {
        timeText.text=erci;
    }else{
        timeText.text=@"5";
    }
    
}

#pragma mark-- 保存操作
-(void)saveClick
{
    [self.view endEditing:YES];
    [UserDefaultUtil saveValue:nameText.text forKey:@"saomiao"];
    [UserDefaultUtil saveValue:passText.text forKey:@"xinhao"];
    [UserDefaultUtil saveValue:timeText.text forKey:@"erci"];
    [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
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
