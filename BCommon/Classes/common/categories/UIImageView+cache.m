//
//  UIImageView+cache.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "UIImageView+cache.h"
@implementation UIImageView(cache)
- (void)setImageURL:(NSURL *)url{
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:url parameters:nil];
    BHttpRequestOperation *operation = [client dataRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id data) {
                                                                     if (self && [self isKindOfClass:[UIImageView class]]) {
                                                                         NSString *fp = operation.cacheFilePath;
                                                                         [self setImage:[UIImage imageWithContentsOfFile:fp]];
                                                                     }
                                                                 }
                                                                 failure:^(BHttpRequestOperation *request, NSError *error) {
                                                                     
                                                                 }];
    [operation setRequestCache:[BHttpRequestCache fileCache]];
    [operation start];
}
@end
