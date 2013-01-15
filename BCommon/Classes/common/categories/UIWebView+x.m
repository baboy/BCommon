//
//  UIWebView.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 9/19/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "UIWebView+x.h"

@implementation UIWebView(x)
- (UIScrollView *)contentScrollView{
    if ([self respondsToSelector:@selector(scrollView)]) {
        return [self scrollView];
    }
    for (UIView *v in [self subviews]) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            return (UIScrollView*)v;
        }
    }
    return nil;
}
- (void)removeShadow{
    UIScrollView *scrollView = [self contentScrollView];
    for (UIView *shadowView in [scrollView subviews]) {
        if ([shadowView isKindOfClass:[UIImageView class]]) {
            shadowView.hidden = YES;
        }
    }
}
@end
