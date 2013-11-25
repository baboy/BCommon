//
//  RootViewController.m
//  iShow
//
//  Created by baboy on 13-3-17.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "SlidingRootViewController.h"
#define DebugLog(...)    DLOG(__VA_ARGS__)

@interface IIViewDeckController(x)
- (NSMutableArray*) panners;
- (void)panned:(UIPanGestureRecognizer*)panner;
- (UIView *)referenceView;
- (UIView *)centerView;
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
/*
- (void)addPanner:(UIView *)view{
    [super addPanner:view];
    UIPanGestureRecognizer *pan = [self.panners lastObject];
    //pan.delaysTouchesBegan = YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panner{
    BOOL flag = [super gestureRecognizerShouldBegin:panner];
    CGPoint velocity = [panner velocityInView:[panner view]];
    DebugLog(@"velocity:%f",velocity.x);

    DebugLog(@"flag:%d",flag);
    return flag;
}
- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint velocity = [gestureRecognizer velocityInView:[touch view]];
    DebugLog(@"velocity:%f",velocity.x);
    BOOL flag = [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    
    DebugLog(@"flag:%d",flag);
    return flag;
    UIScrollView *view = [self figureScrollView:[touch view]];
    if ([view isKindOfClass:[UIScrollView class]]){
        //
        if ([view alwaysBounceHorizontal]) {
            flag = NO;
        }else{
            flag = NO;
            if ( ([view contentOffset].x ==0 && velocity.x >= 0) || (([view contentOffset].x+view.bounds.size.width) == [view contentSize].width && velocity.x<=0)) {
                flag = YES;
            }
        }
    }

    DebugLog(@"flag:%d",flag);
    return flag;
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
-(BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    BOOL flag = [super gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    if ([APPWindowRootController viewControllers].count > 1) {
        return flag;
    }
    DebugLog(@"flag:%d",flag);
    return flag;
    UIScrollView *v = [self topScrollView:[otherGestureRecognizer view]];
    UIScrollView *figureView = [self figureScrollView:[otherGestureRecognizer view]];
    if (v && figureView ) {
        if ([v alwaysBounceHorizontal]) {
            flag = NO;
        }else{
            flag = NO;
            if ( ([v contentOffset].x ==0 && velocity.x >= 0) || (([v contentOffset].x+v.bounds.size.width) == [v contentSize].width && velocity.x<=0)) {
                flag = YES;
            }
        }
    }else {
        if( !v && gestureRecognizer.view == [self centerView] ){
            flag = YES;
            DebugLog(@"");
        }else{
            DebugLog(@"");
        }
    }
    DebugLog(@"velocity:%f",velocity.x);
    DebugLog(@"flag:%d",flag);
    return flag;
}
- (void)panned:(UIPanGestureRecognizer *)panner{
    DLOG(@"");
    [panner locationInView:panner.view];
    UIScrollView *figureView = [self figureScrollView:[panner view]];
    [super panned:panner];
    return;
    if (panner.state == UIGestureRecognizerStateBegan) {
        UIView *maskView = [[UIView alloc] initWithFrame:panner.view.bounds];
        maskView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.7];
        //[panner.view addSubview:maskView];
        figureView.scrollEnabled = NO;
    }else if(panner.state == UIGestureRecognizerStateEnded || panner.state == UIGestureRecognizerStateFailed){
        figureView.scrollEnabled = YES;
    }
}
*/
#pragma mark - IIViewDeckDelegate

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didChangeOffset:(CGFloat)offset orientation:(IIViewDeckOffsetOrientation)orientation panning:(BOOL)panning{
    //DebugLog(@"didChangeOffset:%f",offset);
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
