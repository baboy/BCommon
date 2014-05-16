//
//  XUIView.m
//  iShow
//
//  Created by baboy on 13-5-4.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "XUIView.h"

@implementation XUIView
- (void)dealloc{
    RELEASE(_backgroundImage);
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self setExclusiveTouch:YES];
    }
    return self;
}
- (void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
}
+ (void)toggleWithView:(UIView *)view1 withView2:(UIView *)view2 withLocation:(XUIViewToggleLocation)location animated:(BOOL)animated{
    CGRect frame1 = view1.frame;
    CGRect frame2 = view2.frame;
    switch (location) {
        case XUIViewToggleLocationTop:{
            BOOL isShowView1 = frame1.origin.y>=0?NO:YES;
            frame1.origin.y = isShowView1?0:-frame1.size.height;
            frame2.origin.y = isShowView1?-frame2.size.height:0;
            break;
        }
        case XUIViewToggleLocationLeft:{
            BOOL isShowView1 = frame1.origin.x>=0?NO:YES;
            frame1.origin.x = isShowView1?0:-frame1.size.width;
            frame2.origin.x = isShowView1?-frame2.size.width:0;
            break;
        }
        case XUIViewToggleLocationBottom:{
            float superViewHeight = view1.superview.frame.size.height;
            BOOL isShowView1 = frame1.origin.y >= superViewHeight;
            frame1.origin.y = isShowView1?(superViewHeight-frame1.size.height):superViewHeight;
            frame2.origin.y = isShowView1?superViewHeight:(superViewHeight-frame2.size.height);
            break;
        }
        case XUIViewToggleLocationRight:{
            float superViewWidth = view1.superview.frame.size.width;
            BOOL isShowView1 = frame1.origin.x >= superViewWidth;
            frame1.origin.x = isShowView1?(superViewWidth-frame1.size.width):superViewWidth;
            frame2.origin.x = isShowView1?superViewWidth:(superViewWidth-frame2.size.width);
            break;
        }   
        default:
            break;
    }
    [UIView animateWithDuration:(animated?0.2:0)
                     animations:^{
                         view1.frame = frame1;
                         view2.frame = frame2;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (void)setPannelStyleDefault{
    self.layer.cornerRadius = 5.0;
    self.layer.shadowColor = [gShadowColor CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 1.0;
    self.layer.shadowOpacity = 1.0;
}
- (void)setBackgroundImage:(UIImage *)backgroundImage{
    RELEASE(_backgroundImage);
    _backgroundImage = [backgroundImage retain];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    [self.backgroundImage drawInRect:rect];
}
@end

@implementation UIView(x)
- (UIImage *)screenshot{
    CGRect rect = self.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO,0);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:currentContext];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
- (UIView *)showEmptyMsg:(NSString *)msg withNetIndicator:(BOOL)withIndicator icon:(NSString *)iconName withTarget:(id)target withAction:(SEL)action{
    UIView *container = [self viewWithTag:-99999999];
    if (container) {
        [self removeEmptyIndicator];
    }
    container = [[UIView alloc] initWithFrame:self.bounds];
    float w = container.bounds.size.width, h = container.bounds.size.height;
    UIImage *icon = [UIImage imageNamed:iconName];
    CGRect iconFrame = CGRectMake((w-icon.size.width)/2, h*0.35-icon.size.height/2, icon.size.width, icon.size.height);
    UIButton *btn = [[UIButton alloc] initWithFrame:iconFrame];
    [btn setImage:icon forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btn];
    float indicatorWidth = withIndicator?20:0;
    CGRect labelFrame = CGRectMake(0, iconFrame.origin.y+icon.size.height+10, w, 40);
    CGSize msgSize = [msg sizeWithFont:ThemeDescTextFont constrainedToSize:CGSizeMake(w, MAXFLOAT)];
    labelFrame.size.width = msgSize.width;
    labelFrame.origin.x = (w-labelFrame.size.width)/2+indicatorWidth/2;
    UILabel *msgLabel = createLabel(labelFrame, ThemeDescTextFont, nil, ThemeDescTextColor, ThemeDescTextShadowColor, CGSizeMake(0, 1), UITextAlignmentCenter, 0, UILineBreakModeTailTruncation);
    msgLabel.text = msg;
    if (target && action) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [container addGestureRecognizer:tap];
    }
    [container addSubview:msgLabel];
    
    
    if (withIndicator) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect indicatorFrame = CGRectMake(labelFrame.origin.x - 24, labelFrame.origin.y+(labelFrame.size.height-msgSize.height)/2, 20, 20);
        indicator.frame = indicatorFrame;
        [indicator startAnimating];
        [container addSubview:indicator];
    }
    
    [self addSubview:container];
    container.tag = -99999999;
    return container;
}
- (UIView *)showEmptyMsg:(NSString *)msg icon:(NSString *)iconName withTarget:(id)target withAction:(SEL)action{
    return [self showEmptyMsg:msg withNetIndicator:NO icon:iconName withTarget:target withAction:action];
}
- (void)removeEmptyIndicator{
    UIView *v = [self viewWithTag:-99999999];
    [v removeFromSuperview];
}
@end