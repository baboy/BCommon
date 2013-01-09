//
//  BTableLoadMoreView.m
//  itv
//
//  Created by Zhang Yinghui on 11-10-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BTableLoadMoreView.h"
#import "G.h"
#import "UIUtils.h"
//#import "Theme.h"

#define BTM_LABEL_TEXT_LOADING	@"正在加载更多条目"
#define BTM_LABEL_TEXT_STOP		@"加载更多条目"
@interface BTableLoadMoreView()
@property (nonatomic, retain) NSLock *lock;
@end

@implementation BTableLoadMoreView
@synthesize state = _state;
@synthesize lock = _lock;

- (id)initWithFrame:(CGRect)frame {
    
    if ( self = [super initWithFrame:frame]) {
        // Initialization code.
		self.backgroundColor = [UIColor clearColor];
		_label = [createLabel(CGRectZero,[UIFont systemFontOfSize:14],nil,gTableTitleColor,[UIColor colorWithWhite:0 alpha:0.6],CGSizeMake(0, -1),UITextAlignmentCenter,0,UILineBreakModeWordWrap) retain] ;
		_label.text = BTM_LABEL_TEXT_STOP;
		[self addSubview:_label];
		
		_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_indicatorView.frame = CGRectMake( 0, 0, 20.0f, 20.0f );
		_indicatorView.hidesWhenStopped  = YES;
		[self addSubview:_indicatorView];		
    }
    return self;
}
- (void)setState:(int)state{
    [_lock lock];
    _state = state;
    [_lock unlock];
}
- (int)state{
    int sta = 0;
    [_lock lock];
    sta = _state;
    [_lock unlock];
    return sta;
}
- (void) layoutSubviews{
	[super layoutSubviews];
	float W = self.bounds.size.width,H = self.bounds.size.height;
	CGRect r = CGRectMake((W-120)/2, (H-20)/2-5, 120, 20);
	_label.frame = r;
	r = _indicatorView.frame;
	r.origin = CGPointMake(_label.frame.origin.x-20,_label.frame.origin.y);
	_indicatorView.frame = r;
}
- (void) start{
	[_indicatorView startAnimating];
	_label.text = BTM_LABEL_TEXT_LOADING;
	[self setState:1];
}
- (void) stop{
	[_indicatorView stopAnimating];
	_label.text = BTM_LABEL_TEXT_STOP;
	[self setState:0];
}

- (BOOL) isLoading{
	return [self state] == 1;
}
- (void)dealloc {
	RELEASE(_label);
	RELEASE(_indicatorView);
    RELEASE(_lock);
    [super dealloc];
}
@end
