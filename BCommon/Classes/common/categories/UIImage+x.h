//
//  XUIImage.h
//  ITvie
//
//  Created by yinghui zhang on 2/15/11.
//  Copyright 2011 tvie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIUtils.h"
extern UIImage * createImageWithImage(UIImage *originImage, CGSize imageSize, UIColor *shadowColor, CGSize shadowOffset,UIColor *borderColor, int borderWidth, int rad);
extern void createPath(CGContextRef ctx,CGRect rect,float rad);
@interface UIImage (x)
- (UIImage *)resizableWithCapInsets:(UIEdgeInsets)capInsets;
- (UIImage *)resizableWithCenter;
- (UIImage *)scaleToSize:(CGSize) size;  
- (UIImage *)cropToRect:(CGRect) rect;
- (UIImage *)cropToScale:(float) scale;
- (UIImage *)imageWithAlpha:(float) alpha;
- (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)grayImage;
- (UIImage *)maskWithImage:(UIImage *)mask;
- (UIImage *)imageWithShadowColor:(UIColor *)color size:(CGSize)imgSize offset:(CGSize)offset;
- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset;


+(UIImage *) imageWithColor:(UIColor *)color size:(CGSize)imgSize;
+(UIImage *) playButtonWithColor:(UIColor *)color rect:(CGRect)rect;

- (UIImage *)imageWithCornerRadius:(int)rad borderColor:(UIColor *)borderColor size:(CGSize)imgSize;
- (UIImage *)imageRotatedByDegrees:(float)degrees;
@end  

extern CGGradientRef createGradient(CGContextRef ctx,NSArray *colors,CGFloat locations[]);
extern UIImage * createButtonBg(UIColor *bgColor,UIColor* borderColor,CGSize imgSize);
UIImage * createGradientButtonBg(NSArray *bgColors,CGFloat locations[],UIColor* borderColor,CGSize imgSize,float rad);


@interface UIImage (fixOrientation)
- (UIImage *)fixOrientation;
@end 