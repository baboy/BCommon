//
//  UIImageView+cache.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "UIImageView+cache.h"
@implementation UIImageView(cache)

- (void)setImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage withImageLoadedCallback:(void (^)(NSURL *imageURL, NSString *filePath, NSError *error))callback{
    NSString *fp = [UIImageView cachePathForURL:imageURL];
    if (fp) {
        UIImage *img = [UIImage imageWithContentsOfFile:fp];
        if (img) {
            self.image = img;
            if (callback) {
                callback(imageURL,fp,nil);
            }
            return;
        }
    }
    self.image = placeholderImage;
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:imageURL parameters:nil];
    BHttpRequestOperation *operation = [client dataRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id data) {
                                                                     NSDictionary *userInfo = [operation userInfo];
                                                                     id object = userInfo?[userInfo valueForKey:@"object"]:nil;
                                                                     NSString *fp = operation.cacheFilePath;
                                                                     if (self == object) {
                                                                         [self setImage:[UIImage imageWithContentsOfFile:fp]];
                                                                         if (callback) {
                                                                             callback(imageURL, fp, nil);
                                                                         }
                                                                     }
                                                                 }
                                                                 failure:^(BHttpRequestOperation *request, NSError *error) {
                                                                     
                                                                     if (callback) {
                                                                         callback(imageURL, nil, error);
                                                                     }
                                                                 }];
    [operation setUserInfo:[NSDictionary dictionaryWithObject:self forKey:@"object"]];
    [operation setRequestCache:[BHttpRequestCache fileCache]];
    [client enqueueHTTPRequestOperation:operation];
}
- (void)setImageURL:(NSURL *)imageURL{
    [self setImageURL:imageURL placeholderImage:nil withImageLoadedCallback:nil];
}
- (void)setImageURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage{
    [self setImageURL:imageURL placeholderImage:placeholderImage withImageLoadedCallback:nil];
}

- (void)setImageURL:(NSURL *)imageURL withImageLoadedCallback:(void (^)(NSURL *imageURL, NSString *filePath, NSError *error))callback{
    [self setImageURL:imageURL placeholderImage:nil withImageLoadedCallback:callback];
}

+ (NSString *)cachePathForURL:(NSURL *)imageURL{
    return [BHttpRequestCache cachePathForURL:imageURL];
}
+ (NSData *)cacheDataForURL:(NSURL *)imageURL{
    return [BHttpRequestCache cacheDataForURL:imageURL];
}
@end
