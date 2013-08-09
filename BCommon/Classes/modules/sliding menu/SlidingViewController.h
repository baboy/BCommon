//
//  SlideNavigationController.h
//  iShow
//
//  Created by baboy on 13-3-18.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlidingViewControllerDelegate;

@interface SlidingViewController : XUIViewController
@property (nonatomic, assign) id<SlidingViewControllerDelegate> delegate;
@property (nonatomic, readonly) NSMutableArray *viewControllers;
- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated;
- (void)pushViewController:(UIViewController *)controller canPullBack:(BOOL)pullBack animated:(BOOL)animated;
- (id)popViewControllerAnimated:(BOOL)animated;
- (void)pullBack:(BOOL)animated;
@end

@protocol  SlidingViewControllerDelegate<NSObject>
@optional
- (void) slidingViewController:(id)slidingView didSlideOffset:(CGPoint)point;
- (void) slidingViewController:(id)slidingView willSlideToController:(UIViewController *)controller;
- (void) slidingViewController:(id)slidingView didSlideToController:(UIViewController *)controller;
- (void) slidingViewControllerWillBecomeEmpty:(id)slidingView;
- (void) slidingViewControllerDidBecomeEmpty:(id)slidingView;
@end