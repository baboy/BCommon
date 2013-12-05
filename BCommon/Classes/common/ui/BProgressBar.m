//
//  BProgressBar.m
//  itv
//
//  Created by Zhang Yinghui on 11-10-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BProgressBar.h"

@interface BProgressBar()
@property (nonatomic, retain) UIColor *backgroundColor_;
@end

@implementation BProgressBar

- (void)setup{
    
    self.backgroundColor = [UIColor clearColor];
    if (!self.barColor && [self respondsToSelector:@selector(tintColor)]){
        self.barColor = self.tintColor;
    }else if(!self.barColor){
        self.barColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    }
    self.clipsToBounds = YES;
}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        [self setup];
        self.padding = 2;
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor_ = self.backgroundColor;
    [self setup];
    self.padding = self.tag;
}
- (void)setFrame:(CGRect)frame{
	[super setFrame:frame];
	[self setNeedsDisplay];
}
- (void)setBorderColor:(UIColor *)borderColor{
    RELEASE(_borderColor);
    _borderColor = [borderColor retain];
    self.layer.borderWidth = 1.0;
    [self.layer setBorderColor:borderColor.CGColor];
}
- (void)setBarColor:(UIColor *)barColor{
    RELEASE(_barColor);
    _barColor = [barColor retain];
    [self setNeedsDisplay];
}
- (void)setProgress:(float)progress{
    _progress = progress;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	//CGContextSetShouldAntialias(ctx, false );
    [self.backgroundColor_ set];
    CGContextFillRect(ctx, rect);
    
    [self.barColor set];
    CGRect barFrame = CGRectInset(rect, self.padding, self.padding);
    barFrame.size.width *= self.progress;
    barFrame.size.width = MAX(barFrame.size.width, 3);
	CGContextFillRect(ctx, barFrame);
}

- (void)dealloc {
    RELEASE(_backgroundColor_);
    RELEASE(_borderColor);
    RELEASE(_barColor);
    [super dealloc];
}
@end
