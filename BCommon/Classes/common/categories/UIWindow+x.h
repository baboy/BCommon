//
//  UIWindow+x.h
//  BCommon
//
//  Created by baboy on 10/22/14.
//  Copyright (c) 2014 baboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow(x)
+ (UIWindow *)popWindow;
+ (UIWindow *)preViewWindow;
+ (UIWindow *)topWindow;
- (void)reset;
- (void)clear;
@end
