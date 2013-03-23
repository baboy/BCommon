//
//  VTabBarView.m
//  iLookForiPad
//
//  Created by baboy on 13-2-22.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "VTabBarView.h"

#define VTabBarIndicatorWidth 15
#define VTabBarIndicatorHeight 20
@interface VTabBarView()
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *btns;
@property (nonatomic, retain) UIButton *topIndicator;
@property (nonatomic, retain) UIButton *bottomIndicator;
- (void) createIndicator;
- (void)tapIndicator:(UIButton *)button;
@end

@implementation VTabBarView
- (void)setup{
    _itemBorderWidth = 1;
    _separatorHeight= 2;
    CGRect r = CGRectInset(self.bounds, 0, 0);
    _scrollView = [[UIScrollView alloc] initWithFrame:r];
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor redColor];
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
- (float)buttonHeight{
	int n = [self.items count];
    float height = self.itemHeight;
    if (self.itemHeight <= 0) {
        float avgHeight = (self.scrollView.bounds.size.height - self.separatorHeight*(n-1))/n;
        height = avgHeight>26?avgHeight:26;
    }
    return height;
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
    [self.topIndicator removeFromSuperview];
    [self.bottomIndicator removeFromSuperview];
}
- (void) setItems:(NSArray *)items{
	RELEASE(_items);
	_items = [items retain];
    [self clear];
    if (!items) {
        return;
    }
	int n = [items count];
	self.btns = [NSMutableArray arrayWithCapacity:n];
    
	CGRect rect = CGRectInset(CGRectMake(0, 0, self.scrollView.bounds.size.width, [self buttonHeight]),0,0);
	for ( int i=0; i<n; i++) {
		NSDictionary *item = [items objectAtIndex:i];
		NSString *name = [item valueForKey:@"name"];
        name = name?name:[item valueForKey:@"title"];
		UIButton *btn = [[UIButton alloc] initWithFrame:rect];
		[btn addTarget:self action:@selector(tapItem:) forControlEvents:UIControlEventTouchUpInside];
		[btn setTag:i];
        btn.backgroundColor = [UIColor clearColor];
        [btn setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
		btn.titleLabel.font = [UIFont systemFontOfSize:14];
		[btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:self.unSelectedTitleColor forState:UIControlStateNormal];
		[self.scrollView addSubview:btn];
		[self.btns addObject:btn];
		[btn release];
        if (i == (n-1))
            break;
            
        rect.origin.y += rect.size.height+self.spacing/2;
		if (self.separatorHeight) {
			BLineView *sep = [[BLineView alloc] initWithFrame:CGRectMake(0, rect.origin.y, rect.size.width,_separatorHeight) lines:[NSArray arrayWithObjects:gLineTopColor, gLineBottomColor, nil]];
			[self.scrollView addSubview:sep];
			rect.origin.y += sep.bounds.size.height+_spacing/2;
			[sep release];
		}
	}
	self.scrollView.contentSize = CGSizeMake(0, rect.origin.y+rect.size.height);
    CGRect scrollViewFrame = self.scrollView.frame;
    if (scrollViewFrame.size.height+3 < (self.scrollView.contentSize.height)) {
        scrollViewFrame = CGRectInset(scrollViewFrame, 0, VTabBarIndicatorHeight);
        self.scrollView.frame = scrollViewFrame;
        [self createIndicator];
    }
	[self selectAtIndex:_selectedIndex];
}
- (void) createIndicator{
	float w = VTabBarIndicatorWidth,h = VTabBarIndicatorHeight;
	CGRect r = CGRectMake((self.bounds.size.width-w)/2, 0, w, h);
	self.topIndicator = [[[UIButton alloc] initWithFrame:r] autorelease];
	[self.topIndicator setTag:1];
	[self.topIndicator addTarget:self action:@selector(tapIndicator:) forControlEvents:UIControlEventTouchUpInside];
	[self.topIndicator setImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateNormal];
	[self addSubview:self.topIndicator];
	
	r.origin.y = self.bounds.size.height - h;
	self.bottomIndicator = [[[UIButton alloc] initWithFrame:r] autorelease];
	[self.bottomIndicator setTag:-1];
	[self.bottomIndicator addTarget:self action:@selector(tapIndicator:) forControlEvents:UIControlEventTouchUpInside];
	[self.bottomIndicator setImage:[UIImage imageNamed:@"arrow_right.png"] forState:UIControlStateNormal];
	[self addSubview:self.bottomIndicator];
	
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
	if (!self.topIndicator || ! self.bottomIndicator) {
		return;
	}
	float ow = scrollView.contentSize.width - scrollView.bounds.size.width;
	float ox = scrollView.contentOffset.x;
	float p = ox/ow;
	self.topIndicator.alpha = 0.4 + p*0.6;
	self.bottomIndicator.alpha = 0.4 + (1-p)*0.6;
}
- (void) dealloc{
    RELEASE(_unSelectedImage);
	RELEASE(_btns);
	RELEASE(_scrollView);
	RELEASE(_key);
	RELEASE(_items);
	RELEASE(_topIndicator);
	RELEASE(_bottomIndicator);
    RELEASE(_selectedTitleColor);
    RELEASE(_unSelectedTitleColor);
    RELEASE(_selectedImage);
	[super dealloc];
}
@end
