//
//  SlideNavigationController.h
//  iShow
//
//  Created by baboy on 13-3-18.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppNavigitionController : XUINavigationController

@end
@interface SlidingNavigationController : XUINavigationController
@property (nonatomic, assign) BOOL flexible;
@property (nonatomic, assign) BOOL zooming;
@end

@interface XUIViewController(sliding)
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
@end