//
//  BPhotoScrollView.h
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-3.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XUIImageView.h"

@interface BPhotoScrollView : UIControl
@property (nonatomic, retain) XUIImageView *imgView;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) NSString *smallPic;
@property (nonatomic, retain) NSString *bigPic;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) BOOL canShowFullScreen;
@property (nonatomic, assign) BOOL autoRemove;
- (void)viewFullScreen:(id)sender;
@end
