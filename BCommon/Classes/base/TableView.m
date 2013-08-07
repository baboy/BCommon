//
//  TableView.m
//  itv
//
//  Created by Zhang Yinghui on 9/28/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "TableView.h"

@interface TableView()

@property (nonatomic, retain) DragView *updateView;
@property (nonatomic, retain) DragView *moreView;
@end

@implementation TableView

- (void)setup{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor clearColor];
    if (self.style != UITableViewStyleGrouped) {
        if (_topLine && [_topLine superview]) {
            [_topLine removeFromSuperview];
        }
        RELEASE(_topLine);
        _topLine = [[BLineView alloc] initWithFrame:CGRectMake(0, -2, self.frame.size.width, 2)];
        _topLine.lineWidth = 0.5;
        _topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_topLine setColors:[NSArray arrayWithObjects:gLineTopColor,gLineBottomColor,nil]];
        //[self addSubview:_topLine];
    }
    [self setScrollsToTop:YES];
}
- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
	self = [super initWithFrame:frame style:style];
	if (self) {
        [self setup];
    }
	return self;
}
- (id) initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame style:UITableViewStylePlain];
	if (self) {
        [self setup];
		
	}
	return self;
}
-(void)awakeFromNib{
    [self setup];
}
- (void)reloadData{
    [super reloadData];
}

- (void)addFormRow:(int)fromRow toRow:(int)toRow forSection:(int)section{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = fromRow; i < toRow; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}
- (NSString *)imageCacheForIndexPath:(NSIndexPath *)indexPath{
	if (!_imgCache) {
		return nil;
	}
	return [_imgCache objectForKey:indexPath];
}
- (NSString *)imageCacheForUrl:(NSString *)url{
	if (!_imgCache) {
		return nil;
	}
	return [_imgCache objectForKey:[url md5]];
}
- (void)cacheImage:(NSString *)imgLocalPath forIndexPath:(NSIndexPath *)indexPath{
	if (!_imgCache) {
		_imgCache = [[NSMutableDictionary dictionaryWithCapacity:[self numberOfRowsInSection:0]] retain];
	}
	[_imgCache setObject:imgLocalPath forKey:indexPath];
}
- (void)cacheImage:(NSString *)imgLocalPath forUrl:(NSString *)url{
	if (!_imgCache) {
		_imgCache = [[NSMutableDictionary dictionaryWithCapacity:[self numberOfRowsInSection:0]] retain];
	}
	[_imgCache setObject:imgLocalPath forKey:[url md5]];
}
- (void) loadImage:(NSString *)imgURL forIndexPath:(NSIndexPath *)indexPath{
	if (!imgURL) {
		return;
	}
	if (!_queue) {
		_queue = [[NSOperationQueue alloc] init];
	}
    NSURL *url = [NSURL URLWithString:[imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    DLOG(@"loadImg:%@",url);
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:url parameters:nil];
    BHttpRequestOperation *operation = [client dataRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id data) {
                                                                     if (self && [self isKindOfClass:[TableView class]]) {
                                                                         NSString *fp = operation.cacheFilePath;
                                                                         
                                                                         NSIndexPath *indexPath = [[operation userInfo] valueForKey:@"indexPath"];
                                                                         [self setImagePath:fp forURL:operation.request.URL forIndexPath:indexPath];
                                                                     }
                                                                 }
                                                                 failure:^(BHttpRequestOperation *request, NSError *error) {
                                                                     DLOG(@"[TableView] loadImage fail:%@",error);
                                                                 }];
    [operation setUserInfo:[NSDictionary dictionaryWithObject:indexPath forKey:@"indexPath"]];
    [operation setRequestCache:[BHttpRequestCache fileCache]];
	[_queue addOperation:operation];
}
- (void)setImagePath:(NSString *)fp forURL:(NSURL *)url forIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didLoadedImageAtPath:forIndexPath:)]) {
        [self.delegate tableView:self didLoadedImageAtPath:fp forIndexPath:indexPath];
        return;
    }
    if (indexPath && [self cellForRowAtIndexPath:indexPath]) {
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        if ([cell respondsToSelector:@selector(setImgFilePath:)]) {
            [cell performSelector:@selector(setImgFilePath:) withObject:fp];
        }else if([cell respondsToSelector:@selector(setImg:)]){
            [cell performSelector:@selector(setImg:) withObject:[UIImage imageWithContentsOfFile:fp]];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:cacheImagePath:forIndexPath:)] ) {
            [self.delegate tableView:self cacheImagePath:fp forIndexPath:indexPath];
        }else{
            [self cacheImage:fp forUrl:[url absoluteString]];
        }
    }
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

