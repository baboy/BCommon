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
@property (nonatomic, strong) BHttpRequestOperation *operation;
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
    [super setImageURL:url withImageLoadedCallback:^(NSURL *imageURL, NSString *filePath, NSError *error) {
        if (filePath)
            [self setImageAndNotify:[UIImage imageWithContentsOfFile:filePath]];
    }];
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
        [self.target performSelector:self.action withObject:self];
    }
}
- (void)addTarget:(id)target action:(SEL)action{
    self.userInteractionEnabled = YES;
    self.target = target;
    self.action = action;
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)] autorelease];
    [self addGestureRecognizer:tap];
}
- (id)setImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage withImageLoadedCallback:(void (^)(NSURL *imageURL, NSString *filePath, NSError *error))callback{
    if (self.operation && ![self.operation isCancelled]) {
        self.operation.completionBlock = nil;
        [self.operation cancel];
    }
    self.operation = [super setImageURL:imageURL placeholderImage:placeholderImage withImageLoadedCallback:callback];
    return self.operation;
}
- (void)dealloc{
    [super dealloc];
}
@end
