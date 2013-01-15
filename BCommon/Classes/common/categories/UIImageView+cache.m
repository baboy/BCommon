//
//  UIImageView+cache.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "UIImageView+cache.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "G.h"

@implementation UIImageView(cache)
- (void)setImageURL:(NSURL *)url{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
    [request setCompletionBlock:^{
        NSString *fn = [request downloadDestinationPath];
        DLOG(@"setImageURL:%@",fn);
        if (fn) {
            [self setImage:[UIImage imageWithContentsOfFile:fn]];
        }
    }];
    [request startAsynchronous];
}
@end
