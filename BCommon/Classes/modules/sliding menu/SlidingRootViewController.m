//
//  RootViewController.m
//  iShow
//
//  Created by baboy on 13-3-17.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "SlidingRootViewController.h"
#import "SlidingViewController.h"

@interface IIViewDeckController(x)
- (UIView *)referenceView;
- (CGRect) referenceBounds;
- (void) addPanner:(UIView *)view;
- (void) addPanners;
- (UIView*)slidingController;
- (UIView*)slidingControllerView;
@end
@interface SlidingRootViewController ()<SlidingViewControllerDelegate>
@property (nonatomic, retain)  SlidingViewController *pushViewController;
@end

@implementation SlidingRootViewController
- (void)dealloc{
    RELEASE(_pushViewController);
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToCloseBouncing;
    
    
}
- (SlidingViewController *)pushViewController{
    if (!_pushViewController) {
        CGRect pushViewFrame = self.referenceBounds;
        pushViewFrame.origin.x = pushViewFrame.size.width;
        _pushViewController = [[SlidingViewController alloc] init];
        _pushViewController.delegate = self;
        _pushViewController.view.backgroundColor = [UIColor clearColor];
        [_pushViewController.view setFrame:pushViewFrame];
        [self.referenceView addSubview:_pushViewController.view];
        [UIView animateWithDuration:0.1
                         animations:^{
                             [_pushViewController.view setFrame:self.referenceBounds];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    return _pushViewController;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.pushViewController pushViewController:viewController animated:YES];
}

- (id)popViewControllerAnimated:(BOOL)animated{
    return [self.pushViewController popViewControllerAnimated:animated];
}

#pragma mark - IIViewDeckDelegate

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didChangeOffset:(CGFloat)offset orientation:(IIViewDeckOffsetOrientation)orientation panning:(BOOL)panning{
    DLOG(@"didChangeOffset:%f",offset);
    [UIView animateWithDuration:0.02
                     animations:^{
                         
                         CGFloat alpha = (0.8+0.6*ABS(offset)/self.centerController.view.bounds.size.width);
                         self.leftController.view.alpha = alpha;
                         self.rightController.view.alpha = alpha;
                         CGFloat scale = MIN(0.97+0.05*ABS(offset)/self.centerController.view.bounds.size.width, 1.0);
                         CGAffineTransform transform = CGAffineTransformMakeScale(  scale,  scale );
                         self.leftController.view.transform = transform;
                         self.rightController.view.transform = transform;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
#pragma mark - slidingNavigationControllerDelegate
- (void)slidingViewController:(SlidingViewController *)slidingViewController didSlideOffset:(CGPoint)p{
    DLOG(@"didSlideOffset");
    [UIView animateWithDuration:0.02
                     animations:^{
                         UIView *backView = [self referenceView];
                         CGFloat alpha = (0.8+0.2*p.x/backView.bounds.size.width);
                         self.centerController.view.alpha = alpha;
                         self.leftController.view.alpha = alpha;
                         self.rightController.view.alpha = alpha;
                         CGFloat scale = MIN(0.97+0.03*p.x/backView.bounds.size.width, 1.0);
                         CGAffineTransform transform = CGAffineTransformMakeScale(  scale,  scale );
                         self.centerController.view.transform = transform;
                         self.leftController.view.transform = transform;
                         self.rightController.view.transform = transform;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (void)slidingViewControllerDidBecomeEmpty:(id)slidingView{
    [self.pushViewController.view removeFromSuperview];
    self.pushViewController = nil;
}
@end
