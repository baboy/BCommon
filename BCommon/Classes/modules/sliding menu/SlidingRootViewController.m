//
//  RootViewController.m
//  iShow
//
//  Created by baboy on 13-3-17.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "SlidingRootViewController.h"

@interface IIViewDeckController(x)
- (NSMutableArray*) panners;
- (UIView *)referenceView;
- (CGRect) referenceBounds;
- (void) addPanner:(UIView *)view;
- (void) addPanners;
- (UIView*)slidingController;
- (UIView*)slidingControllerView;
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panner;
- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
@end
@interface SlidingRootViewController ()
@end

@implementation SlidingRootViewController
- (void)dealloc{
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToCloseBouncing;
}
- (void)addPanner:(UIView *)view{
    [super addPanner:view];
    [[self.panners lastObject] setDelaysTouchesBegan:YES];
}
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panner{
    BOOL flag = [super gestureRecognizerShouldBegin:panner];
    DLOG(@"flag:%d",flag);
    return flag;
}
- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL flag = [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    DLOG(@"flag:%d",flag);
    return flag;
    
    id view = [touch view];
    id scrollView = nil;
    while (view && ![view isKindOfClass:[UIWindow class]]) {
        if ([view isKindOfClass:[UIScrollView class]] &&
            ([view contentOffset].x !=0 &&
             [(UIScrollView *)view isScrollEnabled])) {
                return NO;
            }
        view = [view superview];
    }
    return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
}
- (UIScrollView *)topScrollView:(UIView *)view{
    UIScrollView *v = nil;
    while (view && ![view isKindOfClass:[UIWindow class]]) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            v = (UIScrollView *)view;
        }
        view = [view superview];
    }
    return v;
}
- (UIScrollView *)figureScrollView:(UIView *)view{
    while (view && ![view isKindOfClass:[UIWindow class]]) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            return (id)view;
        }
        view = [view superview];
    }
    return nil;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL flag = [super gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    UIScrollView *v = [self topScrollView:[otherGestureRecognizer view]];
    UIScrollView *figureView = [self figureScrollView:[otherGestureRecognizer view]];
    if (v && figureView && (v.contentOffset.x == 0 && figureView.contentOffset.x == 0)
        && !figureView.alwaysBounceHorizontal) {
        flag = YES;
    }
    DLOG(@"flag:%d",flag);
    return flag;
}
#pragma mark - IIViewDeckDelegate

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didChangeOffset:(CGFloat)offset orientation:(IIViewDeckOffsetOrientation)orientation panning:(BOOL)panning{
    //DLOG(@"didChangeOffset:%f",offset);
    [UIView animateWithDuration:0.02
                     animations:^{
                         /*
                         CGFloat alpha = (0.8+0.6*ABS(offset)/self.centerController.view.bounds.size.width);
                         self.leftController.view.alpha = alpha;
                         self.rightController.view.alpha = alpha;
                          */
                         CGFloat scale = MIN(0.9+0.12*ABS(offset)/self.centerController.view.bounds.size.width, 1.0);
                         CGAffineTransform transform = CGAffineTransformMakeScale(  scale,  scale );
                         self.leftController.view.transform = transform;
                         self.rightController.view.transform = transform;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
@end
