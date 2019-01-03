//
//  CDTimeDataFormatter.h
//  HYLWarehouse
//
//  Created by chendong on 16/10/17.
//  Copyright © 2016年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDTimeDataFormatter : NSObject

-(NSString*)showTime:(NSString*)dateStr;
-(NSString*)showBirthday:(NSString*)dateStr;
-(NSString*)getCurrentMonth;
//时间戳
+(NSString *)timeStr:(NSString*)timestamp;

- (NSString *)intervalSinceNow: (NSString *) theDate;
////时间差
//+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime;
@end
