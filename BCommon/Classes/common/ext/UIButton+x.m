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
- (void)setImageURL:(NSURL *)imageURL background:(BOOL)flag forState:(UIControlState)state{
    if (!imageURL) {
        return;
    }
    UIImage *image = nil;
    if ( [imageURL isFileURL] ) {
        image = [UIImage imageWithContentsOfFile:[imageURL path]];
    }else{
        NSString *fp = [UIImageView cachePathForURL:imageURL];
        if ([fp fileExists]) {
            image = [UIImage imageWithContentsOfFile:fp];
        }
    }
    if (image) {
        if (flag) {
            [self setBackgroundImage:image forState:state];
        }else{
            [self setImage:image forState:state];
        }
        return;
    }
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:imageURL parameters:nil];
    BHttpRequestOperation *operation =
    [client dataRequestWithURLRequest:request
                              success:^(BHttpRequestOperation *operation, id data) {
                                  NSDictionary *userInfo = [operation userInfo];
                                  id object = userInfo?[userInfo valueForKey:@"object"]:nil;
                                  NSString *fp = operation.cacheFilePath;
                                  if (self == object) {
                                      UIControlState state = [[userInfo valueForKey:@"state"] intValue];
                                      UIImage *image = [UIImage imageWithContentsOfFile:fp];
                                      if (image){
                                          if (flag) {
                                              [self setBackgroundImage:image forState:state];
                                          }else{
                                              [self setImage:image forState:state];
                                          }
                                      }
                                  }
                              }
                              failure:^(BHttpRequestOperation *request, NSError *error) {
                                  DLOG(@"[UIButton] setImageURL error:%@", error);
                              }];
    id userInfo = @{@"object":self, @"state":[NSNumber numberWithInt:state]};
    [operation setUserInfo:userInfo];
    [operation setRequestCache:[BHttpRequestCache fileCache]];
    [client enqueueHTTPRequestOperation:operation];
}
- (void)setImageURL:(NSURL *)url placeholder:(UIImage*)placeholder background:(BOOL)flag forState:(UIControlState)state{
    if (placeholder) {
        if (flag) {
            [self setBackgroundImage:placeholder forState:state];
        }else{
            [self setImage:placeholder forState:state];
        }
    }
    [self setImageURL:url background:flag forState:state];
}
- (void)setImageURL:(NSURL *)url placeholder:(UIImage*)placeholder forState:(UIControlState)state{
    [self setImageURL:url placeholder:placeholder background:NO forState:state];
}
- (void)setBackgroundImageURL:(NSURL *)imageURL placeholder:(UIImage*)placeholder forState:(UIControlState)state{
    [self setImageURL:imageURL placeholder:placeholder background:YES forState:state];
}
- (void)setImageURL:(NSURL *)imageURL forState:(UIControlState)state{
    [self setImageURL:imageURL placeholder:nil background:NO forState:state];
    
}
- (void)setImageURLString:(NSString *)url forState:(UIControlState)state{
    if (!url) {
        [self setImage:nil forState:state];
        return;
    }
    NSURL *imageURL = isURL(url) ?
                    [NSURL URLWithString:url] :
                    [NSURL fileURLWithPath:url];
    [self setImageURL:imageURL forState:UIControlStateNormal];
}
- (void)setBackgroundImageURL:(NSURL *)imageURL forState:(UIControlState)state{
    [self setImageURL:imageURL placeholder:nil background:YES forState:state];
    
}
@end