- (void)updateFinished{
    //[self.layer removeAllAnimations];
    [UIView animateWithDuration:0.5
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
        if (self.contentInset.top != [self.updateView activeHeight]-5) {
            self.contentInset = UIEdgeInsetsMake([self.updateView activeHeight]-5, 0.0f, 00.0f, 0.0f);
        }
//        [self.layer removeAllAnimations];
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                         }];
        [self.updateView setState:DragStateLoading];
        if (self.delegate && [self.delegate respondsToSelector:@selector(update:)]) {
            [(id<XScrollViewDelegate>)self.delegate update:self];
        }
    }
    
}
- (void)startLoadMore{
    if (self.isSupportLoadMore) {
        self.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, [self.moreView activeHeight] - 5 , 0.0f);
//        [self.layer removeAllAnimations];
//        [UIView animateWithDuration:0.2
//                         animations:^{
//                         }];
        [self.moreView setState:DragStateLoading];
        if (self.delegate && [self.delegate respondsToSelector:@selector(loadMore:)]) {
            [(id<XScrollViewDelegate>)self.delegate loadMore:self];
        }
    }
}
- (void)setContentInset:(UIEdgeInsets)contentInset{
    [super setContentInset:contentInset];
    if (contentInset.top != 0) {
        CGPoint contentOffset = self.contentOffset;
        contentOffset.y -= contentInset.top;
        [self setContentOffset:contentOffset];
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
        //DLOG(@"scrollViewDidScroll:%d",self.updateView.state);
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

- (void)dealloc {
	if (_queue && [_queue operationCount]>0) {
		[_queue cancelAllOperations];
	}
	RELEASE(_queue);
	RELEASE(_updateView);
	RELEASE(_imgCache);
    RELEASE(_moreView);
    RELEASE(_topLine);
    [super dealloc];
}
@end

@implementation TableViewCell
@synthesize imgLocalPath = _imgLocalPath;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
		UIView *v = [[[TableViewCellBackground alloc] initWithFrame:self.bounds] autorelease];
        [v setBackgroundColor:gTableViewBgColor];
		self.backgroundView = v;
		
		v = [[[TableViewCellBackground alloc] initWithFrame:self.bounds] autorelease];
        [v setBackgroundColor:gTableViewSelectedBgColor];
		self.selectedBackgroundView = v;
    }
    return self;
}
- (void) setContentView:(UIView *)view{
	if (self.contentView.subviews) {
		[self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	}
	view.frame = self.contentView.bounds;
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.contentView addSubview:view];
}
- (void) setImgLocalPath:(NSString *)imgLocalPath{
	RELEASE(_imgLocalPath);
	_imgLocalPath = [imgLocalPath retain];
	if (_cellContentView && [_cellContentView respondsToSelector:@selector(drawImage)]) {
		[_cellContentView performSelector:@selector(drawImage)];
	}
}
- (void) dealloc{
	RELEASE(_cellContentView);
	RELEASE(_imgLocalPath);
	[super dealloc];
}
@end
@implementation TableViewSection
- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		self.separatorLineStyle = SeparatorLineStyleTop | SeparatorLineStyleBottom;
        _titleLabel = [createLabel(CGRectZero, gTableSectionTitleFont, [UIColor clearColor], gTableSectionTitleColor, nil, CGSizeZero, UITextAlignmentLeft, 1, 0) retain];
        _rightLabel = [createLabel(CGRectZero, gTableSectionTitleFont, [UIColor clearColor], gTableSectionTitleColor, nil, CGSizeZero, UITextAlignmentRight, 1, 0) retain];
        [self addSubview:_titleLabel];
        [self addSubview:_rightLabel];
        
        self.backgroundColor = gTableSectionBgColor;
        
	}
	return self;
}
- (void)setBackgroundImage:(UIImage *)img{
    if (_bg) {
        [_bg removeFromSuperview];
        RELEASE(_bg);
    }
    if (img) {
        _bg = [[UIImageView alloc] initWithImage:img];
        _bg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_bg setFrame:self.bounds];
        [self addSubview:_bg];
        [self sendSubviewToBack:_bg];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = CGRectInset(self.bounds, 10, (self.bounds.size.height - [gTableSectionTitleFont pointSize]-2)/2);
    _titleLabel.frame = r;
    _rightLabel.frame = r;
    if (_rightView) {
        r = _rightView.bounds;
        r.origin = CGPointMake(self.bounds.size.width - r.size.width-10, (self.bounds.size.height-r.size.height)/2);
        _rightView.frame = r;
    }
}
- (void)setTitle:(NSString *)title{
    RELEASE(_title);
    _title = [title retain];    
    _titleLabel.text = title;
}
- (void)setRightTitle:(NSString *)rightTitle{
    RELEASE(_rightTitle);
    _rightTitle = [rightTitle retain];
    _rightLabel.text = rightTitle;
}
- (void) setRightView:(UIView *)rightView{
    if (_rightView) {
        [_rightView removeFromSuperview];
        RELEASE(_rightView);
    }
    _rightView = [rightView retain];
    [self addSubview:_rightView];
    [self setNeedsLayout];
}
- (void)dealloc{
    RELEASE(_titleLabel);
    RELEASE(_title);
    RELEASE(_rightLabel);
    RELEASE(_rightTitle);
    RELEASE(_bg);
    [super dealloc];
}
@end

