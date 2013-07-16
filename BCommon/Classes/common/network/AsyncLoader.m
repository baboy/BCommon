//
//  ConfigLoader.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "AsyncLoader.h"

@implementation AsyncLoader
+ (BHttpRequestOperation *)loadDataString:(NSString *)url param:(NSDictionary*)param  cached:(BOOL)cached success:(void (^)(NSString *s))success failure:(void (^)(NSError *error))failure{
    return [self loadData:url
                    param:param
                   cached:cached
                  success:^(NSData *data) {
                      NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                      if (success) {
                          success(s);
                      }
                  }
                  failure:failure];

}
+ (BHttpRequestOperation *)loadData:(NSString *)url param:(NSDictionary*)param cached:(BOOL)cached success:(void (^)(NSData *data))success failure:(void (^)(NSError *error))failure;{
    NSLog(@"url:%@",url);
    
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:[NSURL URLWithString:url] parameters:param];
    BHttpRequestOperation *operation = [client dataRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id data) {
                                                                     if (success) {
                                                                         success( data );
                                                                     }
                                                                 }
                                                                 failure:^(BHttpRequestOperation *operation, NSError *error) {                                                                     
                                                                     DLOG(@"fail:%@",error);
                                                                     if (failure) {
                                                                         failure(error);
                                                                     }
                                                                 }];
    if (cached) {
        [operation setRequestCache:[BHttpRequestCache defaultCache]];
    }
    [operation start];
    return operation;
}
+ (BHttpRequestOperation *)post:(NSURL *)url param:(NSDictionary*)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithPostURL:url parameters:param];
    BHttpRequestOperation *operation = [client jsonRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id json) {
                                                                     
                                                                     if (success) {
                                                                         success(json);
                                                                     }
                                                                 }
                                                                 failure:^(BHttpRequestOperation *operation, NSError *error) {
                                                                     if (failure) {
                                                                         failure(error);
                                                                     }
                                                                 }];
    [operation start];
    return operation;
}
+ (BHttpRequestOperation *)feedback:(NSString *)content success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
    ;
    [param setValue:content forKey:@"content"];
    [param setValue:BundleID forKey:@"domain"];
    [param setValue:@"feedback" forKey:@"mod"];
    [param setValue:BundleVersion forKey:@"sid"];
    return [self post:[NSURL URLWithString:ApiFeedback]
                param:param
              success:success
              failure:failure];
    
}
@end
