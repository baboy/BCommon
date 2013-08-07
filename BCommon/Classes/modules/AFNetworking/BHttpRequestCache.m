//
//  BHttpRequestCache.m
//  iLookForiPad
//
//  Created by baboy on 13-2-28.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BHttpRequestCache.h"
#import "BCommon.h"

@implementation BHttpRequestCache
+ (id)defaultCache{
    static id _defaultHttpRequestCache = nil;
    static dispatch_once_t initOnceDefaultCache;
    dispatch_once(&initOnceDefaultCache, ^{
        _defaultHttpRequestCache = [[BHttpRequestCache alloc] init];
        [_defaultHttpRequestCache setCachePolicy:BHttpRequestCachePolicyFallbackToCacheIfLoadFails];
    });    
    return _defaultHttpRequestCache;
}
+ (id)fileCache{
    static id _fileRequestCache = nil;
    static dispatch_once_t initOnceFileCache;
    dispatch_once(&initOnceFileCache, ^{
        _fileRequestCache = [[BHttpRequestCache alloc] init];
        [_fileRequestCache setCachePolicy:BHttpRequestCachePolicyLoadIfNotCached];
    });
    return _fileRequestCache;
}

- (NSString *)cachePathForURL:(NSURL *)url{
    return [BHttpRequestCache cachePathForURL:url];
}
- (NSData *)cacheDataForURL:(NSURL *)url{
    return [BHttpRequestCache cacheDataForURL:url];
}
+ (NSString *)cachePathForURL:(NSURL *)url{
    NSString *fn = [[url absoluteString] md5];
    NSString *ext = [url pathExtension];
    return getFilePath(fn, ext, gImageCacheDir);
}
+ (NSData *)cacheDataForURL:(NSURL *)url{
    NSString *fp = [self cachePathForURL:url];
    if (fp && [[NSFileManager defaultManager] fileExistsAtPath:fp]) {
        return [NSData dataWithContentsOfFile:fp];
    }
    return nil;
}
@end
