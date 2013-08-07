//
//  UIImageView+cache.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "XUIImageView.h"

@interface XUIImageView()
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) BHttpRequestOperation *operation;
@end

@implementation XUIImageView
@synthesize object;


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
    if (self.operation) {
        [self.operation cancel];
    }
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:url parameters:nil];
    BHttpRequestOperation *operation = [client dataRequestWithURLRequest:request
                          success:^(BHttpRequestOperation *operation, id data) {
                              NSString *fp = operation.cacheFilePath;
                              [self setImageAndNotify:[UIImage imageWithContentsOfFile:fp]];
                          }
                          failure:^(BHttpRequestOperation *request, NSError *error) {
                              
                          }];
    [operation setRequestCache:[BHttpRequestCache fileCache]];
    [client enqueueHTTPRequestOperation:operation];
    [self setOperation:operation];
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
+ (NSString *)cachePathForURL:(NSURL *)url{
    return [BHttpRequestCache cachePathForURL:url];
}
+ (NSData *)cacheDataForURL:(NSURL *)url{
    return [BHttpRequestCache cacheDataForURL:url];
}
- (void)dealloc{
    if (self.operation) {
        [self.operation cancel];
    }
    RELEASE(_operation);
    [super dealloc];
}
@end
