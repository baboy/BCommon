//
//  HTabBarView.m
//  itv
//
//  Created by Zhang Yinghui on 10/12/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "HTabBarView.h"

#define HTabBarIndicatorWidth 15
#define HTabBarIndicatorHeight 20
#define HTabBarGroupViewMinHeight   24


@interface VSeparator : UIView
@property (nonatomic, retain) UIColor *leftLineColor;
@property (nonatomic, retain) UIColor *rightLineColor;

@end

@interface HTabBarView()
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *btns;
@property (nonatomic, retain) UIButton *leftIndicator;
@property (nonatomic, retain) UIButton *rightIndicator;
@property (nonatomic, retain) UIImageView *selectBackgroundView;
@property (nonatomic, retain) UIImageView *backgroundView;
- (void) createIndicator;
- (void)tapIndicator:(UIButton *)button;
@end

@implementation HTabBarView
- (void)setup{
    _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    _backgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundView];
    
    self.titleFont = [UIFont systemFontOfSize:14];
    self.itemBorderWidth = 1;
    self.separatorWidth = 2;
    CGRect r = CGRectInset(self.bounds, 0, 0);
    _scrollView = [[UIScrollView alloc] initWithFrame:r];
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];
    self.vPadding = 3.0;
    self.selectedIndex = 0;
    self.separatorLeftColor = gLineTopColor;
    self.separatorRightColor = gLineBottomColor;
    self.titleFont = [UIFont systemFontOfSize:14];
}
- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setup];
	}
	return self;
}
- (void)awakeFromNib{
    [self setup];
}
- (void)setFrame:(CGRect)frame{
    BOOL flag = frame.size.width!= self.frame.size.width || frame.size.height!=self.frame.size.height;
    [super setFrame:frame];
    self.scrollView.frame = self.bounds;
    if (self.items && flag) {
        id items = AUTORELEASE(RETAIN(_items));
        [self setItems:items];
    }
}
- (void)setBackgroundImage:(UIImage *)backgroundImage{
    if (backgroundImage) {
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(backgroundImage.size.height/2, backgroundImage.size.width/2, backgroundImage.size.height/2, backgroundImage.size.width/2)];
    }
    RELEASE(_backgroundImage);
    _backgroundImage = [backgroundImage retain];
    self.backgroundView.image = _backgroundImage;
}
- (void)setSeparatorColor:(UIColor *)separatorColor{
    [self setSeparatorLeftColor:separatorColor];
    [self setSeparatorRightColor:separatorColor];
}
- (void)setSelectedBackgroundImage:(id)selectedBackgroundImage{
    if ([selectedBackgroundImage isKindOfClass:[UIColor class]]) {
        selectedBackgroundImage = [UIImage imageWithColor:selectedBackgroundImage size:CGSizeMake(5, 5)];
    }
    float w = [selectedBackgroundImage size].width;
    float h = [selectedBackgroundImage size].height;
    selectedBackgroundImage = [selectedBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(h/2, w/2, h/2, w/2)];
    RELEASE(_selectedBackgroundImage);
    _selectedBackgroundImage = [selectedBackgroundImage retain];
    self.selectBackgroundView.image = selectedBackgroundImage;
}
- (void)setUnSelectedBackgroundImage:(id)unSelectedBackgroundImage{
    if ([unSelectedBackgroundImage isKindOfClass:[UIColor class]]) {
        unSelectedBackgroundImage = [UIImage imageWithColor:unSelectedBackgroundImage size:CGSizeMake(5, 5)];
    }
    float w = [unSelectedBackgroundImage size].width;
    float h = [unSelectedBackgroundImage size].height;
    unSelectedBackgroundImage = [unSelectedBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(h/2, w/2, h/2, w/2)];
    RELEASE(_unSelectedBackgroundImage);
    _unSelectedBackgroundImage = [unSelectedBackgroundImage retain];
}
- (void)setSelectedImage:(id)selectedImage{
    [self setSelectedBackgroundImage:selectedImage];;
}
- (void)setUnSelectedImage:(id)unSelectedImage{
    [self setUnSelectedBackgroundImage:unSelectedImage];
}
- (UIImageView *)selectBackgroundView{
    if (!_selectBackgroundView) {
        _selectBackgroundView = [[UIImageView alloc] initWithImage:self.selectedBackgroundImage];
        _selectBackgroundView.hidden = YES;
        [self.scrollView addSubview:_selectBackgroundView];
        [self.scrollView sendSubviewToBack:_selectBackgroundView];
    }
    return _selectBackgroundView;
}
- (void)clear{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector( removeFromSuperview)];
    [self.leftIndicator removeFromSuperview];
    [self.rightIndicator removeFromSuperview];
    self.selectBackgroundView = nil;
}
- (float)totalWidth{
    float w = 0;
    for (NSDictionary *item in self.items) {
		NSString *name = [item valueForKey:@"name"];
        w += [name sizeWithFont:self.titleFont].width + 6 + self.spacing;
    }
    return w;
}
- (float)buttonAvgWidth{
	int n = [_items count];
    float width = self.itemWidth;
    if (self.itemWidth <= 0) {
        width = n>6?46:((self.scrollView.bounds.size.width-(self.separatorWidth+self.spacing)*(n-1))/n);
    }
    return width;
}
- (UIButton *)createButtonWithFrame:(CGRect)frame info:(id)info atIndex:(int)atIndex{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn addTarget:self action:@selector(tapItem:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTag:atIndex];
    btn.backgroundColor = [UIColor clearColor];
    //[btn setBackgroundImage:self.unSelectedBackgroundImage forState:UIControlStateNormal];
    btn.titleLabel.font = self.titleFont;
    [btn setTitle:[info valueForKey:@"name"] forState:UIControlStateNormal];
    [btn setTitleColor:self.unSelectedTitleColor forState:UIControlStateNormal];
    [btn setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
    //[btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
    return btn;
}
- (void)setAlignLeft:(BOOL)alignLeft{
    if (alignLeft)
        self.align = HTabBarAlignmentLeft;
    else
        self.align = HTabBarAlignmentCenter;
}
- (void) setItems:(NSArray *)items{
	RELEASE(_items);
	_items = [items retain];
    [self clear];
    
	int n = [_items count];
    BOOL flag = [self totalWidth] > self.scrollView.frame.size.width;
	NSMutableArray *btns = [NSMutableArray arrayWithCapacity:n];
	CGRect rect = CGRectInset(CGRectMake(0, 0, [self buttonAvgWidth], self.bounds.size.height),0,0);
	for ( int j=0; j<n; j++) {
        int i = j;
        if (self.align == HTabBarAlignmentRight) {
            i = n-j-1;
        }
		NSDictionary *item = [_items objectAtIndex:i];
		NSString *name = [item valueForKey:@"name"];
        name = name?:[item valueForKey:@"title"];
        rect.size.width = [self buttonAvgWidth];
        if (flag || self.align != HTabBarAlignmentCenter ) {
            rect.size.width = [name sizeWithFont:self.titleFont].width+10;
        }
        UIButton *btn = [self createButtonWithFrame:CGRectInset(rect, 0, self.vPadding) info:item atIndex:i];
		[self.scrollView addSubview:btn];
		[btns addObject:btn];
		[btn release];
		rect.origin.x += rect.size.width+self.spacing/2;
		if (i != (n-1) && self.separatorWidth) {
			VSeparator *sep = [[VSeparator alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, self.separatorWidth, rect.size.height)];
            [sep setLeftLineColor:self.separatorLeftColor];
            [sep setRightLineColor:self.separatorRightColor];
			[self.scrollView addSubview:sep];
			rect.origin.x += sep.bounds.size.width;
			[sep release];
		}
        rect.origin.x += self.spacing/2;
	}
    self.btns = (self.align == HTabBarAlignmentRight)?[NSMutableArray arrayWithArray:[btns reverse]]:btns;
	self.scrollView.contentSize = CGSizeMake(rect.origin.x-self.spacing, 0);
    if (self.align == HTabBarAlignmentRight) {
        CGPoint p = CGPointZero;
        p.x = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
        CGRect scrollViewFrame = self.scrollView.frame;
        if (self.scrollView.contentSize.width < scrollViewFrame.size.width) {
            scrollViewFrame.origin.x += (scrollViewFrame.size.width - self.scrollView.contentSize.width);
            scrollViewFrame.size.width = self.scrollView.contentSize.width;
            self.scrollView.frame = scrollViewFrame;
        }
    }
    CGRect r = self.scrollView.frame;
	if ( self.scrollView.contentSize.width > (r.size.width+5) ) {
        [self.scrollView setFrame:CGRectInset(r, HTabBarIndicatorWidth, 0)];
		[self createIndicator];
		[self scrollViewDidScroll:_scrollView];
	}
	[self selectAtIndex:_selectedIndex];
}
- (void)relayout{
    
}
- (void) createIndicator{
	float w = HTabBarIndicatorWidth,h = HTabBarIndicatorHeight;
	CGRect r = CGRectMake(0, (self.bounds.size.height-h)/2, w, h);
	self.leftIndicator = AUTORELEASE([[UIButton alloc] initWithFrame:r]);
	[self.leftIndicator setTag:1];
	[self.leftIndicator addTarget:self action:@selector(tapIndicator:) forControlEvents:UIControlEventTouchUpInside];
	[self.leftIndicator setImage:[UIImage imageNamed:@"arrow-indicator-left"] forState:UIControlStateNormal];
	[self addSubview:self.leftIndicator];
	
	r.origin.x = self.bounds.size.width - w;
	self.rightIndicator = AUTORELEASE([[UIButton alloc] initWithFrame:r]);
	[self.rightIndicator setTag:-1];
	[self.rightIndicator addTarget:self action:@selector(tapIndicator:) forControlEvents:UIControlEventTouchUpInside];
	[self.rightIndicator setImage:[UIImage imageNamed:@"arrow-indicator-right"] forState:UIControlStateNormal];
	[self addSubview:self.rightIndicator];
	
}
- (void) tapItem:(UIButton *)button{
    [self tappedAtIndex:[button tag]];
}
- (void) tappedAtIndex:(int)i{
	if (!_btns || i<0 || i >= [_btns count]) {
		return;
	}
    [self selectAtIndex:i];
	NSDictionary *item = [self.items objectAtIndex:i];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectItem:)]) {
        [self.delegate tabBar:self didSelectItem:item];
    }
}
- (void) selectAtIndex:(int)i{
	if (!_btns || i<0 || i >= [_btns count]) {
		return;
	}
    UIButton *preBtn = (_selectedIndex>=0 && _selectedIndex < [_btns count])?[_btns objectAtIndex:_selectedIndex]:nil;
	if (preBtn) {
        preBtn.selected = NO;
	}
	UIButton *curBtn = [_btns objectAtIndex:i];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.selectBackgroundView.hidden = NO;
                         self.selectBackgroundView.frame = CGRectInset(curBtn.frame, 0, -self.vPadding);
                     }];
    curBtn.selected = YES;
	_selectedIndex = i;
}
- (void) selectWithValue:(NSString *)v{
	if (!v) {
		return;
	}
	int n = [_items count];
	for (int i=0; i<n; i++) {
		NSDictionary *item = [_items objectAtIndex:i];
		NSString *v2 = [[item valueForKey:@"value"] description];
		if (v2 && [v2 isEqualToString:v]) {
			[self selectAtIndex:i];
			return;
		}
	}
}

