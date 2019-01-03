//
//  CDOnOffModel.h
//  billboard
//
//  Created by chen on 2018/6/12.
//  Copyright © 2018年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDOnOffModel : NSObject
@property (nonatomic,copy)NSString* state;
@property (nonatomic,copy)NSString* openTimeHour;
@property (nonatomic,copy)NSString* openTimeMiniter;
@property (nonatomic,copy)NSString* closeTimeHour;
@property (nonatomic,copy)NSString* closeTimeMiniter;

@end
