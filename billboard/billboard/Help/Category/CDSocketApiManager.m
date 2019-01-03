//
//  CDSocketApiManager.m
//  366管家
//
//  Created by xhkj on 2017/4/6.
//  Copyright © 2017年 chendong. All rights reserved.
//

#import "CDSocketApiManager.h"

@implementation CDSocketApiManager

+(instancetype)sharedApiManager{
    static CDSocketApiManager* _instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[CDSocketApiManager alloc]init];
    });
    return _instance;
}

-(void)requestSocketWithJsonData:(NSData *)jsonData SuccBlocks:(void(^)(id jsonObject))succBlocks
                       failBlock:(void(^)(NSError* error))failBlocks
{
    NSString *receiverStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%s receiverStr====%@",__func__,receiverStr);
    if(![receiverStr containsString:@"}{"])//_roaldSearchText
    {
//        NSLog(@"no");
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
    
        if (jsonObject != nil && error == nil){
            succBlocks(jsonObject);
        }else{
            // 解析错误
            failBlocks(error);
        }
    }
    else
    {
//        NSLog(@"yes");
        //3、分割字符串
        NSArray *stringArr = [receiverStr componentsSeparatedByString:@"}{"];
        
        NSMutableArray *usefulStringArr = [NSMutableArray new];
        for (NSString* tmpStr in stringArr) {
//            NSLog(@"======tmpStr%@",tmpStr);
            if ([tmpStr hasPrefix:@"{"]){//首段
                NSMutableString* str1=[[NSMutableString alloc]initWithString:tmpStr];
                [str1 insertString:@"}"atIndex:tmpStr.length-1];
                [usefulStringArr addObject:str1];
            }
            else if ([tmpStr hasSuffix:@"}"]){//尾段
                NSMutableString* str1=[[NSMutableString alloc]initWithString:tmpStr];
                [str1 insertString:@"{"atIndex:0];
                [usefulStringArr addObject:str1];
            }
            else
            {
                NSMutableString* str1=[[NSMutableString alloc]initWithString:tmpStr];
                [str1 insertString:@"{"atIndex:0];
                [str1 insertString:@"}"atIndex:tmpStr.length-1];
                [usefulStringArr addObject:str1];
            }
        }
        for (NSString* tmpstr in usefulStringArr) {
            NSData* xmlData = [tmpstr  dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:xmlData
                                                            options:NSJSONReadingAllowFragments
                                                              error:&error];
            
            if (jsonObject != nil && error == nil){
                succBlocks(jsonObject);
            }else{
                // 解析错误
                failBlocks(error);
            }
            
        }
//        NSLog(@"usefulStringArr=====%@",usefulStringArr);
    }
    
    
//    NSLog(@"*****%s %@",__func__,receiverStr);
//    NSError *error = nil;
//    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                    options:NSJSONReadingAllowFragments
//                                                      error:&error];
//    
//    if (jsonObject != nil && error == nil){
//        succBlocks(jsonObject);
//    }else{
//        // 解析错误
//        failBlocks(error);
//    }
}

@end
