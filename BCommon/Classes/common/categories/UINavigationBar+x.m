//
//  XUINavigationBar.m
//  itv
//
//  Created by Zhang Yinghui on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBar+x.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+x.h"

#define NavBgViewTag    999

@implementation UINavigationBar (x)  
- (void)drawCustomBackgroundInRect:(CGRect)rect content:(CGContextRef)ctx{
    UIImage *image = [UIImage imageNamed:@"top_bg.png"]; 
    if (!image) {
        [super drawRect:rect];
        return;
    }
    float alpha = 1.0;
    if (self.barStyle == UIBarStyleBlackTranslucent || self.translucent) {
        alpha = 0.5;
    }
    if (self.tag>0) {
        alpha = self.tag/100.0;
    }
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModeNormal alpha:alpha]; 
}
- (void)setTag:(NSInteger)tag{
    [super setTag:tag];
    [self setNeedsDisplay];
}
- (void)setBackgroundAlpha:(float)alpha{
    [self setTag:(alpha*100)];
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *bgImg = [UIImage imageNamed:@"top_bg.png"];        
        [self setBackgroundImage:[bgImg imageWithAlpha:alpha] forBarMetrics:UIBarMetricsDefault];
    }
}
- (void)drawSystemBackgroundInRect:(CGRect)rect content:(CGContextRef)ctx{
    float alpha = self.barStyle == UIBarStyleBlackTranslucent?0.5:1;
    NSArray *colors = [NSArray arrayWithObjects:[UIColor colorWithWhite:0.6 alpha:alpha],
                        [UIColor colorWithWhite:0.3 alpha:alpha] ,
                        [UIColor colorWithWhite:0.2 alpha:alpha] ,
                        [UIColor colorWithWhite:0 alpha:alpha], nil];
    CGFloat loctions[] = {0, 0.5, 0.5, 1.0};
	CGGradientRef grad = createGradient(ctx, colors,loctions);
	CGContextDrawLinearGradient(ctx, grad,rect.origin,CGPointMake(rect.origin.x, rect.origin.y+rect.size.height), kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(grad);
}
- (void)setBackgroundImage:(UIImage*)bgImg{
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
        return;
    }
    
    BOOL flag = NO;
    UIView *bgView = [self viewWithTag:NavBgViewTag];
    if (bgView) {
        [bgView removeFromSuperview];
    }
    for (UIView *v in self.subviews) {
        //DLOG(@"nav bar:%@",v);
        if ([NSStringFromClass([v class]) isEqualToString:@"UINavigationBarBackground"]) {
            UIImageView *imgView = [[[UIImageView alloc] initWithFrame:v.bounds] autorelease];
            [imgView setTag:NavBgViewTag];
            [imgView setImage:bgImg];
            [v addSubview:imgView];
            [v bringSubviewToFront:imgView];
            flag = YES;
            break;
        }
    }
    if (!flag) {
        UIImageView *imgView = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        [imgView setTag:NavBgViewTag];
        [imgView setImage:bgImg];
        [self addSubview:imgView];
        [self sendSubviewToBack:imgView];
    }
}
- (void)didAddSubview:(UIView *)subview{
    UIView *bgView = [self viewWithTag:NavBgViewTag];
    if (bgView) {
        [self sendSubviewToBack:bgView];
    }
}
/*
- (void)drawRect:(CGRect)rect {  
    NSLog(@"draw rect");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (self.barStyle == UIBarStyleDefault || self.barStyle == UIBarStyleBlackTranslucent) {
        [self drawCustomBackgroundInRect:rect content:ctx];
    }else{
        [self drawSystemBackgroundInRect:rect content:ctx];
    }
} 
*/
@end  
