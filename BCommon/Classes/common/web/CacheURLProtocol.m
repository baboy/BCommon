//
//  CacheURLProtocol.m
//  iLook
//
//  Created by Yinghui Zhang on 2/26/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "CacheURLProtocol.h"
#import "Base64.h"

@interface CacheURLProtocol()
@property(nonatomic, retain) BHttpRequestOperation *cacheOperation;
@end

@implementation CacheURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSString *scheme = [[request URL] scheme];
    return ([scheme isEqualToString:CacheSchemeName]);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

// Called when URL loading system initiates a request using this protocol. Initialise input stream, buffers and decryption engine.
- (void)startLoading{    
    NSURL *cacheURL = [self.request URL];
    NSString *urlString = [cacheURL httpURLString];
    NSURL *reqURL = [NSURL URLWithString:urlString];
    
    BHttpRequestCache *cache = [BHttpRequestCache fileCache];
    NSData *data = [cache cacheDataForURL:reqURL];
    if (data) {
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
        return;
    }
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:reqURL parameters:nil];
    BHttpRequestOperation *operation = [client dataRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id data) {
                                                                     
                                                                     [self.client URLProtocolDidFinishLoading:self];
                                                                 }
                                                                 failure:^(BHttpRequestOperation *request, NSError *error) {                                                                     
                                                                     [self.client URLProtocol:self didFailWithError:error];
                                                                 }];
    [operation setReceiveDataBlock:^(NSData *data) {
        [self.client URLProtocol:self didLoadData:data];
    }];
    [operation setRequestCache:cache];
    [operation start];

    self.cacheOperation = operation;
}

// Called by URL loading system in response to normal finish, error or abort. Cleans up in each case.
- (void)stopLoading{
    //NSLog(@"stopLoading...:%d",[[cacheRequest responseData] length]);
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
    }
    self.cacheOperation = nil;
}
- (void)dealloc{  
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
    }
    [_cacheOperation release];
    [super dealloc];
}
@end


@implementation NSURL(cache)

+ (NSString*) URLStringWithScheme:(NSString *)scheme urlString:(NSString*)urlString{    
    NSString *base64 = [Base64 stringByWebSafeEncodeString:urlString];
    NSString *url = [NSString stringWithFormat:@"%@://%@",scheme,base64];
    return url;
}
+ (NSString *) cacheImageURLString:(NSString *)urlString{    
    return [self URLStringWithScheme:CacheSchemeName urlString:urlString];

}
+ (NSURL*) cacheImageURLWithString:(NSString *)urlString{
    return [NSURL URLWithString:[self cacheImageURLString:urlString]];
}

+ (NSURL *) imageURLWithString:(NSString *)urlString{
    return [NSURL URLWithString:[NSURL URLStringWithScheme:ImageScheme urlString:urlString]];
}
+ (NSURL *) videoURLWithString:(NSString *)urlString{    
    return [NSURL URLWithString:[NSURL URLStringWithScheme:VideoScheme urlString:urlString]];
}
+ (BOOL) isCacheImageURL:(NSURL *)url{
    if (url && [[url absoluteString] hasPrefix:[NSString stringWithFormat:@"%@://",CacheSchemeName]]) {
        return YES;
    }
    return NO;
}

- (BOOL) isImageURL{
    return  [[self absoluteString] hasPrefix:[NSString stringWithFormat:@"%@://",ImageScheme]];
}
- (BOOL) isVideoURL{    
    return [[self absoluteString] hasPrefix:[NSString stringWithFormat:@"%@://",VideoScheme]];
}
- (NSString *)httpURLString{
    NSString *urlString = [Base64 stringByWebSafeDecodeString:[self host]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return urlString;
}
+ (NSString *)imageScheme{
    return ImageScheme;
}
+ (NSString *)videoScheme{
    return VideoScheme;
}
@end

