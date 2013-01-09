//
//  BToolBar.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/5/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "BToolBar.h"
#import <QuartzCore/QuartzCore.h>
#define TOP_GARD_COLOR      [UIColor colorWithWhite:0.9 alpha:1]
#define MID_GARD_COLOR      [UIColor colorWithWhite:0.8 alpha:1]
#define BOTTOM_GARD_COLOR   [UIColor colorWithWhite:0.7 alpha:1]
#define TOP_BORDER_COLOR    [UIColor colorWithWhite:1.0 alpha:1]

@interface BToolBar()
- (void)setLayer;
@end

@implementation BToolBar
@synthesize style = _style;
+(Class)layerClass{
    return [CAGradientLayer class];
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setLayer];
    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setClipsToBounds:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setLayer];
    }
    return self;
}
- (void)setLayer{
    //
    
    [self setBackgroundColor:[UIColor blackColor]];
    return;
    CAGradientLayer *layer = (CAGradientLayer*)[self layer];
    switch (self.style) {
        case BToolBarStyleDefault:
            
            layer.colors = [NSArray arrayWithObjects:(id)[TOP_BORDER_COLOR CGColor],(id)[TOP_GARD_COLOR CGColor],
                            (id)[MID_GARD_COLOR CGColor],
                            (id)[BOTTOM_GARD_COLOR CGColor],nil];
            layer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0],
                               [NSNumber numberWithFloat:2.0/self.frame.size.height],
                               [NSNumber numberWithFloat:0.5],
                               [NSNumber numberWithFloat:1],nil];
            
            layer.shadowOpacity = 1.0; 
            layer.shadowColor = [[UIColor colorWithWhite:0.1 alpha:0.6] CGColor];            
            layer.shadowOffset = CGSizeMake(0, 1); 
            layer.shadowRadius = 2.0; 
            
            break;
        case BToolBarStyleBlackTranslucent:
            
            layer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor],(id)[[UIColor colorWithWhite:0 alpha:0.4] CGColor],nil];
            layer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0],
                               [NSNumber numberWithFloat:1],nil];
            
            layer.shadowOpacity = 1.0; 
            layer.shadowColor = [[UIColor colorWithWhite:0.0 alpha:1] CGColor];            
            layer.shadowOffset = CGSizeMake(0, -1); 
            layer.shadowRadius = 1.0; 
            break;            
        default:
            layer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],(id)[[UIColor clearColor] CGColor], nil];
            layer.shadowColor = [[UIColor clearColor] CGColor];
            layer.shadowOpacity = 0;     
            layer.shadowOffset = CGSizeZero;
            
            break;
    }
    layer.startPoint = CGPointZero;
    layer.endPoint = CGPointMake(0, 1);
    NSLog(@"initLayer:%@",layer);
}
- (void)setStyle:(BToolBarStyle)style{
    _style = style;
    [self setLayer];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    if (self.style != BToolBarStyleBlue && self.style != BToolBarStyleTranslucent) {
        return;
    }
    float alpha = 1.0;
    if (self.style == BToolBarStyleTranslucent) {
        alpha = 0.6;
    }
    UIImage *image = [UIImage imageNamed:@"toolbar_bg.png"]; 
    [image drawInRect:rect blendMode:kCGBlendModeNormal alpha:alpha];
}
@end
