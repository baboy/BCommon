//
//  SharePlatformViewDelegate.m
//  iShow
//
//  Created by baboy on 13-6-5.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "SharePlatformViewDelegate.h"
#import "UINavigationBar+x.h"
@implementation SharePlatformViewDelegate
+ (id)defaultDelegate{
    static id _defaultSharePlatformViewDelegate = nil;
    static dispatch_once_t initOnceHttpRequestClient;
    dispatch_once(&initOnceHttpRequestClient, ^{
        _defaultSharePlatformViewDelegate = [[SharePlatformViewDelegate alloc] init];
    });
    return _defaultSharePlatformViewDelegate;
}
#pragma mark - ISSShareViewDelegate

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    //[viewController.navigationController.navigationBar setBackgroundImage:];
    viewController.navigationItem.rightBarButtonItem = nil;
}

- (void)view:(UIViewController *)viewController autorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation shareType:(ShareType)shareType
{
    
}

@end
