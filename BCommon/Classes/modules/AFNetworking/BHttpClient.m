//
//  BHttpClient.m
//  iLookForiPad
//
//  Created by baboy on 13-2-27.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BHttpClient.h"

@implementation BHttpClient

+ (id)defaultClient {
    static id _defaultHttpRequestClient = nil;
    static dispatch_once_t initOnceHttpRequestClient;
    dispatch_once(&initOnceHttpRequestClient, ^{
        _defaultHttpRequestClient = [[BHttpClient alloc] initWithBaseURL:[NSURL URLWithString:ApiDomain]];
    });
    
    return _defaultHttpRequestClient;
}
- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[BHttpRequestOperation class]];
	//[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}
- (id)requestJsonWithURLRequest:(NSURLRequest *)urlRequest
										success:(void (^)(BHttpRequestOperation *request, id JSON))success
										failure:(void (^)(BHttpRequestOperation *request, NSError *error))failure
{
    return [self HTTPRequestOperationWithRequest:urlRequest
                                         success:^(id operation, id responseObject) {
                                             if (success) {
                                                 success(operation, [responseObject json]);
                                             }
                                         }
                                         failure:^(id operation, NSError *error) {
                                             if (failure) {
                                                 failure(operation, error);
                                             }
                                         }];
}

- (id)requestWithURLRequest:(NSURLRequest *)urlRequest
                     success:(void (^)(BHttpRequestOperation *request, id JSON))success
                     failure:(void (^)(BHttpRequestOperation *request, NSError *error))failure
{
    return [self HTTPRequestOperationWithRequest:urlRequest
                                         success:^(id operation, id responseObject) {
                                             if (success) {
                                                 success(operation, responseObject);
                                             }
                                         }
                                         failure:^(id operation, NSError *error) {
                                             if (failure) {
                                                 failure(operation, error);
                                             }
                                         }];
}
@end
