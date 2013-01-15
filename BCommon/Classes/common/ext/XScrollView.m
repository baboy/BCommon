//
//  XScrollView.m
//  Pods
//
//  Created by baboy on 1/15/13.
//
//

#import "XScrollView.h"
#import "BCommon.h"


@interface DragView()
@property (nonatomic, retain) UILabel *stateLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UIImageView *arrowImgView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) CGFloat arc;
- (float)activeHeight;
@end

@interface XScrollView()
@property (nonatomic, retain) DragView *updateView;
@property (nonatomic, retain) DragView *moreView;
@end
@implementation XScrollView
- (void)dealloc{
    RELEASE(_updateView);
    RELEASE(_moreView);
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (DragView *) updateView{
    if (!_updateView && self.isSupportUpdate) {
        CGRect frame = self.bounds;
        frame.origin.y = -frame.size.height;
        _updateView = [[DragView alloc] initWithFrame:frame];
        [_updateView setLocation:DragLocationTop];
        [self addSubview:_updateView];
    }
    return _updateView;
}
- (DragView *) moreView{
    if (!_moreView && self.isSupportLoadMore) {
        CGRect frame = self.bounds;
        frame.origin.y = MAX(frame.size.height, self.contentSize.height);
        _moreView = [[DragView alloc] initWithFrame:frame];
        [_moreView setLocation:DragLocationBottom];
        [self addSubview:_moreView];
    }
    return _moreView;
}
- (void)setSupportLoadMore:(BOOL)supportLoadMore{
    _supportLoadMore = supportLoadMore;
    [self updateView];
    if (!supportLoadMore && self.updateView) {
        [self.updateView removeFromSuperview];
        RELEASE(_updateView);
    }
}
- (void)setSupportUpdate:(BOOL)supportUpdate{
    _supportUpdate = supportUpdate;
    [self moreView];
    if (!supportUpdate && self.moreView) {
        [self.moreView removeFromSuperview];
        RELEASE(_moreView);
    }
}

- (void)updateFinished{
    [self.layer removeAllAnimations];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.contentInset = UIEdgeInsetsMake(0, 0.0f, 00.0f, 0.0f);
                     }];
	if (self.updateView.state == DragStateDraging) {
		self.updateView.state = DragStateLoadFinished;
	}
    if (self.moreView.state == DragStateDraging) {
        self.moreView.state = DragStateLoadFinished;
    }
}
- (void)startUpdate{
    if (self.isSupportUpdate) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.contentInset = UIEdgeInsetsMake([self.updateView activeHeight]-5, 0.0f, 00.0f, 0.0f);
                         }];
        [self.updateView setState:DragStateDraging];
        if (self.delegate && [self.delegate respondsToSelector:@selector(update:)]) {
            [(id<XScrollViewDelegate>)self.delegate update:self];
        }
    }
    
}
- (void)startLoadMore{
    if (self.isSupportLoadMore) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, [self.moreView activeHeight]-5, 0.0f);
                         }];
        [self.moreView setState:DragStateDraging];
        if (self.delegate && [self.delegate respondsToSelector:@selector(loadMore:)]) {
            [(id<XScrollViewDelegate>)self.delegate loadMore:self];
        }
    }
}
- (void)setContentSize:(CGSize)contentSize{
    [super setContentSize:contentSize];
    if (self.isSupportLoadMore) {
        CGRect frame = self.bounds;
        frame.origin.y = MAX(frame.size.height, self.contentSize.height);
        [self.moreView setFrame:frame];
    }
}
@end

#define DragActiveAreaHeight    65.0f
@implementation DragView

