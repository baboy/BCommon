//
//  BHttpRequestCache.m
//  iLookForiPad
//
//  Created by baboy on 13-2-28.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BHttpRequestCache.h"

@implementation BHttpRequestCache
+ (id)defaultCache{
    static id _defaultHttpRequestCache = nil;
    static dispatch_once_t initOnceCache;
    dispatch_once(&initOnceCache, ^{
        _defaultHttpRequestCache = [[[BHttpRequestCache alloc] init] autorelease];
        [_defaultHttpRequestCache setCachePolicy:BHttpRequestCachePolicyFallbackToCacheIfLoadFails];
    });    
    return _defaultHttpRequestCache;
}
- (NSString *)cachePathForURL:(NSURL *)url{
    NSString *fn = [[url absoluteString] md5];
    NSString *ext = [url pathExtension];
    return getFilePath(fn, ext, gImageCacheDir);
}
@end
