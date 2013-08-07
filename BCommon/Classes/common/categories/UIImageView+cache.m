//
//  UIImageView+cache.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "UIImageView+cache.h"
@implementation UIImageView(cache)

- (void)setImageURL:(NSURL *)imageURL withImageLoadedCallback:(void (^)(NSURL *imageURL, NSString *filePath, NSError *error))callback{
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:imageURL parameters:nil];
    BHttpRequestOperation *operation = [client dataRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id data) {
                                                                     NSString *fp = operation.cacheFilePath;
                                                                     if (self && [self isKindOfClass:[UIImageView class]]) {
                                                                         [self setImage:[UIImage imageWithContentsOfFile:fp]];
                                                                     }
                                                                     if (callback) {
                                                                         callback(imageURL, fp, nil);
                                                                     }
                                                                 }
                                                                 failure:^(BHttpRequestOperation *request, NSError *error) {
                                                                     
                                                                     if (callback) {
                                                                         callback(imageURL, nil, error);
                                                                     }
                                                                 }];
    [operation setRequestCache:[BHttpRequestCache fileCache]];
    [client enqueueHTTPRequestOperation:operation];
}
- (void)setImageURL:(NSURL *)imageURL{
    [self setImageURL:imageURL withImageLoadedCallback:nil];
}
@end