@implementation TableViewCellBackground
- (void)setup{
    self.separatorLineStyle = SeparatorLineStyleBottom;
    [self setBackgroundColor:[UIColor clearColor]];
    self.topLineColor = gLineTopColor;
    self.bottomLineColor = gLineBottomColor;
}
- (id)initWithFrame:(CGRect)frame{
	
	if (self = [super initWithFrame:frame]) {
        [self setup];
	}
	return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
	if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
	return self;
}
- (void)setFrame:(CGRect)frame{
	[super setFrame:frame];
	[self setNeedsDisplay];
}
- (void)drawLine:(CGPoint)p1 toPoint:(CGPoint)p2 color:(UIColor *)color inContext:(CGContextRef)ctx{
	CGContextMoveToPoint(ctx, p1.x,p1.y);
	CGContextAddLineToPoint(ctx, p2.x,p2.y);	
	CGContextSetStrokeColorWithColor(ctx, color.CGColor);
	CGContextDrawPath(ctx, kCGPathStroke);
}
- (void)setTopLineColor:(UIColor *)topLineColor bottomLineColor:(UIColor *)bottomLineColor{
    RELEASE(_topLineColor);
    RELEASE(_bottomLineColor);
    _topLineColor = [topLineColor retain];
    _bottomLineColor = [bottomLineColor retain];
    [self setNeedsDisplay];
}
- (void)setBackgroundImage:(UIImage *)backgroundImage{
    RELEASE(_backgroundImage);
    _backgroundImage = [backgroundImage retain];
    [self setNeedsDisplay];
}
- (void) drawRect:(CGRect)rect{
	float lineWidth = 0.5;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    if (self.backgroundImage) {
        [self.backgroundImage drawInRect:rect];
    }
	CGContextSetShouldAntialias(ctx,false);
	CGContextSetLineWidth(ctx, lineWidth);
	CGPoint p1,p2;
	if (_separatorLineStyle & SeparatorLineStyleTop) {
		
		p1 = CGPointMake(rect.origin.x,rect.origin.y + lineWidth);	
		p2 = CGPointMake(rect.size.width,rect.origin.y+lineWidth);					 
		[self drawLine:p1 toPoint:p2 color:_topLineColor inContext:ctx];							 
		
		p1.y += lineWidth;
		p2.y += lineWidth;	
		[self drawLine:p1 toPoint:p2 color:_bottomLineColor inContext:ctx];
	}
	if (_separatorLineStyle & SeparatorLineStyleBottom) {
		p1 = CGPointMake(rect.origin.x,rect.origin.y+rect.size.height-2*lineWidth);	
		p2 = CGPointMake(rect.size.width,rect.origin.y+rect.size.height-2*lineWidth);					 
		[self drawLine:p1 toPoint:p2 color:_topLineColor inContext:ctx];							 
		
		p1 = CGPointMake(rect.origin.x,rect.origin.y+rect.size.height-lineWidth);
		p2 = CGPointMake(rect.size.width,rect.origin.y+rect.size.height-lineWidth);	
		[self drawLine:p1 toPoint:p2 color:_bottomLineColor inContext:ctx];
	}
    CGContextRestoreGState(ctx);
}
- (void)dealloc{
    RELEASE(_backgroundImage);
    RELEASE(_topLineColor);
    RELEASE(_bottomLineColor);
    [super dealloc];
}

@end


