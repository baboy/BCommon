//
//  CacheURLProtocol.m
//  iLook
//
//  Created by Yinghui Zhang on 2/26/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "CacheURLProtocol.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "GTMBase64.h"
#import "G.h"

@interface CacheURLProtocol(){
    ASIHTTPRequest *cacheRequest;
}
@property(nonatomic, retain) ASIHTTPRequest *cacheRequest;
@end

@implementation CacheURLProtocol
@synthesize cacheRequest;
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
    
    ASIDownloadCache *cache = [ASIDownloadCache sharedCache];
    
    NSData *data = [cache cachedResponseDataForURL:reqURL];
    //NSLog(@"start Loading:%@,%d,%@",urlString,[data length],[cache pathToCachedResponseDataForURL:reqURL]);
    if (data) {
        [self.client URLProtocol:self didLoadData:data];  
        [self.client URLProtocolDidFinishLoading:self];
        return;
    }    
    self.cacheRequest = [ASIHTTPRequest requestWithURL:reqURL];
    [self.cacheRequest setDelegate:self];
    [self.cacheRequest setDownloadCache:cache];
    [self.cacheRequest setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    [self.cacheRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.cacheRequest setDownloadDestinationPath:[cache pathToStoreCachedResponseDataForRequest:cacheRequest]];
    [self.cacheRequest startAsynchronous];
}

// Called by URL loading system in response to normal finish, error or abort. Cleans up in each case.
- (void)stopLoading{
    //NSLog(@"stopLoading...:%d",[[cacheRequest responseData] length]);
    if (cacheRequest) {
        [cacheRequest clearDelegatesAndCancel];
    }
    self.cacheRequest = nil;
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    //NSLog(@"requestFinished...:%d,%d",[[cacheRequest responseData] length],[[cacheRequest rawResponseData] length]);
    [self.client URLProtocolDidFinishLoading:self];
}
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{ 
    //NSLog(@"cache-image didReceiveData:%d",[data length]);
    [self.client URLProtocol:self didLoadData:data];  
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    //NSLog(@"cache-image requestFailed:%@,%@",error,[request url]);
    [self.client URLProtocol:self didFailWithError:error];
}
- (void)dealloc{  
    if (cacheRequest) {
        [cacheRequest clearDelegatesAndCancel];
    }
    [cacheRequest release];
    [super dealloc];
}
@end


@implementation NSURL(cache)

+ (NSString*) URLStringWithScheme:(NSString *)scheme urlString:(NSString*)urlString{    
    NSString *base64 = [GTMBase64 stringByWebSafeEncodeString:urlString];
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
    NSString *urlString = [GTMBase64 stringByWebSafeDecodeString:[self host]];
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

