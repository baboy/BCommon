//
//  XUIView.h
//  iShow
//
//  Created by baboy on 13-5-4.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <UIKit/UIKit.h>
enum {
    XUIViewToggleLocationTop,
    XUIViewToggleLocationLeft,
    XUIViewToggleLocationBottom,
    XUIViewToggleLocationRight,
};
typedef int XUIViewToggleLocation;

enum {
    XUIViewPannelStyleDefault,
    XUIViewPannelStyle2,
    XUIViewPannelStyle3
};

@interface XUIView : UIView
@property (nonatomic, retain) UIImage *backgroundImage;
+ (void)toggleWithView:(UIView *)view1 withView2:(UIView *)view2 withLocation:(XUIViewToggleLocation)location animated:(BOOL)animated;
- (void)setPannelStyleDefault;
- (void)setBackgroundImage:(UIImage *)backgroundImage;
@end
