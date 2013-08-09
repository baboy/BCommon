//
//  XUIControl.h
//  iShow
//
//  Created by baboy on 13-7-2.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XUIControl : UIControl
@property (nonatomic, retain) NSObject *object;
- (void) setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state;
@end
