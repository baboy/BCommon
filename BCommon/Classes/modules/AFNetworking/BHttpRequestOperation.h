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
- (void)setReceiveDataBlock:(void (^)(NSData *data))block;
@end