- (NSDictionary *)selectValue{
    return [self.items objectAtIndex:self.selectedIndex];
}
- (void)tapIndicator:(UIButton *)button{
	int i = [button tag];
	CGPoint p = _scrollView.contentOffset;
	float ow = _scrollView.contentSize.width - _scrollView.bounds.size.width;
	float x = p.x - i*64;
	x = MAX(0,x);
	x = MIN(x,ow);
	p.x = x;
	[_scrollView setContentOffset:p animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (!_leftIndicator || ! _rightIndicator) {
		return;
	}
	float ow = scrollView.contentSize.width - scrollView.bounds.size.width;
	float ox = scrollView.contentOffset.x;
	float p = ox/ow;
	_leftIndicator.alpha = 0.4 + p*0.6;
	_rightIndicator.alpha = 0.4 + (1-p)*0.6;
}
- (void) dealloc{
	RELEASE(_btns);
	RELEASE(_scrollView);
	RELEASE(_key);
	RELEASE(_items);
	RELEASE(_leftIndicator);
	RELEASE(_rightIndicator);
    RELEASE(_selectedTitleColor);
    RELEASE(_unSelectedTitleColor);
    RELEASE(_selectedBackgroundImage);
    RELEASE(_unSelectedBackgroundImage);
    RELEASE(_selectedImage);
    RELEASE(_unSelectedImage);
    RELEASE(_selectBackgroundView);
    RELEASE(_separatorColor);
    RELEASE(_separatorLeftColor);
    RELEASE(_separatorRightColor);
    RELEASE(_backgroundImage);
	[super dealloc];
}
@end

@implementation VSeparator
@synthesize leftLineColor = _leftLineColor;
@synthesize rightLineColor = _rightLineColor;

- (id) initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		_leftLineColor = [gLineTopColor retain];
		_rightLineColor = [gLineBottomColor retain];
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}
- (void)drawRect:(CGRect)rect{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(ctx, 0.5);
	CGContextMoveToPoint(ctx, rect.origin.x,rect.origin.y);
	CGContextAddLineToPoint(ctx, rect.origin.x,rect.origin.y+rect.size.height);
	CGContextSetStrokeColorWithColor(ctx, _leftLineColor.CGColor);
	CGContextDrawPath(ctx, kCGPathStroke);
	CGContextMoveToPoint(ctx, rect.origin.x+1,rect.origin.y);
	CGContextAddLineToPoint(ctx, rect.origin.x+1,rect.origin.y+rect.size.height);
	
	CGContextSetStrokeColorWithColor(ctx, _rightLineColor.CGColor);
	CGContextDrawPath(ctx, kCGPathStroke);
}
- (void) dealloc{
	RELEASE(_leftLineColor);
	RELEASE(_rightLineColor);
	[super dealloc];
}
@end
@interface HTabBarGroupView()<HTabBarViewDelegate>
@property (nonatomic, retain) UIView *container;
@property (nonatomic, retain) NSArray *bars;
@end
@implementation HTabBarGroupView

