//
//  BProgressBar.m
//  itv
//
//  Created by Zhang Yinghui on 11-10-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BProgressBar.h"


@implementation BProgressBar
@synthesize barColor = _barColor;
@synthesize barStartColor = _barStartColor;
@synthesize insideBgColor = _insideBgColor;
@synthesize insideBorderColor = _insideBorderColor;
- (void)setup{
    
    self.backgroundColor = [UIColor clearColor];
    _barColor = [[UIColor colorWithRed:0.0/255.0 green:0/255.0 blue:139.0/255.0 alpha:1] retain];
    _insideBorderColor = [[UIColor colorWithWhite:1 alpha:1] retain];
    _insideBgColor = [[UIColor colorWithWhite:0.85 alpha:1] retain];
    _barStartColor = [[UIColor clearColor] retain];
    self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.layer.borderWidth = 1.0;
    self.clipsToBounds = YES;
}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        [self setup];
    }
    return self;
}
- (void)awakeFromNib{
    [self setup];
}
- (void)setFrame:(CGRect)frame{
	[super setFrame:frame];
	[self setNeedsDisplay];
}
- (void)createProgressPath:(CGContextRef)ctx inRect:(CGRect)r{
	float minx = CGRectGetMinX(r), midx = CGRectGetMidX(r), maxx = CGRectGetMaxX(r);
	float miny = CGRectGetMinY(r), midy = CGRectGetMidY(r), maxy = CGRectGetMaxY(r);
	CGContextMoveToPoint(ctx, minx, midy);
	CGContextAddArcToPoint(ctx, minx, miny, midx, miny, self.layer.cornerRadius);
	CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, self.layer.cornerRadius);
	CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, self.layer.cornerRadius);
	CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, self.layer.cornerRadius);
	CGContextClosePath(ctx);	
	CGContextClip(ctx);
}
- (void)drawRect:(CGRect)rect{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(ctx, false );

	CGRect r = CGRectInset(rect, 2, 2);
	CGFloat minx = CGRectGetMinX(r), midx = CGRectGetMidX(r), maxx = CGRectGetMaxX(r);
	CGFloat miny = CGRectGetMinY(r), midy = CGRectGetMidY(r), maxy = CGRectGetMaxY(r);
	CGContextMoveToPoint(ctx, minx, midy);
	CGContextAddArcToPoint(ctx, minx, miny, midx, miny, self.layer.cornerRadius);
	CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, self.layer.cornerRadius);
	CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, self.layer.cornerRadius);
	CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, self.layer.cornerRadius);
	CGContextSetStrokeColorWithColor(ctx, _insideBorderColor.CGColor);	
	CGContextSetLineWidth(ctx, 1);
	CGContextDrawPath(ctx, kCGPathStroke);
	
	
	r = CGRectInset(rect, 2, 2);
	
	minx = CGRectGetMinX(r), midx = CGRectGetMidX(r), maxx = CGRectGetMaxX(r);
	miny = CGRectGetMinY(r), midy = CGRectGetMidY(r), maxy = CGRectGetMaxY(r);
	CGContextMoveToPoint(ctx, minx, midy);
	CGContextAddArcToPoint(ctx, minx, miny, midx, miny, self.layer.cornerRadius);
	CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, self.layer.cornerRadius);
	CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, self.layer.cornerRadius);
	CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, self.layer.cornerRadius);
	CGContextClosePath(ctx);	
	CGContextSetFillColorWithColor(ctx,_insideBgColor.CGColor);
	CGContextDrawPath(ctx, kCGPathFill);  
	
	float w = r.size.width*self.progress;
	r.size.width = w<1?1:w;
	[self createProgressPath:ctx inRect:r];
	NSArray *_colors = [NSArray arrayWithObjects:_barStartColor,_barColor,nil];
	CGGradientRef _gradient = createGradient(ctx, _colors,NULL);
	CGContextDrawLinearGradient(ctx, _gradient,r.origin,CGPointMake(r.origin.x+r.size.width, r.origin.y), kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(_gradient);
}

- (void)dealloc {
    RELEASE(_insideBgColor);
    RELEASE(_barColor);
    RELEASE(_insideBorderColor);
    RELEASE(_barStartColor);
    [super dealloc];
}


@end
