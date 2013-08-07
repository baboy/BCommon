//
//  BHttpClient.h
//  iLookForiPad
//
//  Created by baboy on 13-2-27.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "AFHTTPClient.h"
#import "BHttpRequestOperation.h"

enum{
    HttpRequestMethodGET,
    HttpRequestMethodPOST,
    HttpRequestMethodPUT
};
typedef UInt32 HttpRequestMethod;

@interface BHttpClient : AFHTTPClient

+ (id)defaultClient;
- (id)jsonRequestWithURLRequest:(NSURLRequest *)urlRequest
                        success:(void (^)(BHttpRequestOperation *operation, id json))success
                        failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure;

- (id)dataRequestWithURLRequest:(NSURLRequest *)urlRequest
                    success:(void (^)(BHttpRequestOperation *operation, id data))success
                    failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure;

- (NSMutableURLRequest *)requestWithPostURL:(NSURL *)url parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)requestWithGetURL:(NSURL *)url parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                       url:(NSURL *)url
                                parameters:(NSDictionary *)parameters;
@end
