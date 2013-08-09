//
//  AppBaseViewController.h
//  iShow
//
//  Created by baboy on 13-5-5.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "XUIViewController.h"
#import "SharePlatformView.h"
@interface AppNavigitionController : XUINavigationController
@property (nonatomic, assign) id rootController;
@end

@interface BaseViewController : XUIViewController<ShareViewDelegate>
@property (nonatomic, assign) BOOL canPullBack;
- (void)shareWithContent:(NSString *)content withImagePath:(NSString *)imagePath;
- (void)commentWithPlaceholders:(NSString *)placeholders;
@end
