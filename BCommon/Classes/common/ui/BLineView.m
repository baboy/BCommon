//
//  LineView.m
//  iLook
//
//  Created by Zhang Yinghui on 7/1/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "BLineView.h"

@interface BLineView()
- (void)setup;
@end

@implementation BLineView
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.lineWidth = 0.5;
        if (self.tag)
            self.lineWidth = self.tag;
        [self setup];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame lines:(NSArray *)lines {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = 0.5;
        [self setup];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = 0.5;
        [self setup];
    }
    return self;
}
- (void)setup{    
    self.backgroundColor = [UIColor clearColor];
    [self setColors:[NSArray arrayWithObjects:gLineTopColor,gLineBottomColor, nil]];
}
- (void) setLines:(NSArray *)lines{
	if (lines != _lines) {
		RELEASE(_lines);
		_lines = [lines retain];
		[self setNeedsDisplay];
	}
}
- (void) setColors:(NSArray *)colors{
	int n = [colors count];
	NSMutableArray *lines = [NSMutableArray arrayWithCapacity:n];
    float y = self.lineWidth/2.0;
	for (int i=0; i<n; i++) {
		UIColor *color = [colors objectAtIndex:i];
		CGPoint p1 = CGPointMake(0, y);
		CGPoint p2 = CGPointMake(self.bounds.size.width, y);
		NSArray *line = [NSArray arrayWithObjects:NSStringFromCGPoint(p1),NSStringFromCGPoint(p2),color,nil];
		[lines addObject:line];
        y += _lineWidth+0.3;
	}
    [self setLines:lines];
}
- (void)drawRect:(CGRect)rect {
	if (!_lines) {
		return;
	}	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(ctx,false);
	CGContextSetLineWidth(ctx, _lineWidth);
	for ( NSArray *g in _lines ) {
		CGPoint p1 = CGPointFromString([g objectAtIndex:0]);
		CGPoint p2 = CGPointFromString([g objectAtIndex:1]);
		UIColor *color = [g objectAtIndex:2];
		CGContextMoveToPoint(ctx, p1.x, p1.y);
		CGContextAddLineToPoint(ctx, p2.x, p2.y);	
		CGContextSetStrokeColorWithColor(ctx,color.CGColor);
		CGContextDrawPath(ctx, kCGPathStroke);
	}
}


- (void)dealloc {
	[_lines release];
    [super dealloc];
}


@end

@implementation VLine
- (void) setColors:(NSArray *)colors{
	int n = [colors count];
	NSMutableArray *lines = [NSMutableArray arrayWithCapacity:n];
    float x = 0.3;
	for (int i=0; i<n; i++) {
		UIColor *color = [colors objectAtIndex:i];
		CGPoint p1 = CGPointMake(x, 0);
		CGPoint p2 = CGPointMake(x,self.bounds.size.height);
		NSArray *line = [NSArray arrayWithObjects:NSStringFromCGPoint(p1),NSStringFromCGPoint(p2),color,nil];
		[lines addObject:line];
        x += self.lineWidth+0.3;
	}
    [self setLines:lines];
}
@end
