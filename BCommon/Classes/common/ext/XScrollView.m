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
- (void)awakeFromNib{
    
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGSize contentSize = self.contentSize;
    contentSize.height = MAX(contentSize.height, self.bounds.size.height);
    [self setContentSize:contentSize];
    if (self.isSupportLoadMore) {
        CGRect frame = self.bounds;
        frame.origin.y = MAX(frame.size.height, self.contentSize.height);
        [self.moreView setFrame:frame];
    }
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
    if (!supportLoadMore && _moreView) {
        [self.moreView removeFromSuperview];
        RELEASE(_moreView);
        return;
    }
    [self moreView];
}
- (void)setSupportUpdate:(BOOL)supportUpdate{
    _supportUpdate = supportUpdate;
    if (!supportUpdate && _updateView) {
        [self.updateView removeFromSuperview];
        RELEASE(_updateView);
        return;
    }
    [self updateView];
}
- (void)setContentInset:(UIEdgeInsets)contentInset{
    [super setContentInset:contentInset];
    if (contentInset.top != 0) {
        CGPoint contentOffset = self.contentOffset;
        contentOffset.y -= contentInset.top;
        [self setContentOffset:contentOffset];
    }
}
- (void)updateFinished{
    [self.layer removeAllAnimations];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.contentInset = UIEdgeInsetsZero;
                     }];
	if (self.updateView.state == DragStateLoading) {
		self.updateView.state = DragStateLoadFinished;
	}
    if (self.moreView.state == DragStateLoading) {
        self.moreView.state = DragStateLoadFinished;
    }
}
- (void)startUpdate{
    if (self.isSupportUpdate) {
        [self.layer removeAllAnimations];
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.contentInset = UIEdgeInsetsMake([self.updateView activeHeight]-5, 0.0f, 00.0f, 0.0f);
                         }];
        [self.updateView setState:DragStateLoading];
        if (self.delegate && [self.delegate respondsToSelector:@selector(update:)]) {
            [(id<XScrollViewDelegate>)self.delegate update:self];
        }
    }
    
}
- (void)startLoadMore{
    if (self.isSupportLoadMore) {
        [self.layer removeAllAnimations];
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, [self.moreView activeHeight] - 5 , 0.0f);
                         }];
        [self.moreView setState:DragStateLoading];
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

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    float oh = scrollView.contentOffset.y;
	float oh2 = MAX(scrollView.contentSize.height,scrollView.bounds.size.height) - scrollView.bounds.size.height;
    
    if (self.supportUpdate && scrollView.dragging && oh < 0) {
		if ( oh < -[self.updateView activeHeight]) {
			self.updateView.state = DragStateDragBeyond;
		}else{
			self.updateView.state = DragStateDraging;
		}
        DLOG(@"scrollViewDidScroll:%d",self.updateView.state);
	}
    if (self.isSupportLoadMore && scrollView.dragging && oh > oh2){
        if ( (oh-oh2) >  [self.moreView activeHeight]) {
			self.moreView.state = DragStateDragBeyond;
        }else{
			self.moreView.state = DragStateDraging;
        }
    }
}
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if ([self isSupportUpdate] && scrollView.contentOffset.y < -[self.updateView activeHeight]) {
		[self startUpdate];
	}
    if ([self isSupportLoadMore]  && (MAX(scrollView.contentSize.height,scrollView.bounds.size.height) - scrollView.bounds.size.height) <   scrollView.contentOffset.y){
        [self startLoadMore];
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
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		float W = frame.size.width,H = frame.size.height;
		
		
        CGRect contentFrame = CGRectMake(frame.size.width/2-300/2, H-DragActiveAreaHeight, 300.0, DragActiveAreaHeight);
        self.contentView = [[UIView alloc]  initWithFrame:contentFrame];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        CGRect labelFrame = CGRectMake(0, (contentFrame.size.height-48)/2, contentFrame.size.width, 24);
		self.stateLabel = createLabel(labelFrame,[UIFont systemFontOfSize:14], nil,[UIColor blackColor],[UIColor whiteColor],CGSizeMake(0, -1),UITextAlignmentCenter,0,UILineBreakModeWordWrap);
		self.stateLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
		[self.contentView addSubview:self.stateLabel];
		
		labelFrame.origin.y += 20;
		self.dateLabel = createLabel(labelFrame,[UIFont systemFontOfSize:12],nil,[UIColor colorWithWhite:0.3 alpha:1],nil,CGSizeZero,UITextAlignmentCenter,0,UILineBreakModeWordWrap) ;
		self.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
		[self.contentView addSubview:self.dateLabel];
		
		float minWidth = W > 240 ? 240 : W;
		UIImage *arrow = [UIImage imageNamed:@"dropdown_arrow"];
        CGRect arrowFrame = CGRectMake((contentFrame.size.width - minWidth)/2, (contentFrame.size.height - arrow.size.height)/2, arrow.size.width, arrow.size.height);
		self.arrowImgView = AUTORELEASE([[UIImageView alloc]  initWithFrame:arrowFrame]);
		self.arrowImgView.contentMode = UIViewContentModeScaleAspectFit;
		self.arrowImgView.image = arrow;
		[self.contentView addSubview:self.arrowImgView];
		
		self.indicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
		self.indicatorView.frame = CGRectMake( (contentFrame.size.width-minWidth)/2, (contentFrame.size.height - 20.0f)/2, 20.0f, 20.0f );
		self.indicatorView.hidesWhenStopped  = YES;
		[self.contentView addSubview:self.indicatorView];
        [self addSubview:self.contentView];
        [self setState:DragStateUnInit];
    }
    return self;
}
- (void)rotate:(CGFloat) arc{
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.arrowImgView layer].transform = CATransform3DMakeRotation(arc, 0.0f, 0.0f, 1.0f);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
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
- (void)setIndicatorAnimating:(BOOL)flag{
    [self.arrowImgView setHidden:flag];
    flag?[self.indicatorView startAnimating]:[self.indicatorView stopAnimating];
}
- (void) setState:(int)state{
	if (state == _state && state != DragStateUnInit)
		return;
    DLOG(@"dragView state:%d",state);
	switch (state) {
		case DragStateUnInit:
        case DragStateDraging:
			[self rotate:self.arc];
			self.stateLabel.text = self.location == DragLocationTop?
                                NSLocalizedString(@"向下拖拽更新...", nil):
                                NSLocalizedString(@"向上拖拽加载更多...", nil);
			break;
		case DragStateDragBeyond:
			[self rotate:self.arc+M_PI];
			self.stateLabel.text = self.location == DragLocationTop?
                                NSLocalizedString(@"释放立即更新...", nil):
                                NSLocalizedString(@"释放加载更多...", nil);
			break;
		case DragStateRelease:
			[self rotate:self.arc];
			break;
		case DragStateLoading:
			[self setIndicatorAnimating:YES];
			self.stateLabel.text = NSLocalizedString(@"正在加载...", nil);;
			break;
		case DragStateLoadFinished:
			[self setIndicatorAnimating:NO];
			self.stateLabel.text = self.location == DragLocationTop?
                                NSLocalizedString(@"向下拖拽更新...", nil):
                                NSLocalizedString(@"向上拖拽加载更多...", nil);
			self.dateLabel.text = [Utils format:@"最后更新:MM-dd HH:mm:ss" time:[[NSDate date] timeIntervalSince1970]];
			break;
		case DragStateLoadError:
			[self setIndicatorAnimating:NO];
			self.stateLabel.text = self.location == DragLocationTop?
                                NSLocalizedString(@"向下拖拽更新...", nil):
                                NSLocalizedString(@"向上拖拽加载更多...", nil);
			self.dateLabel.text = NSLocalizedString(@"更新失败!", nil);;
			break;
		default:
			break;
	}
	_state = state;
}


@end
