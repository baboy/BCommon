//
//  UIButton+x.h
//  iLookForiPad
//
//  Created by baboy on 13-3-20.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton(x)
- (void)centerImageAndTitle:(float)space;
- (void)centerImageAndTitle;
- (void)setImageURL:(NSURL *)url forState:(UIControlState)state;
- (void)setImageURLString:(NSString *)url forState:(UIControlState)state;
- (void)setBackgroundImageURL:(NSURL *)imageURL forState:(UIControlState)state;
@end
