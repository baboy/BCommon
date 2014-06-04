//
//  UIActionSheet+x.m
//  iVideo
//
//  Created by baboy on 13-12-15.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "UIActionSheet+x.h"

@implementation UIActionSheet(x)
- (void)setTitleColor:(UIColor *)titleColor{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:titleColor forState:UIControlStateNormal];
        }
    }
}
@end
