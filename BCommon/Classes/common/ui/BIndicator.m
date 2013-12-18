//
//  BIndacatorView.m
//  iLook
//
//  Created by Zhang Yinghui on 11-7-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BIndicator.h"
#define BIndicatorTextFont  [UIFont boldSystemFontOfSize:16]
#define BIndicatorAnimateWidth  32
#define BIndicatorBackgroundColor   [UIColor colorWithWhite:0.2 alpha:0.8]

static UIView * IndicatorView = nil;
static int IndicatorContentTag = 999;

@implementation BIndicator
+ (UIView *)createIndicator:(BOOL)withIndicator icon:(UIImage *)icon message:(NSString *)msg inView:(UIView *)container{
    float iconWidth = 0;
    float iconHeight = 0;
    if (icon) {
        withIndicator = NO;
    }
    if (withIndicator) {
        iconWidth = BIndicatorAnimateWidth;
        iconHeight = BIndicatorAnimateWidth;
    }else if (icon) {
        iconWidth = 2*BIndicatorAnimateWidth;
        iconHeight = BIndicatorAnimateWidth;
    }
    CGSize size = [msg sizeWithFont:BIndicatorTextFont];
    float k = withIndicator?(2*iconWidth/2):0;
    float w = sqrt(4*size.width*size.height/3+k*k)+k+10;
    
    size = [msg sizeWithFont:BIndicatorTextFont constrainedToSize:CGSizeMake(w, CGFLOAT_MAX)];
    float h = size.height + withIndicator?iconWidth:0;
    h = MAX(h, w*3/4);
    w = MAX(w, 120);
    float padding = 10;
    CGRect rect = CGRectMake(0, 0, w+4*padding, h+4*padding);
    if (size.width == 0 && withIndicator) {
        padding = 5;
        rect.size = CGSizeMake(iconWidth+2*padding, iconWidth+2*padding);
    }
    
	UIView *view = AUTORELEASE([[UIView alloc] initWithFrame:rect] );
	view.backgroundColor = BIndicatorBackgroundColor;
	view.layer.cornerRadius = 8.0;
    
    rect = CGRectInset(rect, padding, padding);
    if (withIndicator || icon) {
        CGRect r = CGRectMake(rect.origin.x+(rect.size.width-iconWidth)/2, rect.origin.y, iconWidth, iconHeight);
        UIView *iconView = nil;
        if (withIndicator) {
            iconView = AUTORELEASE([[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]);
            [iconView setFrame:r];
            [(id)iconView startAnimating];
        }else{
            iconView = [[UIButton alloc] initWithFrame:r];
            [(id)iconView setImage:icon forState:UIControlStateNormal];
        }
        
        [view addSubview:iconView];
        rect.origin.y += iconHeight;
        rect.size.height -= iconHeight;
    }
    UILabel *label = createLabel(rect, BIndicatorTextFont, nil, [UIColor whiteColor], [UIColor blackColor], CGSizeMake(0, -1), UITextAlignmentCenter, 0, UILineBreakModeTailTruncation);
	label.text = msg;
	label.textColor = [UIColor whiteColor];
	[view addSubview:label];
    [view setTag:IndicatorContentTag];
    
    if (IndicatorView && [IndicatorView superview]) {
        [IndicatorView removeFromSuperview];
    }
    RELEASE(IndicatorView);
    IndicatorView = [[UIView alloc] initWithFrame:container.bounds];
    IndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.center = CGPointMake(IndicatorView.bounds.size.width/2, IndicatorView.bounds.size.height*0.4);
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    if (container == [self currentWindow]) {
        id rootControllr = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        if (rootControllr) {
            //IndicatorView.transform = CGAffineTransformIdentity;
            //IndicatorView.transform = [rootControllr view].transform;
        }
    }
    [IndicatorView addSubview:view];
    [container addSubview:IndicatorView];
    [container bringSubviewToFront:IndicatorView];
    return  view;
    
}
+ (UIView *)showMessage:(NSString *)msg duration:(float) t inView:(UIView *)view{
    [self createIndicator:NO message:msg inView:view];
	[self fadeOutWithDelay:t];
	return IndicatorView;
	
}
+ (UIWindow *)currentWindow{
    UIWindow *window = nil;
    for (UIWindow * w in [[UIApplication sharedApplication] windows]) {
        window = window?:w;
        if (w.windowLevel > window.windowLevel) {
            window = w;
        }
    }
    return window;
}
+ (UIView *)createIndicator:(BOOL)withIndicator message:(NSString *)msg inView:(UIView *)container{
    return [self createIndicator:withIndicator icon:nil message:msg inView:container];
}
+(UIView *)showMessage:(NSString *)msg duration:(float)t{
    UIView *view = [self currentWindow];
    return [BIndicator showMessage:msg duration:t inView:view];
}

+ (UIView *)showMessage:(NSString *)msg inView:(UIView *)view{
    return [self showMessage:msg icon:nil inView:view];
}
+ (UIView *)showMessageAndFadeOut:(NSString *)msg{
    return [self showMessage:msg duration:1.0];
}
+ (UIView *)showMessage:(NSString *)msg icon:(UIImage *)icon inView:(UIView *)view{
    [self createIndicator:YES icon:icon message:msg inView:view];
    return IndicatorView;
}

+ (UIView *)showMessage:(NSString *)msg{
    return [BIndicator showMessage:msg inView:[self currentWindow]];
}
+ (void)fadeOutWithDelay:(float)t{
    if (!IndicatorView && ![IndicatorView superview]) {
        RELEASE(IndicatorView);
        return;
    }
    [UIView animateWithDuration:0.2 delay:t 
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
                         UIView *contentView = [IndicatorView viewWithTag:IndicatorContentTag];
                         if (!contentView) {
                             return ;
                         }
						 CGAffineTransform _transform = CGAffineTransformMakeScale( 0.1 , 0.1 );
						 [contentView setTransform:_transform];
						 contentView.alpha = 0;
                         
					 } 
					completion :^(BOOL finished){	
                        [IndicatorView removeFromSuperview];
                        RELEASE(IndicatorView);
					}];
}
+ (void)fadeOut{
    [self fadeOutWithDelay:1.0];
}

@end
