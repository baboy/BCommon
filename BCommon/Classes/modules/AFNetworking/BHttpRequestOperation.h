//
//  BHttpRequestOperation.h
//  iLookForiPad
//
//  Created by baboy on 13-2-27.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import "AFURLConnectionOperation.h"
#import "BHttpRequestCache.h"


@interface BHttpRequestOperation : AFHTTPRequestOperation
@property (nonatomic, retain) NSString *cacheFilePath;
@property (nonatomic, retain) BHttpRequestCache *requestCache;
@property (nonatomic, readonly) BOOL readFromCache;
@property (nonatomic, readonly) BOOL downloadResume;
- (void)setReceiveDataBlock:(void (^)(NSData *data))block;
@end

@interface BHttpRequest: NSObject

+ (BHttpRequestOperation *)queryWithUrl:(NSString *)url params:(NSDictionary *)params  cache:(BHttpRequestCache*)cache callback:(void(^)(BHttpRequestOperation *operation, id response, NSError *error))callback;
+ (BHttpRequestOperation *)postWithUrl:(NSString *)url params:(NSDictionary *)params  cache:(BHttpRequestCache*)cache callback:(void(^)(BHttpRequestOperation *operation, id response, NSError *error))callback;
@end