- (void) dealloc{
    RELEASE(_unSelectedImage);
	RELEASE(_container);
	RELEASE(_selectedIndexPath);
	RELEASE(_items);
    RELEASE(_selectedTitleColor);
    RELEASE(_unSelectedTitleColor);
    RELEASE(_selectedImage);
    
    RELEASE(_separatorColor);
    RELEASE(_vSeparatorColor);
    RELEASE(_separatorLeftColor);
    RELEASE(_separatorRightColor);
    
    RELEASE(_titleFont);
    RELEASE(_titleColor);
    RELEASE(_bars);
	[super dealloc];
}
- (void)setup{
    self.titleWidth = 44;
    self.titleFont = [UIFont systemFontOfSize:14];
    _container = [[UIView alloc] initWithFrame:self.bounds];
    _container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_container];
    self.align = HTabBarAlignmentLeft;
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)awakeFromNib{
    [self setup];
}
- (void)clear{
    [self.container.subviews makeObjectsPerformSelector:@selector( removeFromSuperview)];
}
- (void)setItems:(NSArray *)items{
    RELEASE(_items);
    _items = [items retain];
    [self clear];
    
    float w = self.bounds.size.width, h = self.bounds.size.height;
	int numOfRows = [items count];
    float itemHeight = h/numOfRows;
    if ( itemHeight < HTabBarGroupViewMinHeight ) {
        itemHeight = HTabBarGroupViewMinHeight;
        CGRect frame = self.frame;
        frame.size.height = itemHeight*numOfRows;
        self.frame = frame;
        self.container.frame = self.bounds;
    }
    
    NSMutableArray *bars = [NSMutableArray arrayWithCapacity:numOfRows];
    //
    CGRect rowFrame = CGRectMake(0, 0, w, itemHeight);
    for (int i = 0; i < numOfRows; i++) {
        NSDictionary *item = [items objectAtIndex:i];
        NSString *name = [item valueForKey:@"name"];
        NSString *key = [item valueForKey:@"key"];
        NSString *val = [item valueForKey:@"value"];
        NSArray *options = [item valueForKey:@"options"];
        UIView *lineWrapper = AUTORELEASE([[UIView alloc] initWithFrame:rowFrame]);
        lineWrapper.backgroundColor = [UIColor clearColor];
        CGRect barFrame = lineWrapper.bounds;
        if (name && [name length] > 0) {
            float titleWidth = self.titleWidth > 0 ? self.titleWidth: 48;
            CGRect titleFrame = barFrame;
            titleFrame.size.width = titleWidth;
            if (self.align == HTabBarAlignmentRight) {//居右对齐
                titleFrame.origin.x = barFrame.size.width-titleFrame.size.width;
            }else{//居左对齐
                barFrame.origin.x += titleFrame.size.width + 5;
            }
            barFrame.size.width -= titleFrame.size.width + 5;
            
            UILabel *titleLabel = createLabel(titleFrame, self.titleFont, nil, self.titleColor, nil, CGSizeZero, UITextAlignmentLeft, 1, NSLineBreakByTruncatingTail);
            titleLabel.text = name;
            [lineWrapper addSubview:titleLabel];
        }
        HTabBarView *bar = AUTORELEASE( [[HTabBarView alloc] initWithFrame:CGRectInset(barFrame, 0, self.vPadding)] );
        bar.delegate = self;
        bar.itemWidth = self.itemWidth;
        bar.itemBorderWidth = self.itemBorderWidth;
        bar.selectedBackgroundImage = self.selectedImage;
        bar.titleFont = self.titleFont;
        bar.separatorWidth = self.separatorWidth;
        bar.separatorColor = self.separatorColor;
        bar.separatorLeftColor = self.separatorLeftColor;
        bar.separatorRightColor = self.separatorRightColor;
        bar.selectedTitleColor = self.selectedTitleColor;
        bar.unSelectedTitleColor = self.unSelectedTitleColor;
        bar.align = self.align;
        bar.items = options;
        bar.key = key;
        if ( i > 0 && self.vSeparatorColor) {
            CGRect lineRect = rowFrame;
            lineRect.origin.y --;
            lineRect.size.height = 1;
            UIView *line = [[[UIView alloc] initWithFrame:lineRect] autorelease];
            [line setBackgroundColor:self.vSeparatorColor];
            [self.container addSubview:line];
        }
        
        [lineWrapper addSubview:bar];
        [self.container addSubview:lineWrapper];
        rowFrame.origin.y += rowFrame.size.height;
        [bars addObject:bar];
    }
    self.bars = bars;
}
- (void)tabBar:(HTabBarView *)tabBar didSelectItem:(NSDictionary *)info{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectItem:)]) {
        [self.delegate tabBar:self didSelectItem:[self selectValue]];
    }
}
- (NSDictionary *)selectValue{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    for (HTabBarView *bar in self.bars) {
        [params setValue:[bar.selectValue valueForKey:@"value"] forKey:bar.key];
    }
    return params;
}
@end

