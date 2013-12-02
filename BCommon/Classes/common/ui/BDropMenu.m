//
//  BDropMenu.m
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-8-23.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "BDropMenu.h"

#define DropMenuVerticalPadding 4.0f

@interface BDropMenuBackground:UIView
@property (nonatomic, assign) CGPoint anchorPoint;
@end

@interface BDropMenu()
@property (nonatomic, retain) UIScrollView *contentView;
@property (nonatomic, retain) BDropMenuBackground *backgroundView;
@property (nonatomic, assign) BOOL isRetain;
@end

@implementation BDropMenu
- (void)dealloc{
    RELEASE(_backgroundView);
    RELEASE(_filterItem);
    RELEASE(_items);
    RELEASE(_contentView);
    RELEASE(_anchor);
    RELEASE(_object);
    [super dealloc];
}
- (id)init{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (self = [super initWithFrame:window.bounds]) {     
        _backgroundView = [[BDropMenuBackground alloc] initWithFrame:CGRectZero];
        [self addSubview:_backgroundView];
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_contentView setAlwaysBounceVertical:YES];
        [_contentView setBounces:YES];
        [_backgroundView addSubview:_contentView];
        
        self.backgroundColor = [UIColor clearColor];
        self.itemHeight = 32;
        self.menuWidth = 100;
        
        [_backgroundView.layer setShadowColor:[UIColor colorWithWhite:0 alpha:0.9].CGColor];
        [_backgroundView.layer setShadowRadius:1.0];
        [_backgroundView.layer setShadowOpacity:1.0];
        [_backgroundView.layer setShadowOffset:CGSizeMake(0, 1)];
        
        self.isRetain = NO;
    }
    return self;
}
- (void)addTarget:(id)target action:(SEL)action{
    self.target = target;
    self.action = action;
}
/**
 *  计算contentView 高度
 *
 */
- (float)heightForContentView{
    float h = 0;
    int n = [self.items count];
    for (int i=0; i<n; i++) {
        if (i>=6) {
            break;
        }
        id item = [self.items objectAtIndex:i];
        if ([item isKindOfClass:[NSDictionary class]]) {
            item = [[[BDropMenuItem alloc] initWithDictionary:item] autorelease];
        }
        if (item == self.filterItem) {
            continue;
        }
        h += h>0?DropMenuVerticalPadding:0;
        if ([item isKindOfClass:[BDropMenuItem class]]) {
            h += self.itemHeight;
        }else{
            h += 2;
        }
    }
    return h;
}
/**
 *  调整界面 先把背景 backgroundView  以及contentView frame 调整好
 *
 */
