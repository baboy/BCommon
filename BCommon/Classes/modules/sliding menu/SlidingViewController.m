//
//  SlideNavigationController.m
//  iShow
//
//  Created by baboy on 13-3-18.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "SlidingViewController.h"

#define SlideViewClassFilter    @[@"UISlider", @"UIBarButtonItem"]

enum {
    SlidingViewToLeftSide = 1,
    SlidingViewToRightSide = 2
};
typedef UInt32 SlidingViewOrientation;

@interface SlidingViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, retain) UITouch *firstTouch;
@property (nonatomic, assign) CGPoint panOrigin;
@property (nonatomic, assign) SlidingViewOrientation slidingOrientation;
@property (nonatomic, retain) BaseViewController *slidingController;
- (void)addPannerForController:(UIViewController *)controller;
- (void)addPanner:(UIView *)view;
- (UIView *)slidingControllerView;
@end

@implementation SlidingViewController
- (void)dealloc{
    RELEASE(_firstTouch);
    RELEASE(_viewControllers);
    RELEASE(_slidingController);
    [super dealloc];
}
- (id)init{
    if (self = [super init]) {
        _viewControllers = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self addPanner:self.view];
}
- (void)addPanner:(UIView *)view{
    if (!view) return;
    
    UIPanGestureRecognizer* panner = AUTORELEASE([[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)]);
    panner.cancelsTouchesInView = NO;
    panner.delegate = self;
    [view addGestureRecognizer:panner];
}
- (void)addPannerForController:(UIViewController *)controller{
    if (controller.navigationController) {
        [self addPanner:controller.navigationController.navigationBar];
    }
    [self addPanner:controller.view];
}
- (void)pushViewController:(id)controller canPullBack:(BOOL)pullBack animated:(BOOL)animated{
    
    AppNavigitionController *nav = nil;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        nav = controller;
        controller = nav.topViewController;
    }else{
        nav = AUTORELEASE([[AppNavigitionController alloc] initWithRootViewController:controller]);
        nav.rootController = self.delegate;
    }
    
    CGRect vcFrame = self.view.bounds;
    vcFrame.origin.x = self.view.bounds.size.width;
    
    UIView *wrapper = AUTORELEASE([[UIView alloc] initWithFrame:vcFrame]);
    [wrapper.layer setShadowRadius:10.0];
    [wrapper.layer setShadowOffset:CGSizeMake(0, 0)];
    [wrapper.layer setShadowOpacity:0.5];
    [wrapper.layer setShadowColor:[UIColor colorWithWhite:0 alpha:1.0].CGColor];
    wrapper.layer.shadowPath = [UIBezierPath bezierPathWithRect:wrapper.bounds].CGPath;
    [wrapper setClipsToBounds:NO];
    
    wrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    nav.view.frame = wrapper.bounds;
    nav.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [wrapper addSubview:nav.view];
    [self.view addSubview:wrapper];
    [self addPannerForController:controller];
    
    
    [self.viewControllers addObject:nav];
    
    if (animated) {
        [UIView animateWithDuration:0.1
                         animations:^{
                             wrapper.frame = self.view.bounds;
                         }
                         completion:^(BOOL finished) {
                             DLOG(@"[controller navigationController]:%@, %@", [controller navigationController], nav);
                         }];
    }else{
        nav.view.frame = self.view.bounds;
    }
    
}
- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated{
    [self pushViewController:controller canPullBack:NO animated:animated];
}
- (id)popViewControllerAnimated:(BOOL)animated{
    [self setSlidingControllerWithSlidingOrientation:SlidingViewToRightSide];
    [self slideToOrientation:SlidingViewToRightSide buncesToOrientation:SlidingViewToRightSide];
    return self.slidingController;
}
- (void)pullBack:(BOOL)animated{
    [self setSlidingControllerWithSlidingOrientation:SlidingViewToLeftSide];
    [self slideToOrientation:SlidingViewToLeftSide buncesToOrientation:SlidingViewToLeftSide];
}
- (UIView *)containerForView:(id)controller{
    UIView *view = [controller respondsToSelector:@selector(navigationController)]?
                [controller navigationController].view.superview :
                [controller view].superview;
    return view;
}
- (id)pushBackController{
    id controller = nil;
    for (int i = [self.viewControllers count]-1; i>=0; i--) {
        id c = [[self.viewControllers objectAtIndex:i] topViewController];
        BOOL canPullBack = [c respondsToSelector:@selector(canPullBack)] ? [c canPullBack] : NO;
        if (!canPullBack)
            continue;
        UIView *view = [self containerForView:c];
        if (view.frame.origin.x >= self.view.bounds.size.width) {
            controller = c;
        }
    }
    return controller;
}
- (void)setSlidingControllerWithSlidingOrientation:(SlidingViewOrientation) orientation{
    
    id controller = nil;
    if (orientation == SlidingViewToLeftSide) {
        controller = [self pushBackController];
    }else{
        for (int i = [self.viewControllers count]-1; i>=0; i--) {
            id c = [[self.viewControllers objectAtIndex:i] topViewController];
            UIView *view = [self containerForView:c];
            if (view.frame.origin.x < self.view.bounds.size.width) {
                controller = c;
                break;
            }
        }
        if (!controller) {
            return;
        }
    }
    DLOG(@"[SlidingViewController] setSlidingControllerWithSlidingOrientation:%ld,%@", orientation, controller);
    self.slidingOrientation = orientation;
    self.slidingController = controller;
}
- (UIView *)slidingControllerView{
    id controller = [self slidingController];
    return [self containerForView:controller];
}
- (void)removeController:(id)controller{
    DLOG(@"[SlidingViewController] removeController:%@",controller);
    if (![controller isKindOfClass:[UINavigationController class]]) {
        controller = [controller navigationController];
    }
    int j = [self.viewControllers indexOfObject:controller];
    for (int i = [self.viewControllers count]-1; i >= 0; i--) {
        if (i >= j) {
            id vc = [self.viewControllers objectAtIndex:i];
            [[self containerForView:[vc topViewController]] removeFromSuperview];
            [self.viewControllers removeObject:vc];
        }
    }
    //check 如果没有显示的controller了
    BOOL check = YES;
    for (id vc in self.viewControllers) {
        UIView *containerView = [self containerForView:vc];
        if (containerView && containerView.frame.origin.x < containerView.frame.size.width) {
            check = NO;
            break;
        }
    }
    if (check && [self.viewControllers count]) {
        for (int i=[self.viewControllers count]-1; i>=0; i--) {
            id vc = [self.viewControllers objectAtIndex:i];
            [[self containerForView:vc] removeFromSuperview];
            [self.viewControllers removeObject:vc];
        }
    }
    
    if (![self.viewControllers count] && self.delegate && [self.delegate respondsToSelector:@selector(slidingViewControllerDidBecomeEmpty:)]) {
        [self.delegate slidingViewControllerDidBecomeEmpty:self];
    }
}
- (id)backController{
    if (!self.slidingController) {
        return nil;
    }
    
    int i = [self.viewControllers indexOfObject:[self.slidingController navigationController]];
    if (i>1) {
        return [self.viewControllers objectAtIndex:(i-1)];
    }
    return nil;
}
- (id)controllerWillShowWithSlidingOrientation:(SlidingViewOrientation)orientation{
    id controller = nil;
    for (int i = [self.viewControllers count]-1; i>=0; i--) {
        id c = [[self.viewControllers objectAtIndex:i] topViewController];
        UIView *view = [self containerForView:c];
        CGFloat x = view.frame.origin.x;
        if ( (x >= 0  && x < view.bounds.size.width ) && orientation == SlidingViewToLeftSide) {
            return controller;
        }
        if (x == 0 && orientation == SlidingViewToRightSide) {
            return controller;
        }
    }
    return controller;
}
- (void)notifySlideOffset:(CGPoint)p willShowController:(id)controller{
    DLOG(@"notifySlideOffset:%f",p.x);
    [UIView animateWithDuration:0.05
                     animations:^{
                         UIView *backView = [self containerForView:[self backController]];
                         backView.alpha = (0.8+0.2*p.x/backView.bounds.size.width);
                         CGFloat scale = MIN(0.97+0.03*p.x/backView.bounds.size.width, 1.0);
                         CGAffineTransform transform = CGAffineTransformMakeScale(  scale,  scale );
                         backView.transform = transform;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(slidingViewController:didSlideOffset:)]) {
        [self.delegate slidingViewController:self didSlideOffset:p];
    }
}
- (void)notifyWillShowController:(id)controller{
    if (!controller) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(slidingNavigationControllerWillBecomeEmpty:)]) {
            [self.delegate slidingViewControllerWillBecomeEmpty:self];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(slidingViewController:willSlideToController:)]) {
        [self.delegate slidingViewController:self willSlideToController:controller];
    }
}
- (void)notifyDidShowController:(id)controller{
    if (self.delegate && [self.delegate respondsToSelector:@selector(slidingViewController:didSlideToController:)]) {
        [self.delegate slidingViewController:self didSlideToController:controller];
    }
}
//orientation：手指互动方向 buncesOrientation：弹回方向
//例如向右滑尺寸不够，向左弹回

