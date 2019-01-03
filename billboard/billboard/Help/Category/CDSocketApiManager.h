//
//  CDSocketApiManager.h
//  366管家
//
//  Created by xhkj on 2017/4/6.
//  Copyright © 2017年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDSocketApiManager : NSObject

+(instancetype)sharedApiManager;

-(void)requestSocketWithJsonData:(NSData *)jsonData SuccBlocks:(void(^)(id jsonObject))succBlocks
                                    failBlock:(void(^)(NSError* error))failBlocks;
@end
