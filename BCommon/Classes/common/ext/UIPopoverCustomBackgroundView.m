//
//  UIPopoverCustomBackgroundView.m
//  iVideoForiPad
//
//  Created by baboy on 13-11-30.
//  Copyright (c) 2013年 tvie. All rights reserved.
//

#import "UIPopoverCustomBackgroundView.h"



@implementation UIPopoverCustomBackgroundView : UIPopoverBackgroundView

@synthesize arrowOffset=_arrowOffset, arrowDirection = _arrowDirection;
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
+(UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake(10, 10 , 10, 10);
}
+ (BOOL) wantsDefaultContentAppearance{
    return NO;
}

+ (CGFloat)arrowHeight{
    return 25.0f;
}
+ (CGFloat)arrowBase{
    return 25.0f;
}

- (CGFloat) arrowOffset {
    return _arrowOffset;
}

- (void) setArrowOffset:(CGFloat)arrowOffset {
    _arrowOffset = arrowOffset;
}

- (UIPopoverArrowDirection)arrowDirection {
    return _arrowDirection;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;
}

- (void)drawRect:(CGRect)rect{
    float rad = 5.0f;
    float hpadding = 5, vpadding = 5;
    CGRect r = rect;
	float minx = CGRectGetMinX(r)+hpadding, midx = CGRectGetMidX(r), maxx = CGRectGetMaxX(r)-hpadding;
	float miny = CGRectGetMinY(r)+vpadding, midy = CGRectGetMidY(r), maxy = CGRectGetMaxY(r)-vpadding;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 2.0, [UIColor colorWithWhite:0 alpha:0.8].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:1.0 alpha:1.0].CGColor);
    CGPoint p1 = {0,0}, p0 = {0,0}, p2 = {0,0};
    switch (self.arrowDirection) {
        case UIPopoverArrowDirectionUp:{
            p0.x = (maxx+minx)/2+self.arrowOffset;
            p1.x = p0.x-[UIPopoverCustomBackgroundView arrowBase]/2;
            p1.y = p0.y+[UIPopoverCustomBackgroundView arrowHeight];
            p2.x = (p1.x +[UIPopoverCustomBackgroundView arrowBase]);
            p2.y = p1.y;
            CGContextMoveToPoint(ctx, p1.x, p1.y);
            CGContextAddLineToPoint(ctx, p0.x, p0.y);
            CGContextAddLineToPoint(ctx, p2.x, p2.y);
            CGContextAddArcToPoint(ctx, maxx, p1.y, maxx, midy, rad);
            CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, rad);
            CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, rad);
            CGContextAddArcToPoint(ctx, minx, p1.y, p1.x, p1.y, rad);
            break;
        }
        case UIPopoverArrowDirectionDown:{
            p0.x = (maxx+minx)/2+self.arrowOffset;
            p0.y = maxy;
            p1.x = p0.x-[UIPopoverCustomBackgroundView arrowBase]/2;
            p1.y = p0.y-[UIPopoverCustomBackgroundView arrowHeight];
            p2.x = (p1.x +[UIPopoverCustomBackgroundView arrowBase]);
            p2.y = p1.y;
            CGContextMoveToPoint(ctx, p1.x, p1.y);
            CGContextAddLineToPoint(ctx, p0.x, p0.y);
            CGContextAddLineToPoint(ctx, p2.x, p2.y);
            
            CGContextAddArcToPoint(ctx, maxx, p1.y, maxx, midy, rad);
            CGContextAddArcToPoint(ctx, maxx, miny, midx, miny, rad);
            CGContextAddArcToPoint(ctx, minx, miny, minx, midy, rad);
            CGContextAddArcToPoint(ctx, minx, p1.y, p1.x, p1.y, rad);
            break;
        }
        case UIPopoverArrowDirectionLeft:{
            p0.x = minx;
            p0.y = (miny+maxy)/2+self.arrowOffset;
            p1.x = p0.x+[UIPopoverCustomBackgroundView arrowHeight];
            p1.y = p0.y-[UIPopoverCustomBackgroundView arrowBase]/2;
            p2.x = p1.x;
            p2.y = (p1.y +[UIPopoverCustomBackgroundView arrowBase]);
            CGContextMoveToPoint(ctx, p1.x, p1.y);
            CGContextAddLineToPoint(ctx, p0.x, p0.y);
            CGContextAddLineToPoint(ctx, p2.x, p2.y);
            
            CGContextAddArcToPoint(ctx, p2.x, maxy, midx, maxy, rad);
            CGContextAddArcToPoint(ctx, maxx, maxy, maxx, midy, rad);
            CGContextAddArcToPoint(ctx, maxx, miny, midx, miny, rad);
            CGContextAddArcToPoint(ctx, p1.x, miny, p1.x, p1.y, rad);
            break;
        }
        case UIPopoverArrowDirectionRight:{
            p0.x = maxx;
            p0.y = (miny+maxy)/2+self.arrowOffset;
            p1.x = p0.x-[UIPopoverCustomBackgroundView arrowHeight];
            p1.y = p0.y-[UIPopoverCustomBackgroundView arrowBase]/2;
            p2.x = p1.x;
            p2.y = (p1.y +[UIPopoverCustomBackgroundView arrowBase]);
            CGContextMoveToPoint(ctx, p1.x, p1.y);
            CGContextAddLineToPoint(ctx, p0.x, p0.y);
            CGContextAddLineToPoint(ctx, p2.x, p2.y);
            
            CGContextAddArcToPoint(ctx, p2.x, maxy, midx, maxy, rad);
            CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, rad);
            CGContextAddArcToPoint(ctx, minx, miny, midx, miny, rad);
            CGContextAddArcToPoint(ctx, p1.x, miny, p1.x, p1.y, rad);
            break;
        }
            
        default:
            break;
    }
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
}
- (void)didMoveToSuperview{
    DLOG(@"");
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.shadowPath = nil;
    self.layer.shadowRadius = 0;
    self.layer.shadowOpacity = 0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
}
@end
