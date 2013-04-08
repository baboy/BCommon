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

@interface VSeparator : UIView{
	UIColor * _leftLineColor;
	UIColor * _rightLineColor;
}
@property (nonatomic, retain) UIColor *leftLineColor;
@property (nonatomic, retain) UIColor *rightLineColor;

@end

@interface HTabBarView()
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *btns;
@property (nonatomic, retain) UIButton *leftIndicator;
@property (nonatomic, retain) UIButton *rightIndicator;

- (void) createIndicator;
- (void)tapIndicator:(UIButton *)button;
@end

@implementation HTabBarView
- (void)setup{
    
    _itemBorderWidth = 1;
    _separatorWidth = 2;
    CGRect r = CGRectInset(self.bounds, 0, 0);
    _scrollView = [[UIScrollView alloc] initWithFrame:r];
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];
    _selectedIndex = 0;
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
    if (self.items && flag) {
        [self setItems:self.items];
    }
}
- (void)clear{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector( removeFromSuperview)];
    [self.leftIndicator removeFromSuperview];
    [self.rightIndicator removeFromSuperview];
}
- (float)buttonWidth{
	int n = [_items count];
    float width = self.itemWidth;
    if (self.itemWidth <= 0) {
        width = n>6?46:((self.scrollView.bounds.size.width-self.separatorWidth*(n-1))/n);
    }
    return width;
}
- (void) setItems:(NSArray *)items{
	RELEASE(_items);
	_items = [items retain];
    [self clear];
    
	int n = [_items count];
    
	self.btns = [NSMutableArray arrayWithCapacity:n];
	CGRect rect = CGRectInset(CGRectMake(0, 0, [self buttonWidth], self.bounds.size.height),0,0);
	for ( int i=0; i<n; i++) {
		NSDictionary *item = [_items objectAtIndex:i];
		NSString *name = [item valueForKey:@"name"];
        name = name?name:[item valueForKey:@"title"];
		UIButton *btn = [[UIButton alloc] initWithFrame:rect];
		[btn addTarget:self action:@selector(tapItem:) forControlEvents:UIControlEventTouchUpInside];
		[btn setTag:i];
        btn.backgroundColor = [UIColor clearColor];
        [btn setBackgroundImage:self.unSelectedImage forState:UIControlStateNormal];
		btn.titleLabel.font = [UIFont systemFontOfSize:14];
		[btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:self.unSelectedTitleColor forState:UIControlStateNormal];
		[self.scrollView addSubview:btn];
		[self.btns addObject:btn];
		[btn release];
		rect.origin.x += rect.size.width+_spacing/2;
		if (i != (n-1) && _separatorWidth) {
			VSeparator *sep = [[VSeparator alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, self.separatorWidth, rect.size.height)];
			[self.scrollView addSubview:sep];
			rect.origin.x += sep.bounds.size.width;
			[sep release];
		}
        rect.origin.x += self.spacing/2;
	}
	self.scrollView.contentSize = CGSizeMake(rect.origin.x-self.spacing, 0);
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
	_leftIndicator = [[UIButton alloc] initWithFrame:r];
	[_leftIndicator setTag:1];
	[_leftIndicator addTarget:self action:@selector(tapIndicator:) forControlEvents:UIControlEventTouchUpInside];
	[_leftIndicator setImage:[UIImage imageNamed:@"arrow_left.png"] forState:UIControlStateNormal];
	[self addSubview:_leftIndicator];
	
	r.origin.x = self.bounds.size.width - w;
	_rightIndicator = [[UIButton alloc] initWithFrame:r];
	[_rightIndicator setTag:-1];
	[_rightIndicator addTarget:self action:@selector(tapIndicator:) forControlEvents:UIControlEventTouchUpInside];
	[_rightIndicator setImage:[UIImage imageNamed:@"arrow_right.png"] forState:UIControlStateNormal];
	[self addSubview:_rightIndicator];
	
}
- (void) tapItem:(UIButton *)button{
	int i = [button tag];
	[self selectAtIndex:i];
	NSDictionary *item = [self.items objectAtIndex:i];    
    //DLOG(@"[HTabBarView] didSelectItem:%@", item);
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectItem:)]) {
        [self.delegate tabBar:self didSelectItem:item];
    }
}
/*
- (void) drawRect:(CGRect)rect{
    float lineWidth = 0.5;
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(ctx, lineWidth);
	CGContextMoveToPoint(ctx, rect.origin.x,rect.origin.y+rect.size.height-2*lineWidth);
	CGContextAddLineToPoint(ctx, rect.size.width,rect.origin.y+rect.size.height-2*lineWidth);
	CGContextSetStrokeColorWithColor(ctx, gLineBottomColor.CGColor);
	CGContextDrawPath(ctx, kCGPathStroke);
	CGContextMoveToPoint(ctx, rect.origin.x,rect.origin.y+rect.size.height-lineWidth);
	CGContextAddLineToPoint(ctx, rect.size.width,rect.origin.y+rect.size.height-lineWidth);
	
	CGContextSetStrokeColorWithColor(ctx, gLineTopColor.CGColor);
	CGContextDrawPath(ctx, kCGPathStroke);	
}
 */
- (void) selectAtIndex:(int)i{
	if (!_btns || i<0 || i >= [_btns count]) {
		return;
	}
    UIButton *preBtn = (_selectedIndex>=0 && _selectedIndex < [_btns count])?[_btns objectAtIndex:_selectedIndex]:nil;
	if (preBtn) {
        //[preBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [preBtn setBackgroundColor:[UIColor clearColor]];
        [preBtn setTitleColor:self.unSelectedTitleColor forState:UIControlStateNormal];
        [preBtn setBackgroundImage:self.unSelectedImage forState:UIControlStateNormal];
	}
	UIButton *curBtn = [_btns objectAtIndex:i];
    [curBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [curBtn setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
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
    RELEASE(_unSelectedImage);
	RELEASE(_btns);
	RELEASE(_scrollView);
	RELEASE(_key);
	RELEASE(_items);
	RELEASE(_leftIndicator);
	RELEASE(_rightIndicator);
    RELEASE(_selectedTitleColor);
    RELEASE(_unSelectedTitleColor);
    RELEASE(_selectedImage);
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

