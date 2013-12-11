//
//  BPhotoScrollView.h
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-3.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XUIImageView.h"

@interface BPhotoView : UIButton
@property (nonatomic, retain) id userInfo;
@property (nonatomic, retain) NSString *thumbnail;
@property (nonatomic, retain) NSString *origin;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) BOOL canShowFullScreen;
@property (nonatomic, assign) BOOL autoRemove;
- (void)viewFullScreen:(id)sender;
@end