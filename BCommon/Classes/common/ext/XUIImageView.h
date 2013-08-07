//
//  UIImageView+cache.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XUIImageViewDelegate;

@interface XUIImageView:UIImageView
@property (nonatomic, assign) id object;
@property (nonatomic, assign) id delegate;
- (void)setImageURL:(NSURL *)url;
- (void)setImageURLString:(NSString *)urlString;
- (void)addTarget:(id)target action:(SEL)action;
+ (NSString *)cachePathForURL:(NSURL *)url;
+ (NSData *)cacheDataForURL:(NSURL *)url;
@end

@protocol XUIImageViewDelegate<NSObject>
- (void)imageView:(XUIImageView *)imageView didChangeImage:(UIImage *)image;
@end