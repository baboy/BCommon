//
//  BTabBgView.m
//  iLook
//
//  Created by Zhang Yinghui on 7/11/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "BTabBgView.h"

#define ROUND_SIZE		8
@interface BTabBgView()
- (void) handleTap:(UIGestureRecognizer *)recognizer;
@end

@implementation BTabBgView
@synthesize borderColor,bgColor,borderWidth;
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		borderColor = [[UIColor alloc] initWithWhite:0.6 alpha:0.8];
		bgColor = [[UIColor alloc] initWithWhite:0.3 alpha:0.3];
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void) setBgColor:(UIColor *)_bgColor{
	[bgColor release],bgColor = nil;
	bgColor = [_bgColor retain];
	[self setNeedsDisplay];
}
- (void) setBorderColor:(UIColor *)_borderColor{
	[borderColor release],borderColor = nil;
	borderColor = [_borderColor retain];
	[self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	
	CGContextRef _context = UIGraphicsGetCurrentContext();
	CGRect _rect = rect;
	
	CGFloat minx = CGRectGetMinX(_rect) , midx = CGRectGetMidX(_rect), maxx = CGRectGetMaxX(_rect) ;
	CGFloat miny = CGRectGetMinY(_rect) , midy = CGRectGetMidY(_rect) , maxy = CGRectGetMaxY(_rect) ;
	//
	
	CGContextMoveToPoint(_context, minx, maxy);
	CGContextAddArcToPoint(_context, minx, miny, midx, miny, ROUND_SIZE);
	CGContextAddArcToPoint(_context, maxx, miny, maxx, maxy, ROUND_SIZE);
	CGContextAddLineToPoint(_context, maxx,maxy);
	CGContextAddLineToPoint(_context, minx,maxy);
	CGContextClosePath(_context);
	CGContextSetFillColorWithColor(_context, bgColor.CGColor);
	CGContextDrawPath(_context, kCGPathFill); 
	
	///////
	_rect = CGRectInset(rect, borderWidth/2, borderWidth/2);
	_rect.size.height += borderWidth/2;
	minx = CGRectGetMinX(_rect) , midx = CGRectGetMidX(_rect), maxx = CGRectGetMaxX(_rect) ;
	miny = CGRectGetMinY(_rect) , midy = CGRectGetMidY(_rect) , maxy = CGRectGetMaxY(_rect) ;
	
	CGContextMoveToPoint(_context, minx, maxy);
	CGContextAddArcToPoint(_context, minx, miny, midx, miny, ROUND_SIZE);
	CGContextAddArcToPoint(_context, maxx, miny, maxx, maxy, ROUND_SIZE);
	
	CGContextAddLineToPoint(_context, maxx, maxy);
	//CGContextClosePath(_context);
	CGContextSetStrokeColorWithColor(_context, borderColor.CGColor);
	CGContextSetLineWidth(_context, borderWidth);
	//CGContextDrawPath(_context, kCGPathStroke);
	
	
	CGContextStrokePath(_context);
}

- (void) addTarget:(id)target action:(SEL)action{
	_target = target;
	_action = action;
	UITapGestureRecognizer *_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTap:)];
	_tapRecognizer.numberOfTapsRequired = 1;
	_tapRecognizer.numberOfTouchesRequired = 1;
	[self addGestureRecognizer: _tapRecognizer];
	[_tapRecognizer release];
	
}

- (void) handleTap:(UIGestureRecognizer *)recognizer{
	if (recognizer.state == UIGestureRecognizerStateEnded) {
		if (_target && _action) {
			[_target performSelector:_action withObject:self afterDelay:0];
		}
	}
}
- (void)dealloc {
	[borderColor release],borderColor = nil;
	[bgColor release],bgColor = nil;
    [super dealloc];
}


@end
