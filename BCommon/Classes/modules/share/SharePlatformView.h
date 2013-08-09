//
//  SharePlatformView.h
//  iShow
//
//  Created by baboy on 13-7-2.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "XUIView.h"
#import "ShareUtils.h"
#import "ShareView.h"
@class SharePlatformView;
@protocol SharePlatformViewDelegate <NSObject>
@optional
- (void)sharePlatformView:(SharePlatformView*)shareView willSelectSharePlatform:(SharePlatform *)platform;
- (void)sharePlatformView:(SharePlatformView*)shareView didSelectedSharePlatform:(SharePlatform *)platform;
@end

@interface SharePlatformView : XUIView
@property (nonatomic, assign) id<ShareViewDelegate> delegate;
@property (nonatomic, assign) BOOL autoShare;
@property (nonatomic, retain) NSString *shareContent;
@property (nonatomic, retain) NSString *shareImagePath;
+ (id)sharePlatformView;
- (void)show;
@end