@implementation TableCellContentView
@synthesize numOfLines = _numOfLines;
@synthesize style = _style;
@synthesize aspectRatio = _aspectRatio;
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor clearColor];
		_aspectRatio = 1.0f;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame cell:(UITableViewCell *)cell{
	self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor clearColor];
		_cell = cell;
		_aspectRatio = 1.1f;
    }
    return self;
}
- (void) setStyle:(int)style{
	_style = style;
}
- (void)drawImage{
	[self setNeedsDisplayInRect:_imgRect];
}
- (void)createTitleBgPath:(CGRect)rect inContent:(CGContextRef)ctx{ 
    float rad = 5.0;
    float minx = CGRectGetMinX(rect), maxx = CGRectGetMaxX(rect);
    float miny = CGRectGetMinY(rect), maxy = CGRectGetMaxY(rect);
    CGContextMoveToPoint(ctx, minx, miny);
    CGContextAddLineToPoint(ctx, maxx, miny);
    CGContextAddArcToPoint(ctx, maxx, maxy, minx, maxy, rad);
    CGContextAddLineToPoint(ctx, minx, maxy);
    CGContextAddLineToPoint(ctx, minx, miny);
}
- (void)drawImageInRect:(CGRect)rect inContext:(CGContextRef)ctx withTitle:(NSString *)title{
	CGRect r = CGRectInset(rect,0,0);
    
    CGContextSaveGState(ctx);
    [[UIColor clearColor] set];
	UIImage *img = (_cell && [_cell imgLocalPath])?[UIImage imageWithContentsOfFile:[_cell imgLocalPath]]:[UIImage imageWithColor:gThumbnailColor size:r.size];
	if (img) {
        //img = [img imageWithCornerRadius:5 borderColor:gTablePicBorderColor size:r.size];
        img = [img cropToScale:_aspectRatio];
		CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 2, [gTablePicShadowColor CGColor]);
		[img drawInRect:r];		
	}    
    CGContextRestoreGState(ctx);
	if (title && [title length]>0) {     
        UIFont *font = gNoteFont;
		CGSize tsize = [title sizeWithFont:font forWidth:rect.size.width lineBreakMode:UILineBreakModeWordWrap];   
        float bgWidth=tsize.width+10,bgHeight = 20;
        
        CGContextSaveGState(ctx);
        CGRect r2 = CGRectMake(r.origin.x+r.size.width-bgWidth, r.origin.y+r.size.height-bgHeight, bgWidth, bgHeight);
        [self createTitleBgPath:r2 inContent:ctx];
        [[[UIColor blackColor] colorWithAlphaComponent:0.8] set];
        CGContextDrawPath(ctx, kCGPathFill);
        CGContextRestoreGState(ctx);
        
        CGContextSaveGState(ctx);
		[[UIColor whiteColor] set];
		CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 3, [UIColor blueColor].CGColor);
		r2 = CGRectMake(+r2.origin.x+(r2.size.width-tsize.width-10/2), r2.origin.y+(bgHeight-tsize.height)/2, tsize.width, tsize.height);
		[title drawInRect:r2 withFont:font lineBreakMode:UILineBreakModeWordWrap];
        
        CGContextRestoreGState(ctx);
	}
}
- (void)drawLine:(NSInteger)line inRect:(CGRect)rect inContext:(CGContextRef)ctx{
}
- (CGRect)rectForLine:(NSInteger)line offsetY:(float)y inContext:(CGContextRef)ctx{
    float w = self.bounds.size.width;
    CGRect rect = CGRectMake(0, y, w, line==0?24:18);
    if (_style == TableViewCellStyleImage && _imgRect.size.width>0) {
        if( _imgRect.origin.x > w/2 ){
            rect.size.width -= (w-_imgRect.size.width);
        }else{
            rect.origin.x = _imgRect.size.width+_imgRect.origin.x;
            rect.size.width = w - rect.origin.x;
        }
    }
    if (line == (_numOfLines-1)) {
        rect.size.height = self.bounds.size.height - rect.origin.y - 5;
    }
    return rect;
}
- (CGRect)rectForImageInContent:(CGContextRef)ctx{
    CGRect rect = CGRectZero;
    if (_style == TableViewCellStyleImage){
        float x = 5, y = 5;
        float h = self.bounds.size.height-2*y;
        rect = CGRectMake(x, y, h*_aspectRatio, h);
    }
    return rect;
}
- (void)drawRect:(CGRect)rect{	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	if (_style == TableViewCellStyleImage) {
		_imgRect = [self rectForImageInContent:ctx];;
		CGContextSaveGState(ctx);
		[self drawImageInRect:_imgRect inContext:ctx withTitle:nil];
		CGContextRestoreGState(ctx);
		if (CGRectEqualToRect(_imgRect, rect)) {
			return;
		}
	}
    float y = 0;
   	for (int i=0; i<_numOfLines; i++) {
		CGContextSaveGState(ctx);
        
        CGRect r = [self rectForLine:i offsetY:y inContext:ctx];
        y = r.origin.y+r.size.height;
		[self drawLine:i inRect:r inContext:ctx];
        
		CGContextRestoreGState(ctx);
		
        if ( y > (self.bounds.size.height-5) ) {
            break;
        }
	}
}
- (void)dealloc {
    [super dealloc];
}
@end
