//
//  BProgressBar.h
//  itv
//
//  Created by Zhang Yinghui on 11-10-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BProgressBar : UIView

@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) UIColor *barColor;
@property (nonatomic, assign) float padding;
@property (nonatomic, assign) float progress;
@end