#pragma mark - Panning

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panner {
    CGPoint velocity = [panner velocityInView:self.view];
    NSLog(@"gestureRecognizerShouldBegin:%@", NSStringFromCGPoint(velocity));
    if (self.firstTouch) {
        UIView *v = [self.firstTouch view];
        if (![v isKindOfClass:[UIScrollView class]]) {
            while (v.superview && ![v isKindOfClass:[UIScrollView class]] ) {
                v = v.superview;
            }
        }
        if ([v isKindOfClass:[UIScrollView class]]) {
            if ([(UIScrollView *)v contentOffset].x > 0 || velocity.x < 0) {
                return NO;
            }
        }
        SlidingViewOrientation orientation = velocity.x > 0 ? SlidingViewToRightSide : SlidingViewToLeftSide;
        [self setSlidingControllerWithSlidingOrientation:orientation];
    }
    NSLog(@"gestureRecognizerShouldBegin slidingController:%@", self.slidingController);
    if (ABS(velocity.x) <= ABS(velocity.y))
        return NO;
    if (!self.slidingController) {
        return NO;
    }
    self.panOrigin = [self slidingControllerView].frame.origin;
    
    CGFloat pv = [self slidingControllerView].frame.origin.x;
    if (pv != 0)
        return YES;
    CGFloat v = [self locationOfPanner:panner];
    if ( v < 0 ) {
        DLOG(@"no begin");
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    NSLog(@"gestureRecognizer shouldReceiveTouch:%@%@", NSStringFromCGPoint(velocity), NSStringFromCGPoint([self slidingControllerView].frame.origin));
    self.firstTouch = touch;
    id view = [touch view];
    if ([view isKindOfClass:[UISlider class]])
        return NO;
    while (view && ![view isKindOfClass:[UIWindow class]]) {
        if ([view isKindOfClass:[UIScrollView class]] && [view contentOffset].x !=0) {
            return NO;
        }
        view = [view superview];
    }
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //return NO;
    return YES;
}
- (CGFloat)locationOfPanner:(UIPanGestureRecognizer*)panner{
    CGPoint pan = [panner translationInView:self.view];
    CGFloat offx = pan.x+self.panOrigin.x;
    return offx;
}
- (void)panned:(UIPanGestureRecognizer*)panner {
    CGPoint velocity = [panner velocityInView:self.view];
    //DLOG(@"panned:%f, %f, %f, %@", [self locationOfPanner:panner], velocity.x, velocity.y, NSStringFromCGPoint([panner translationInView:self.view]));
    if (panner.state == UIGestureRecognizerStateBegan) {
    }
    else {
        CGFloat x = [self locationOfPanner:panner];
        CGRect slidingViewFrame = self.slidingControllerView.frame;
        if ( x >= 0 ) {
            slidingViewFrame.origin.x = x;
            [self.slidingControllerView setFrame:slidingViewFrame];
        }
        
        id willShowController = [self controllerWillShowWithSlidingOrientation:self.slidingOrientation];
        [self notifySlideOffset:slidingViewFrame.origin willShowController:willShowController];
        
        if (panner.state == UIGestureRecognizerStateEnded ||
            panner.state == UIGestureRecognizerStateCancelled ||
            panner.state == UIGestureRecognizerStateFailed){
            self.firstTouch = nil;
            
            BOOL flag = (ABS([panner translationInView:self.view].x) > slidingViewFrame.size.width/3);
            SlidingViewOrientation buncesOrientation = SlidingViewToLeftSide;
            if ( (flag && self.slidingOrientation == SlidingViewToRightSide) ||
                (!flag && self.slidingOrientation == SlidingViewToLeftSide) ) {
                buncesOrientation = SlidingViewToRightSide;
            }
            [self slideToOrientation:self.slidingOrientation
                 buncesToOrientation:buncesOrientation];
            return;
            if (flag) {//向右
                slidingViewFrame.origin.x = self.slidingOrientation == SlidingViewToLeftSide?0:slidingViewFrame.size.width;
            }else{
                slidingViewFrame.origin.x = self.panOrigin.x;
            }
            [self notifyWillShowController:willShowController];
            [UIView animateWithDuration:0.2
                             animations:^{
                                 [self.slidingControllerView setFrame:slidingViewFrame];
                             }
                             completion:^(BOOL finished) {
                                 //
                                 if (finished) {
                                     [self notifySlideOffset:slidingViewFrame.origin willShowController:willShowController];
                                     [self notifyDidShowController:willShowController];
                                     if (slidingViewFrame.origin.x >= slidingViewFrame.size.width && ![self.slidingController canPullBack]) {
                                         [self removeController:self.slidingController];
                                     }
                                 }
                             }];
        }
    }
}
- (void)slideToOrientation:(SlidingViewOrientation)orientation
       buncesToOrientation:(SlidingViewOrientation)buncesOrientation{
    
    id willShowController = [self controllerWillShowWithSlidingOrientation:self.slidingOrientation];
    CGRect slidingViewFrame = self.slidingControllerView.frame;
    if (orientation != buncesOrientation) {//弹回
        slidingViewFrame.origin.x = self.panOrigin.x;
    }else{
        slidingViewFrame.origin.x = self.slidingOrientation == SlidingViewToLeftSide?0:slidingViewFrame.size.width;
    }
    [self notifyWillShowController:willShowController];
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.slidingControllerView setFrame:slidingViewFrame];
                     }
                     completion:^(BOOL finished) {
                         //
                         if (finished) {
                             [self notifySlideOffset:slidingViewFrame.origin willShowController:willShowController];
                             [self notifyDidShowController:willShowController];
                             DLOG(@"");
                             if (slidingViewFrame.origin.x >= slidingViewFrame.size.width && ![self.slidingController canPullBack]) {
                                 [self removeController:self.slidingController];
                             }
                         }
                     }];
    
}
@end