//
//  CDTextViewController.m
//  billboard
//
//  Created by chen on 2018/8/16.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "CDTextViewController.h"

@interface CDTextViewController ()

@end

@implementation CDTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Log记录";
    self.view.backgroundColor=BgColour;
    [self loadViews];
}

-(void)loadViews
{
    UITextView* textV=[[UITextView alloc]init];
    textV.frame=CGRectMake(10, ViewHeaderHeight, KScreen.width-10, KScreen.height-ViewHeaderHeight);
    textV.font=NameFont(14);
    textV.textColor=NameColour;
    textV.editable=NO;
    textV.backgroundColor=BgColour;
    [self.view addSubview:textV];
    NSString *path=[NSString stringWithFormat:@"%@/Library/Data/SSLog/%@",NSHomeDirectory(),self.fileName];
    NSData *reader = [NSData dataWithContentsOfFile:path];
    textV.text=[[NSString alloc] initWithData:reader
                                        encoding:NSUTF8StringEncoding];
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
