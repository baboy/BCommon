//
//  BIndacatorView.h
//  iLook
//
//  Created by Zhang Yinghui on 11-7-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BIndicator : NSObject {

}
+ (UIView *)showMessage:(NSString *)msg duration:(float) t inView:(UIView *)view;
+ (UIView *)showMessage:(NSString *)msg duration:(float) t;
+ (UIView *)showMessageAndFadeOut:(NSString *)msg;
+ (UIView *)showMessage:(NSString *)msg inView:(UIView *)view;
+ (UIView *)showMessage:(NSString *)msg;
+ (void)fadeOut;
+ (void)fadeOutWithDelay:(float)t;
@end
