//
//  UIImageView+cache.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "XUIImageView.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "G.h"
#import "NSString+x.h"

@interface XUIImageView()
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) ASIHTTPRequest *request;
@end

@implementation XUIImageView
@synthesize object;
@synthesize request = _request;
@synthesize target = _target;
@synthesize action = _action;
@synthesize delegate = _delegate;


- (void)setImageAndNotify:(UIImage *)image{    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageView:didChangeImage:)]) {
        if (image) {
            [self setImage:image];
        }
        [self.delegate imageView:self didChangeImage:image];
    }else{
        [self setImage:image];
    }
}
- (void)setImageURL:(NSURL *)url{
    if (_request) {
        [_request clearDelegatesAndCancel];
    }
    RELEASE(_request);    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
    [request setCompletionBlock:^{
        NSString *fn = [request downloadDestinationPath];
        DLOG(@"setImageURL setImageURL:%@",fn);
        [self setImageAndNotify:[UIImage imageWithContentsOfFile:fn]];
    }];
    [request startAsynchronous];
    [self setRequest:_request];
}
- (void)setImageURLString:(NSString *)urlString{
    if ([urlString isURL]) {
        DLOG(@"setImageURLString:%@",urlString);
        [self setImageURL:[NSURL URLWithString:urlString]];
    }else if([[NSFileManager defaultManager] fileExistsAtPath:urlString isDirectory:NO]){        
        [self setImage:[UIImage imageWithContentsOfFile:urlString]];
    }
}
- (void)tapEvent:(UIGestureRecognizer *)r{
    if (self.target && self.action && r.state == UIGestureRecognizerStateEnded) {
        [self.target performSelector:self.action withObject:self.object];
    }
}
- (void)addTarget:(id)target action:(SEL)action{
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(tapEvent:)] autorelease];
    [self addGestureRecognizer:tap];
}
- (void)dealloc{
    if (_request) {
        [_request clearDelegatesAndCancel];
    }
    RELEASE(_request);
    [super dealloc];
}
@end