- (void)dealloc {
	RELEASE(_stateLabel);
	RELEASE(_dateLabel );
	RELEASE(_arrowImgView );
	RELEASE(_indicatorView);
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		float W = frame.size.width,H = frame.size.height;
		
		
        CGRect contentFrame = CGRectMake(0, H-DragActiveAreaHeight, 300.0, DragActiveAreaHeight);
        self.contentView = [[UIView alloc]  initWithFrame:contentFrame];
        
        CGRect labelFrame = CGRectMake(0, (contentFrame.size.height-48)/2, contentFrame.size.width, 24);
		self.stateLabel = createLabel(labelFrame,[UIFont systemFontOfSize:14],nil,[UIColor blackColor],[UIColor whiteColor],CGSizeMake(0, -1),UITextAlignmentCenter,0,UILineBreakModeWordWrap);
		self.stateLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
		[self.contentView addSubview:self.stateLabel];
		
		labelFrame.origin.y += 20;
		self.dateLabel = createLabel(labelFrame,[UIFont systemFontOfSize:12],nil,[UIColor colorWithWhite:0.3 alpha:1],nil,CGSizeZero,UITextAlignmentCenter,0,UILineBreakModeWordWrap) ;
		self.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
		[self.contentView addSubview:self.dateLabel];
		
		float minWidth = W>240?240:W;
		UIImage *arrow = [UIImage imageNamed:@"drag_drop_arrow"];
        CGRect arrowFrame = CGRectMake((W-minWidth)/2, frame.size.height - (DragActiveAreaHeight+arrow.size.height)/2, arrow.size.width, arrow.size.height);
		self.arrowImgView = [[[UIImageView alloc]  initWithFrame:arrowFrame] autorelease];
		self.arrowImgView.contentMode = UIViewContentModeScaleAspectFit;
		self.arrowImgView.image = arrow;
		[self.contentView addSubview:self.arrowImgView];
		
		self.indicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
		self.indicatorView.frame = CGRectMake( (contentFrame.size.width-minWidth)/2, (contentFrame.size.height - 20.0f)/2, 20.0f, 20.0f );
		self.indicatorView.hidesWhenStopped  = YES;
		[self.contentView addSubview:self.indicatorView];
        [self addSubview:self.contentView];
    }
    return self;
}
- (void)rotate:(CGFloat) arc{
    [self.arrowImgView layer].transform = CATransform3DMakeRotation(arc, 0.0f, 0.0f, 1.0f);
}
- (void)setLocation:(DragLocation)location{
    _location = location;
    self.arc = M_PI*((location == DragLocationTop)?2:1);
    [self rotate:self.arc];
    
    CGRect contentFrame = self.contentView.frame;
    contentFrame.origin.y = location == DragLocationTop?(self.bounds.size.height-DragActiveAreaHeight):0;
    [self.contentView setFrame:contentFrame];
    
}
- (float)activeHeight{
	return DragActiveAreaHeight;
}
- (void) setState:(int)state{
	if (state == _state)
		return;
	switch (state) {
		case DragStateUnInit:
			self.stateLabel.text = NSLocalizedString(@"Drop for update", nil);
			break;
		case DragStateDraging:
			[self rotate:self.arc];
			self.stateLabel.text = NSLocalizedString(@"Drop for update", nil);
			break;
		case DragStateDragBeyond:
			[self rotate:self.arc+M_PI];
			self.stateLabel.text = NSLocalizedString(@"Release for update", nil);
			break;
		case DragStateRelease:
			[self rotate:self.arc];
			break;
		case DragStateLoading:
			[self.indicatorView startAnimating];
			self.stateLabel.text = NSLocalizedString(@"Loading...", nil);;
			break;
		case DragStateLoadFinished:
			[self.indicatorView stopAnimating];
			self.stateLabel.text = NSLocalizedString(@"Drop for update", nil);;
			self.dateLabel.text = [Utils format:@"最后更新:MM-dd HH:mm:ss" time:[[NSDate date] timeIntervalSince1970]];
			break;
		case DragStateLoadError:
			[self.indicatorView stopAnimating];
			self.stateLabel.text = NSLocalizedString(@"Drop for update", nil);;
			self.dateLabel.text = NSLocalizedString(@"Update Fail!", nil);;
			break;
		default:
			break;
	}
	_state = state;
}


@end
