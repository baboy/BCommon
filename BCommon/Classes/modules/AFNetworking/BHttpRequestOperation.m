//
//  BHttpRequestOperation.m
//  iLookForiPad
//
//  Created by baboy on 13-2-27.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BHttpRequestOperation.h"

typedef void (^BHttpRequestOperationReceiveBlock)(NSData *data);

@interface AFURLConnectionOperation(x)<NSURLConnectionDataDelegate>
- (NSRecursiveLock *)lock;
- (void)finish;
- (void)operationDidStart;
@end



@interface BHttpRequestOperation()
@property (nonatomic, retain) NSString *tmpFilePath;
@property (nonatomic, assign) BOOL readFromCache;
@property (nonatomic, copy)   BHttpRequestOperationReceiveBlock receiveBlock;
@end

@implementation BHttpRequestOperation
- (void)dealloc{
    RELEASE(_cacheFilePath);
    RELEASE(_requestCache);
    RELEASE(_tmpFilePath);
    if (_receiveBlock)
        RELEASE(_receiveBlock);
    [super dealloc];
}
+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest{
    return YES;
}
- (void)setTmpFilePath:(NSString *)tmpFilePath{
    RELEASE(_tmpFilePath);
    _tmpFilePath = [tmpFilePath retain];
    [tmpFilePath deleteFile];
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:tmpFilePath append:NO];
}

- (void)setCacheFilePath:(NSString *)cacheFilePath{
    //DLOG(@"cache file:%@",cacheFilePath);
    RELEASE(_cacheFilePath);
    _cacheFilePath = [cacheFilePath retain];
    NSString *tmpFilePath = [cacheFilePath stringByAppendingPathExtension:@"download"];
    [self setTmpFilePath:tmpFilePath];
}
- (BHttpRequestCache *)requestCache{
    if (!_requestCache) {
        _requestCache = [[BHttpRequestCache alloc] init];
    }
    return _requestCache;
}
- (NSData *)responseData{
    NSData *data = [super responseData];
    if (!data && [self.cacheFilePath sizeOfFile] > 0) {
        data = [NSData dataWithContentsOfFile:self.cacheFilePath];
    }
    return data;
}
- (void)operationDidStart{
    [self.lock lock];
    self.readFromCache = NO;
    // 准备缓存路径
    if ( (self.requestCache.cachePolicy & BHttpRequestCachePolicyLoadIfNotCached)
        || (self.requestCache.cachePolicy & BHttpRequestCachePolicyFallbackToCacheIfLoadFails)
        || (self.requestCache.cachePolicy & BHttpRequestCachePolicySaveCache)) {
        NSString *cacheFilePath = [self.requestCache cachePathForURL:self.request.URL];
        [self setCacheFilePath:cacheFilePath];
    }
    //优先使用缓存
    if (self.requestCache.cachePolicy & BHttpRequestCachePolicyLoadIfNotCached) {
        if ([self.cacheFilePath sizeOfFile]>0) {
            self.readFromCache = YES;
            [self finish];
            [self.lock unlock];
            //DLOG(@"read from cache directory");
            return;
        };
    }
    [self.lock unlock];
    [super operationDidStart];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (self.receiveBlock) {
        self.receiveBlock(data);
    }
    [super connection:connection didReceiveData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self.outputStream close];
    if (self.cacheFilePath) {
        [self.cacheFilePath deleteFile];
        [self.tmpFilePath renameToPath:self.cacheFilePath];
    }
    [super connectionDidFinishLoading:connection];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (self.requestCache.cachePolicy & BHttpRequestCachePolicyFallbackToCacheIfLoadFails) {
        if ([self.cacheFilePath sizeOfFile]>0) {
            self.readFromCache = YES;
        }
    }
    [super connection:connection didFailWithError:error];
}
- (NSError *)error{
    if (self.readFromCache) {
        return nil;
    }
    return [super error];
}
- (void)setReceiveDataBlock:(void (^)(NSData *data))block{
    RELEASE(_receiveBlock);
    _receiveBlock = [block copy];
}
@end
