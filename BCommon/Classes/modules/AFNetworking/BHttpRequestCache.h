//
//  BHttpRequestCache.h
//  iLookForiPad
//
//  Created by baboy on 13-2-28.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _BHttpRequestCachePolicy {
    
    // no cache
	BHttpRequestCachePolicyNone = 0,
    
	// The the request not to write to the cache
	BHttpRequestCachePolicySaveCache = 1,
    
	// If cached data exists, use it even if it is stale. This means requests will not talk to the server unless the resource they are requesting is not in the cache
    BHttpRequestCachePolicyLoadIfNotCached = 1<<1,
    
	// If cached data exists, use it even if it is stale. If cached data does not exist, stop (will not set an error on the request)
	BHttpRequestCachePolicyDontLoad = 1<<2,
    
	// Specifies that cached data may be used if the request fails. If cached data is used, the request will succeed without error. Usually used in combination with other options above.
	BHttpRequestCachePolicyFallbackToCacheIfLoadFails = 1<<3
}BHttpRequestCachePolicy;



@interface BHttpRequestCache : NSObject
@property (nonatomic, assign) BHttpRequestCachePolicy cachePolicy;
+ (id)defaultCache;
+ (id)fileCache;
- (NSString *)cachePathForURL:(NSURL *)url;
- (NSData *)cacheDataForURL:(NSURL *)url;
+ (NSString *)cachePathForURL:(NSURL *)url;
+ (NSData *)cacheDataForURL:(NSURL *)url;
@end
