//
//  CDJianCeViewController.h
//  billboard
//
//  Created by chen on 2018/7/20.
//  Copyright © 2018年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDJianCeViewController : UIViewController
{
@public
    BabyBluetooth *baby;
}
@property(strong,nonatomic)NSArray *peripheralTmp;
@end
