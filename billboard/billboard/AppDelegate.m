//
//  AppDelegate.m
//  billboard
//
//  Created by chen on 2018/6/12.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "AppDelegate.h"
#import "NavigationController.h"
#import "CDMainViewController.h"
#import "CDBlueTestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    CDBlueTestViewController *loginVC = [[CDBlueTestViewController alloc] init];
    NavigationController* nav=[[NavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = nav;
    
    //检测版本
//    [self testNewVersion];
//    [self chooseRootViewControllerWithVersion];
    //设置SVProgressHUD
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
    
    //键盘监听
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    //    keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字
    keyboardManager.shouldShowToolbarPlaceholder=YES;// 是否显示占位文字
    keyboardManager.placeholderFont = NameFont(16); // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
    //设置导航栏
    [self setNavBarAppearence];
    
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    return YES;
}

- (void)setNavBarAppearence
{
    // 设置导航栏默认的背景颜色
    [UIColor wr_setDefaultNavBarBarTintColor:ColorWith(50, 190, 140, 1)];
    // 设置导航栏所有按钮的默认颜色
    [UIColor wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏标题默认颜色
    [UIColor wr_setDefaultNavBarTitleColor:[UIColor whiteColor]];
    // 统一设置状态栏样式
    [UIColor wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [UIColor wr_setDefaultNavBarShadowImageHidden:YES];
}

- (void)chooseRootViewControllerWithVersion
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootViewController:) name:@"SwitchRootViewControllerNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToLoginViewController:) name:@"GoToLoginViewControllerNotification" object:nil];
    
    [self switchRootViewController:nil];
}

- (void)switchRootViewController:(NSNotification *)note
{
    CDBlueTestViewController *loginVC = [[CDBlueTestViewController alloc] init];
    NavigationController* nav=[[NavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = nav;
}

- (void)goToLoginViewController:(NSNotification *)note
{
    
//    CDLeadViewController *loginVC = [[CDLeadViewController alloc] init];
//    NavigationController* nav=[[NavigationController alloc]initWithRootViewController:loginVC];
//    self.window.rootViewController = nav;
}

#pragma mark-- 竖屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark-- 检测版本
-(void)testNewVersion
{
    [HttpManager postUrl:APP_URL Parameters:nil success:^(NSDictionary *resDict) {
        /*responseObject是个字典{}，有两个key
         
         KEYresultCount = 1//表示搜到一个符合你要求的APP
         results =（）//这是个只有一个元素的数组，里面都是app信息，那一个元素就是一个字典。里面有各种key。其中有 trackName （名称）trackViewUrl = （下载地址）version （可显示的版本号）等等
         */
        //具体实现为
        NSArray *arr = [resDict objectForKey:@"results"];
        NSDictionary *dic = [arr firstObject];
        NSString *versionStr = [dic objectForKey:@"version"];
        NSString *trackViewUrl = [dic objectForKey:@"trackViewUrl"];
        NSString *releaseNotes = [dic objectForKey:@"releaseNotes"];//更新日志
        //NSString* buile = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString*) kCFBundleVersionKey];build号
        NSString* thisVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        
        if ([self compareVersionsFormAppStore:versionStr WithAppVersion:thisVersion]) {
            //            NSUserDefaults* userDefault=[NSUserDefaults standardUserDefaults];
            //            [userDefault setObject:nil forKey:@"username"];
            //            [userDefault synchronize];
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Discover the new version,go to AppStore Update"] message:releaseNotes preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancelAction=[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"update" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //                    NSLog(@"点击了知道了");
                NSURL * url = [NSURL URLWithString:trackViewUrl];//itunesURL = trackViewUrl的内容
                [[UIApplication sharedApplication] openURL:url];
            }];
            
            [alertVC addAction:cancelAction];
            [alertVC addAction:OKAction];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
        }
        else
        {
            
            //            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"当前版本为最新版本"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            //            UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //                NSLog(@"点击了取消");
            //            }];
            //
            //            UIAlertAction *OKAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //                NSLog(@"点击了知道了");
            //            }];
            //            [alertVC addAction:cancelAction];
            //            [alertVC addAction:OKAction];
            //            [self presentViewController:alertVC animated:YES completion:nil];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

//比较版本的方法，在这里我用的是Version来比较的
- (BOOL)compareVersionsFormAppStore:(NSString*)AppStoreVersion WithAppVersion:(NSString*)AppVersion
{
    
    BOOL littleSunResult = false;
    if (!AppStoreVersion) {
        return littleSunResult;
    }
    NSMutableArray* a = (NSMutableArray*) [AppStoreVersion componentsSeparatedByString: @"."];
    NSMutableArray* b = (NSMutableArray*) [AppVersion componentsSeparatedByString: @"."];
    
    while (a.count < b.count) { [a addObject: @"0"]; }
    while (b.count < a.count) { [b addObject: @"0"]; }
    
    for (int j = 0; j<a.count; j++) {
        if ([[a objectAtIndex:j] integerValue] > [[b objectAtIndex:j] integerValue]) {
            littleSunResult = true;
            break;
        }else if([[a objectAtIndex:j] integerValue] < [[b objectAtIndex:j] integerValue]){
            littleSunResult = false;
            break;
        }else{
            littleSunResult = false;
        }
    }
    return littleSunResult;//true就是有新版本，false就是没有新版本
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
