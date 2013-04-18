//
//  BDropTitleView.m
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-8-31.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "BDropTitleView.h"

@implementation BDropTitleView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.titleLabel setFont:gNavTitleFont];
        [self.titleLabel setTextColor:gNavTitleColor];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(-1,0, 0, 0)];
        //UIImage *arrow = [UIImage imageNamed:@"arrow_down"];
        //[self setImage:arrow forState:UIControlStateNormal];
        
        [self.titleLabel.layer setShadowOpacity:1];
        [self.titleLabel.layer setShadowColor:[[UIColor colorWithWhite:0 alpha:0.6] CGColor]];
        [self.titleLabel.layer setShadowRadius:1];
        [self.titleLabel.layer setShadowOffset:CGSizeMake(0, 1)];
    }
    return self;
}
- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    //UIImage *arrow = [self imageForState:UIControlStateNormal];
    //CGSize tsize = [title sizeWithFont:gNavTitleFont];
    //[self setImageEdgeInsets:UIEdgeInsetsMake(self.bounds.size.height-arrow.size.height-1, (tsize.width)/2+arrow.size.width+5, 0, 0)];
}
- (void)drawRect:(CGRect)rect{
    UIImage *arrow =  [UIImage imageNamed:@"arrow_down_small"];
    CGRect r = CGRectZero;
    r.size = arrow.size;
    r.origin.y = rect.size.height - r.size.height-2;
    r.origin.x = (rect.size.width-r.size.width)/2;
    [arrow drawInRect:r];
}
@end
