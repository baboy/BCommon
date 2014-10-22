//
//  UIWindow+x.m
//  BCommon
//
//  Created by baboy on 10/22/14.
//  Copyright (c) 2014 baboy. All rights reserved.
//

#import "UIWindow+x.h"

@implementation UIWindow(x)

+ (UIWindow*)popWindow {
    static UIWindow *_popWindow = nil;
    static dispatch_once_t initOncePopWindow;
    dispatch_once(&initOncePopWindow, ^{
        _popWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_popWindow setWindowLevel:UIWindowLevelNormal];
    });
    if ([UIScreen mainScreen].bounds.size.height < [UIScreen mainScreen].bounds.size.width) {
        _popWindow.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        _popWindow.center = CGPointMake(_popWindow.bounds.size.width/2, _popWindow.bounds.size.height/2);
        
    }
    return _popWindow;
}
+ (UIWindow*)preViewWindow {
    static UIWindow *_preViewWindow = nil;
    static dispatch_once_t initOncePopWindow;
    dispatch_once(&initOncePopWindow, ^{
        _preViewWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_preViewWindow setWindowLevel:UIWindowLevelNormal];
    });
    if ([UIScreen mainScreen].bounds.size.height < [UIScreen mainScreen].bounds.size.width) {
        _preViewWindow.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        _preViewWindow.center = CGPointMake(_preViewWindow.bounds.size.width/2, _preViewWindow.bounds.size.height/2);
        
    }
    return _preViewWindow;
}
+ (UIWindow*)topWindow {
    static UIWindow *_topWindow = nil;
    static dispatch_once_t initOnceTopWindow;
    dispatch_once(&initOnceTopWindow, ^{
        _topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_topWindow setWindowLevel:UIWindowLevelStatusBar+1];
    });
    return _topWindow;
}
- (void)reset{
    self.hidden = YES;
    self.transform = CGAffineTransformIdentity;
}
- (void)clear{
    self.rootViewController = nil;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
@end
