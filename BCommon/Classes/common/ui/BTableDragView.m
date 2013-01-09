//
//  BTableHeaderDragView.m
//  iLook
//
//  Created by Zhang Yinghui on 11-8-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BTableDragView.h"
#import <QuartzCore/QuartzCore.h>
#import "G.h"
#import "Utils.h"
#import "UIUtils.h"

#define UPDATEARROW_HEIGHT	65.0
#define INDICATOR_TEXT_PULLING			@"下拉即可更新..."
#define INDICATOR_TEXT_PULLBEYOND		@"释放立即更新..."
#define INDICATOR_TEXT_LOADING			@"正在更新..."
#define UPDATE_TEXT_LOADOK_FORMAT		@"最后更新:MM-dd HH:mm:ss"
#define UPDATE_TEXT_LOADERROR			@"更新失败"
@interface BTableDragView()

- (void) flipArrow;
- (void) showActivity:(BOOL)flag;

@end

@implementation BTableDragView
@synthesize state = _state;

- (id)initWithFrame:(CGRect)frame toUp:(BOOL)toUp{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_arrowUp = toUp;
		float W = frame.size.width,H = frame.size.height;
		
		
		CGRect r = CGRectMake(0.0f, H - 48.0f, W, 20.0f );
		_stateLabel = [createLabel(r,[UIFont systemFontOfSize:14],nil,[UIColor blackColor],[UIColor whiteColor],CGSizeMake(0, -1),UITextAlignmentCenter,0,UILineBreakModeWordWrap) retain];
		_stateLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
		[self addSubview:_stateLabel];
		
		r.origin.y += 20;
		_updatedLabel = [createLabel(r,[UIFont systemFontOfSize:12],nil,[UIColor colorWithWhite:0.3 alpha:1],nil,CGSizeZero,UITextAlignmentCenter,0,UILineBreakModeWordWrap) retain];
		_updatedLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
		[self addSubview:_updatedLabel];
		
		float w = W>240?240:W;
		UIImage *_img = [UIImage imageNamed:gImgDropUpdate];
		r = CGRectMake((frame.size.width-w)/2, frame.size.height - UPDATEARROW_HEIGHT, 30.0f, 55.0f);
		_arrowImg = [[UIImageView alloc]  initWithFrame:r];
		_arrowImg.contentMode = UIViewContentModeScaleAspectFit;
		_arrowImg.image = _img;
		[_arrowImg layer].transform = CATransform3DMakeRotation(M_PI*(_arrowUp?2:1), 0.0f, 0.0f, 1.0f);
		[self addSubview:_arrowImg];
		
		_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_indicatorView.frame = CGRectMake( (frame.size.width-w)/2, frame.size.height - 38.0f, 20.0f, 20.0f );
		_indicatorView.hidesWhenStopped  = YES;
		[self addSubview:_indicatorView];
    }
    return self;
}
- (float)visibleHeight{
	return UPDATEARROW_HEIGHT;
}
- (void) setState:(int)status{
	if (status == _state)  
		return;
	switch (status) {
		case DragDropStateUnInit:
			_stateLabel.text = NSLocalizedString(@"Drop for update", nil);
			break;
		case DragDropStatePulling:
			if (_isFlipped) {
				[self flipArrow];
			}
			_stateLabel.text = NSLocalizedString(@"Drop for update", nil);
			break;
		case DragDropStatePullBeyond:
			if (!_isFlipped) {
				[self flipArrow];
			}
			_stateLabel.text = NSLocalizedString(@"Release for update", nil);
			break;
		case DragDropStateRelease:
			if (_isFlipped) {
				[self flipArrow];
			}
			break;			
		case DragDropStateLoading:
			[self showActivity:YES];
			_stateLabel.text = NSLocalizedString(@"Loading...", nil);;
			break;
		case DragDropStateLoadOk:
			[self showActivity:NO];
			_stateLabel.text = NSLocalizedString(@"Drop for update", nil);;
			_updatedLabel.text = [Utils format:UPDATE_TEXT_LOADOK_FORMAT time:[[NSDate date] timeIntervalSince1970]];
			break;
		case DragDropStateLoadError:
			[self showActivity:NO];
			_stateLabel.text = NSLocalizedString(@"Drop for update", nil);;
			_updatedLabel.text = NSLocalizedString(@"Update Fail!", nil);;
			break;
		default:
			break;
	}
	_state = status;
}
- (void)flipArrow {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: .3 ];
	[_arrowImg layer].transform = CATransform3DMakeRotation(M_PI * (_isFlipped?2:1), 0.0f, 0.0f, 1.0f);
	[UIView commitAnimations];
	
	_isFlipped = !_isFlipped;
}
- (void)showActivity:(BOOL)flag {
	if (flag) {
		[_indicatorView startAnimating];
		_arrowImg.hidden = YES;
		
	} else {
		[_indicatorView stopAnimating];
		_arrowImg.hidden = NO;
	}	
}
- (void)dealloc {
	RELEASE(_stateLabel);
	RELEASE(_updatedLabel );
	RELEASE(_arrowImg );
	RELEASE(_indicatorView );
    [super dealloc];
}


@end