- (void)relayoutBackground{
    int n = [self.items count];
    if (!n || (n==1 && [self.items containsObject:self.filterItem])) {
        [self setHidden:YES];
        return;
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGPoint p = [window convertPoint:self.offset fromView:self.anchor];
    
    float x = p.x - self.menuWidth/2;
    float y = p.y;
    if (x < 10) {
        x = 10;
    }else if((x+self.menuWidth) > window.bounds.size.width){
        x = window.bounds.size.width - self.menuWidth-10;
    }
    
    float topPadding = 11.0f;
    if ([self.items containsObject:self.filterItem]) {
        n --;
    }
    float h = [self heightForContentView]+topPadding+2*DropMenuVerticalPadding;
    
    [self.backgroundView setAnchorPoint:CGPointMake(p.x - x, 0)];
    [self.backgroundView setFrame:CGRectMake(x, y, self.menuWidth, h)];
    
    CGRect rect = CGRectInset(self.backgroundView.bounds,DropMenuVerticalPadding, DropMenuVerticalPadding);
    rect.origin.y += topPadding;
    rect.size.height -= topPadding;
    [self.contentView setFrame:rect];
}
/**
 *  创建界面 每一个条目
 *
 */
- (void)setup{
    int n = [self.items count];
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!n || ( [self.items containsObject:self.filterItem] && n == 1) ) {
        return;
    }
    NSString *curItemName = [self.filterItem name];
    int j = 0;
    CGRect rect = CGRectMake(0, 0, self.contentView.bounds.size.width, 0);
    for (int i=0; i<n; i++) {
        id item = [self.items objectAtIndex:i];
        if (![item isKindOfClass:[BDropMenuItem class]]) {
            if (j==0) {
                continue;
            }
            rect.size.height = 2;
            BLineView *line = [[[BLineView alloc] initWithFrame:rect] autorelease];
            [self.contentView addSubview:line];
        }else{
            NSString *name = [item name];
            if ([curItemName isEqualToString:name]) {
                continue;
            }
            rect.size.height = self.itemHeight;
            UIButton *btn = [[[UIButton alloc] initWithFrame:rect] autorelease];
            [btn setTag:i];
            btn.backgroundColor = [UIColor colorWithWhite:(j++%2)?0.9:0.8 alpha:1.0];
            UIColor *textColor = [UIColor blackColor];
            [btn setTitleColor:textColor forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [btn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:[name uppercaseString] forState:UIControlStateNormal];
            [self.contentView addSubview:btn];
        }
        rect.origin.y += rect.size.height+DropMenuVerticalPadding;
    }
    [self.contentView setContentSize:CGSizeMake(0, rect.origin.y - DropMenuVerticalPadding)];
}
- (void)setItems:(NSArray *)items{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0, n = [items count]; i < n; i++) {
        id item = [items objectAtIndex:i];
        if ([item isKindOfClass:[NSDictionary class]]) {
            item = [[BDropMenuItem alloc] initWithDictionary:item];
        }
        [arr addObject:item];
    }
    RELEASE(_items);
    _items = [arr retain];
    [self relayoutBackground];
    [self setup];
}
- (void)setFilterItem:(id)filterItem{
    RELEASE(_filterItem);
    _filterItem = [filterItem retain];
    [self relayoutBackground];
    [self setup];
}
- (void)selectItem:(id)btn{
    int i = [btn tag];
    id item = [self.items objectAtIndex:i];
    DLOG(@"%@",self.delegate);
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropMenu:didSelectItem:)]) {
        [self.delegate dropMenu:self didSelectItem:item];
    }
    if (self.target && self.action) {
        [self.target performSelector:self.action withObject:self withObject:item];
    }
    [self hide];
}
- (void)show{
    if (!self.isRetain) {
        self.isRetain = YES;
        [self retain];
    }
    if ([self.items count] && ([self.items count] > 2 || ![self.items containsObject:self.filterItem])) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (!self.superview) {
            [window addSubview:self];
        }
        [self relayoutBackground];
        [self setHidden:NO];
    }
}
- (void)toggle{
    if (self.isHidden || ![self superview]) {
        [self show];
    }else{
        [self hide];
    }
}
- (void)hide{
    if([self superview]){
        [self setHidden:YES];
        [self removeFromSuperview];
    }
    if (self.isRetain) {
        self.isRetain = NO;
        [self release];
    }
}
- (BOOL)isShow{
    return !self.isHidden && [self superview];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hide];
}
@end

@implementation BDropMenuBackground
@synthesize anchorPoint = _anchorPoint;
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setAnchorPoint:(CGPoint)anchorPoint{
    _anchorPoint = anchorPoint;
    [self setNeedsDisplay];
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    float x1 = self.anchorPoint.x;
    float y1 = 0;
    CGRect r = rect;
	float minx = CGRectGetMinX(r), midx = CGRectGetMidX(r), maxx = CGRectGetMaxX(r);
	float miny = CGRectGetMinY(r)+11, midy = CGRectGetMidY(r), maxy = CGRectGetMaxY(r);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:1.0 alpha:1.0].CGColor);
    CGContextMoveToPoint(ctx, minx, midy);
    int rad = 5.0;
	CGContextAddArcToPoint(ctx, minx, miny, x1-7, miny, rad);
    CGContextAddLineToPoint(ctx, x1-7, miny);
    CGContextAddLineToPoint(ctx, x1, y1);
    CGContextAddLineToPoint(ctx, x1+7, miny);
	CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, rad);
	CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, rad);
	CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, rad);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
}
@end


@implementation BDropMenuItem
@synthesize name = _name;
@synthesize value = _value;
@synthesize dict = _dict;
- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setName:[dict valueForKey:@"name"]];
        [self setValue:[[dict valueForKey:@"value"] description]];
        [self setDict:dict];
    }
    return self;
}
- (NSDictionary *)dict{
    if (!_dict) {
        NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:2];
        [d setValue:self.name forKey:@"name"];
        [d setValue:self.value forKey:@"value"];
        _dict = [d retain];
    }
    return _dict;
}
- (void)setValue:(NSString *)value{
    RELEASE(_value);
    _value = [value isKindOfClass:[NSString class]]?[value retain]:[[value description] retain];
}
- (id)get:(NSString *)key{
    return [self.dict valueForKey:key];
}
- (void)dealloc{
    RELEASE(_name);
    RELEASE(_value);
    RELEASE(_dict);
    [super dealloc];
}

@end