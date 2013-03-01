//
//  BHttpClient.h
//  iLookForiPad
//
//  Created by baboy on 13-2-27.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "AFHTTPClient.h"
#import "BHttpRequestOperation.h"

@interface BHttpClient : AFHTTPClient

+ (id)defaultClient;
- (id)requestJsonWithURLRequest:(NSURLRequest *)urlRequest
                        success:(void (^)(BHttpRequestOperation *request, id JSON))success
                        failure:(void (^)(BHttpRequestOperation *request, NSError *error))failure;

- (id)requestWithURLRequest:(NSURLRequest *)urlRequest
                    success:(void (^)(BHttpRequestOperation *request, id JSON))success
                    failure:(void (^)(BHttpRequestOperation *request, NSError *error))failure;
@end
