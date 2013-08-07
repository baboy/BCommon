//
//  BHttpClient.m
//  iLookForiPad
//
//  Created by baboy on 13-2-27.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BHttpClient.h"
@interface BHttpClient(x)
- (NSMutableDictionary *)defaultHeaders;
@end
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
- (id)jsonRequestWithURLRequest:(NSURLRequest *)urlRequest
										success:(void (^)(BHttpRequestOperation *operation, id json))success
										failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure
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

- (id)dataRequestWithURLRequest:(NSURLRequest *)urlRequest
                     success:(void (^)(BHttpRequestOperation *operation, id data))success
                     failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure
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

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      url:(NSURL *)url
                                parameters:(NSDictionary *)parameters
{
    NSParameterAssert(method);
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:method];
    [request setAllHTTPHeaderFields:self.defaultHeaders];
    
    if (parameters) {
        if ([method isEqualToString:@"GET"] || [method isEqualToString:@"HEAD"] || [method isEqualToString:@"DELETE"]) {
            url = [NSURL URLWithString:[[url absoluteString] stringByAppendingFormat:[[url path] rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@", AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding)]];
            [request setURL:url];
        } else {
            NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
            NSError *error = nil;
            
            switch (self.parameterEncoding) {
                case AFFormURLParameterEncoding:;
                    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding) dataUsingEncoding:self.stringEncoding]];
                    break;
                case AFJSONParameterEncoding:;
                    [request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
                    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]];
#pragma clang diagnostic pop
                    break;
                case AFPropertyListParameterEncoding:;
                    [request setValue:[NSString stringWithFormat:@"application/x-plist; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:[NSPropertyListSerialization dataWithPropertyList:parameters format:NSPropertyListXMLFormat_v1_0 options:0 error:&error]];
                    break;
            }
            
            if (error) {
                NSLog(@"%@ %@: %@", [self class], NSStringFromSelector(_cmd), error);
            }
        }
    }
    
	return request;
}

- (NSMutableURLRequest *)requestWithPostURL:(NSURL *)url parameters:(NSDictionary *)parameters
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:self.defaultHeaders];
	
    if (parameters) {
        NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
        NSError *error = nil;
        
        switch (self.parameterEncoding) {
            case AFFormURLParameterEncoding:;
                [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding) dataUsingEncoding:self.stringEncoding]];
                break;
            case AFJSONParameterEncoding:;
                [request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]];
                break;
            case AFPropertyListParameterEncoding:;
                [request setValue:[NSString stringWithFormat:@"application/x-plist; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:[NSPropertyListSerialization dataWithPropertyList:parameters format:NSPropertyListXMLFormat_v1_0 options:0 error:&error]];
                break;
        }
        
        if (error) {
            NSLog(@"%@ %@: %@", [self class], NSStringFromSelector(_cmd), error);
        }
    }
    
	return request;
}
- (NSMutableURLRequest *)requestWithGetURL:(NSURL *)url parameters:(NSDictionary *)parameters{
    if (parameters) {
        NSString *urlString = [Utils url:[url absoluteString] withParam:parameters];
        url = [NSURL URLWithString:urlString];
    }
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:self.defaultHeaders];
    
    return request;
}

@end
