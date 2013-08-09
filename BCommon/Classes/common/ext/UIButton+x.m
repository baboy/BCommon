//
//  UIButton+x.m
//  iLookForiPad
//
//  Created by baboy on 13-3-20.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "UIButton+x.h"


@implementation UIButton (x)
- (void)centerImageAndTitle:(float)spacing{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0 , 0.0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
}
- (void)centerImageAndTitle{
    [self centerImageAndTitle:3.0];
}
- (void)setImageURL:(NSURL *)imageURL forState:(UIControlState)state{
    
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:imageURL parameters:nil];
    BHttpRequestOperation *operation = [client dataRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id data) {
                                                                     NSDictionary *userInfo = [operation userInfo];
                                                                     id object = userInfo?[userInfo valueForKey:@"object"]:nil;
                                                                     NSString *fp = operation.cacheFilePath;
                                                                     if (self == object) {
                                                                         UIControlState state = [[userInfo valueForKey:@"state"] intValue];
                                                                         [self setImage:[UIImage imageWithContentsOfFile:fp] forState:state];                                                                     }
                                                                 }
                                                                 failure:^(BHttpRequestOperation *request, NSError *error) {
                                                                     DLOG(@"[UIButton] setImageURL error:%@", error);
                                                                 }];
    id userInfo = @{@"object":self, @"state":[NSNumber numberWithInt:state]};
    [operation setUserInfo:userInfo];
    [operation setRequestCache:[BHttpRequestCache fileCache]];
    [client enqueueHTTPRequestOperation:operation];
}
@end