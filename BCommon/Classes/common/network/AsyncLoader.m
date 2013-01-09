//
//  ConfigLoader.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "AsyncLoader.h"
#import "ASIDownloadCache.h"
#import "ASIFormDataRequest.h"
#import "G.h"
#import "Utils.h"
#import "JSONKit.h"
#import "Api.h"

@implementation AsyncLoader
+ (ASIHTTPRequest *)loadConfig:(NSString *)url param:(NSDictionary*)param  success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    DLOG(@"url:%@",url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setCompletionBlock:^{
        //DLOG(@"config:%@",[request responseString]);
        id json = [[request responseString] objectFromJSONString];
        if (success) {
            success(json);
        }
    }];
    [request setFailedBlock:^{
        DLOG(@"fail:%@",[request error]);
        if (failure) {
            failure([request error]);
        }
    }];
    [request startAsynchronous];    
    return request;
}
+ (ASIHTTPRequest *)loadJSONData:(NSString *)url param:(NSDictionary*)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    url = [Utils url:url withParam:param];
    NSLog(@"url:%@",url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setCompletionBlock:^{
        id json = [[request responseString] objectFromJSONString];
        if (success) {
            success(json);
        }
    }];
    [request setFailedBlock:^{
        if (failure) {
            failure([request error]);
        }
    }];
    [request startAsynchronous];    
    return request;
}
+ (ASIHTTPRequest *)loadDataString:(NSString *)url param:(NSDictionary*)param  cached:(BOOL)cached success:(void (^)(NSString *s))success failure:(void (^)(NSError *error))failure{
    NSLog(@"url:%@",url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    if (cached) {
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        [request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    }
    [request setCompletionBlock:^{
        if (success) {
            success([request responseString]);
        }
    }];
    [request setFailedBlock:^{
        DLOG(@"fail:%@",[request error]);
        if (failure) {
            failure([request error]);
        }
    }];
    [request startAsynchronous];    
    return request;
}
+ (ASIHTTPRequest *)loadData:(NSString *)url param:(NSDictionary*)param cached:(BOOL)cached success:(void (^)(NSData *data))success failure:(void (^)(NSError *error))failure;{
    NSLog(@"url:%@",url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    if (cached) {
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        [request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    }
    [request setCompletionBlock:^{
        if (success) {
            success([request responseData] );
        }
    }];
    [request setFailedBlock:^{
        DLOG(@"fail:%@",[request error]);
        if (failure) {
            failure([request error]);
        }
    }];
    [request startAsynchronous];    
    return request;
}
+ (ASIHTTPRequest *)post:(NSString *)url param:(NSDictionary*)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    //[formRequest setRequestMethod:@"POST"];
    for (NSString *k in [param allKeys]) {
        [formRequest setPostValue:[param objectForKey:k] forKey:k];
    }
    [formRequest setCompletionBlock:^{  
        NSDictionary *json = [formRequest.responseString objectFromJSONString];
        if (success) {
            success(json);
        }
    }];
    [formRequest setFailedBlock:^{
        if (failure) {
            failure([formRequest error]);
        }
    }];
    [formRequest startAsynchronous];
    return formRequest;
}
+ (ASIHTTPRequest *)feedback:(NSString *)content success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:content forKey:@"content"];
    [param setValue:BundleID forKey:@"domain"];
    [param setValue:@"feedback" forKey:@"mod"];
    [param setValue:BundleVersion forKey:@"sid"];
    [param setValue:TmpUserID forKey:UserIDKey];
    [param setValue:TmpUserName forKey:UserNameKey];
    return [self post:ApiFeedback
                param:param
              success:success
              failure:failure];
    
}
@end
