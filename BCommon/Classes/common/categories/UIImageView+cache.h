//
//  UIImageView+cache.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(cache)
- (void)setImageURL:(NSURL *)imageURL;
- (void)setImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage;
- (id)setImageURL:(NSURL *)imageURL withImageLoadedCallback:(void (^)(NSURL *imageURL, NSString *filePath, NSError *error))callback;
- (id)setImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage withImageLoadedCallback:(void (^)(NSURL *imageURL, NSString *filePath, NSError *error))callback;

+ (NSString *)cachePathForURL:(NSURL *)imageURL;
+ (NSData *)cacheDataForURL:(NSURL *)imageURL;
@end
