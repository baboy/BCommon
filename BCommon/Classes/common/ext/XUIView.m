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
