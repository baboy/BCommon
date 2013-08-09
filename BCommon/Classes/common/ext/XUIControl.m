//
//  XUIControl.m
//  iShow
//
//  Created by baboy on 13-7-2.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "XUIControl.h"
@interface XUIControl()

@property (nonatomic, retain) NSMutableDictionary *imageDict;
@end

@implementation XUIControl
- (void)dealloc{
    RELEASE(_imageDict);
    RELEASE(_object);
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (id)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (NSMutableDictionary *)imageDict{
    if (!_imageDict) {
        _imageDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    return _imageDict;
}
- (void) setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state{
    [self.imageDict setValue:backgroundImage forKey:[NSString stringWithFormat:@"%d",UIControlStateNormal]];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    UIImage *img = [self.imageDict valueForKey:[NSString stringWithFormat:@"%d",self.state]];
    if (img) {
        [img drawInRect:rect];
    }
}

@end
