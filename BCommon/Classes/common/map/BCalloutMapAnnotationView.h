//
//  BCalloutMapAnnotationView.h
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-5.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "CalloutMapAnnotationView.h"
#import "BPhotoScrollView.h"
#import "BMapAnnotation.h"

enum {
    BCalloutAnnoViewTapTagBackground = 1,
    BCalloutAnnoViewTapTagPhoto
};

@class BCalloutMapAnnotation;

@interface BCalloutMapAnnotationView : CalloutMapAnnotationView
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *descLabel;
@property (nonatomic, retain) BPhotoScrollView *photoView;
- (void) setPhotoCanFullScreen:(BOOL)canFullScreen;
@end

@interface BCalloutMapAnnotation : BMapAnnotation 
@property (nonatomic, retain) NSString *smallPic; 
@property (nonatomic, retain) NSString *bigPic;
@property (nonatomic, retain) NSString *video;
- (id)initWithAnnotation:(BCalloutMapAnnotation *)annotation;
@end