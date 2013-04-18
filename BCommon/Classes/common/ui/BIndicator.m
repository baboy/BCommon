//
//  BIndacatorView.m
//  iLook
//
//  Created by Zhang Yinghui on 11-7-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BIndicator.h"

static UIView * IndicatorView = nil;
static int IndicatorContentTag = 999;

@implementation BIndicator
+ (UIView *)createIndicator:(BOOL)withIndicator message:(NSString *)msg inView:(UIView *)container{
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    CGSize size = [msg sizeWithFont:font];
    float k = withIndicator?(2*28/2):0;
    float w = sqrt(4*size.width*size.height/3+k*k)+k+10;
    size = [msg sizeWithFont:font constrainedToSize:CGSizeMake(w, CGFLOAT_MAX)];
    float h = size.height + withIndicator?28:0;
    h = MAX(h, w*3/4);
    w = MAX(w, 120);
    CGRect rect = CGRectMake(0, 0, w+20, h+20);    
	UIView *view = [[[UIView alloc] initWithFrame:rect] autorelease];
	view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
	view.layer.cornerRadius = 8.0;
    
    rect = CGRectInset(rect, 10, 10);
    if (withIndicator) {
        UIActivityIndicatorView *aiv = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        [aiv setFrame:CGRectMake(rect.origin.x+(rect.size.width-28)/2, rect.origin.y, 32, 32)];
        [aiv startAnimating];
        [view addSubview:aiv];
        rect.origin.y += 28;
        rect.size.height -= 28;
    }
    UILabel *label = createLabel(rect, font, nil, [UIColor whiteColor], [UIColor blackColor], CGSizeMake(0, -1), UITextAlignmentCenter, 0, UILineBreakModeTailTruncation);
	label.text = msg;
	label.textColor = [UIColor whiteColor];
	[view addSubview:label];
    [view setTag:IndicatorContentTag];
    
    if (IndicatorView && [IndicatorView superview]) {
        [IndicatorView removeFromSuperview];
    }
    RELEASE(IndicatorView);
    IndicatorView = [[UIView alloc] initWithFrame:container.bounds];
    view.center = CGPointMake(IndicatorView.bounds.size.width/2, IndicatorView.bounds.size.height*0.4);
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
+(UIView *)showMessage:(NSString *)msg duration:(float)t{
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    return [BIndicator showMessage:msg duration:t inView:view];
}

+ (UIView *)showMessage:(NSString *)msg inView:(UIView *)view{
    UIView *v = [[[UIView alloc] initWithFrame:view.bounds] autorelease];
    [self createIndicator:YES message:msg inView:v];
	[view addSubview:v];
    IndicatorView = [v retain];
    return v;
}
+ (UIView *)showMessageAndFadeOut:(NSString *)msg{
    return [self showMessage:msg duration:1.0];
}

+ (UIView *)showMessage:(NSString *)msg{
    return [BIndicator showMessage:msg inView:[[UIApplication sharedApplication] keyWindow]];
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
