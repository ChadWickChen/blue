//
//  HttpManager.m
//  MyApp
//
//  Created by liaowentao on 17/3/28.
//  Copyright © 2017年 Haochuang. All rights reserved.
//

#import "HttpManager.h"

@implementation HttpManager

+ (AFHTTPSessionManager *)httpManager{
    //获取请求对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //去除空值
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer=response;
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
    //设置是否信任与无效或过期的 SSL 证书的服务器。默认为否。
//    manager.securityPolicy.allowInvalidCertificates = YES;
    // 设置请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置返回格式
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.timeoutInterval = RequestTimeOut;
    return manager;
}

+ (void)postUrl:(NSString *)urlStr Parameters:(id)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    
    //    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] <= 0) {
    //        [MBProgressHUD showMessageInWindow:@"网络无连接" afterDelayHide:AfterDelayHide];
    //        return;
    //    }
    AFHTTPSessionManager *manager = [self httpManager];
    //编码
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //开始请求
    [manager POST:urlStr
       parameters:parameters
         progress:^(NSProgress * _Nonnull uploadProgress) {
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSMutableDictionary *resDict = (NSMutableDictionary *)[responseObject mj_JSONObject];
//              NSDictionary *dict = [HttpManager checkResultVaild:resDict withFunction:parameters[@"function"]];
              
//              NSLog(@"\n返回数据：%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
//            NSString *result = [[NSString alloc] initWithData:responseObject
//                                                     encoding:NSUTF8StringEncoding];
            
              NSLog(@"\n返回数据：%@",responseObject);
              success(resDict);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failure(error);
              NSLog(@"\n错误信息：%@",error);
          }];
}

+ (void)getUrl:(NSString *)urlStr
    Parameters:(id)parameters
       success:(void (^)(NSDictionary *))success
       failure:(void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [self httpManager];
    //编码
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    //开始请求
    [manager  GET:urlStr
       parameters:parameters
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              //              NSString *result = [[NSString alloc] initWithData:responseObject
              //                                                       encoding:NSUTF8StringEncoding];
              //              DDLogInfo(@"返回数据--%@",result);
              NSMutableDictionary *resDict = (NSMutableDictionary *)[responseObject mj_JSONObject];
//              NSLog(@"\n返回数据：%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
              NSLog(@"\n返回数据：%@",responseObject);
//              NSDictionary *dict = [HttpManager checkResultVaild:resDict withFunction:parameters[@"function"]];
              success(resDict);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failure(error);
              NSLog(@"\n错误信息：%@",error);
          }];
}

+(void)removeOperations
{
    AFHTTPSessionManager *manager = [self httpManager];
    [manager.operationQueue cancelAllOperations];
}
/**
 *  检查返回的内容是否有效
 *
 *  @param dict        返回数据
 *  @param functionStr 接口名称
 *
 *  @return 正常的返回数据
 */
//+ (NSDictionary *)checkResultVaild:(NSDictionary *)dict withFunction:(NSString *)functionStr
//{
//    
//}

@end
