//
//  SlideNavigationController.m
//  iShow
//
//  Created by baboy on 13-3-18.
//  Copyright (c) 2013年 baboy. All rights reserved.
//


#import "SlidingNavigationController.h"
#define DebugLog(...)    DLOG(__VA_ARGS__)
#define AppRootNavigationController (id)[[APPDelegate window] rootViewController]

@interface AppNavigitionInternalController:UIViewController
@property (nonatomic, retain) AppNavigitionController *appNavigitionController;
@property (nonatomic, retain) UINavigationController *customNavigationController;
@end
@implementation AppNavigitionInternalController
- (void)dealloc{
    RELEASE(_appNavigitionController);
    RELEASE(_customNavigationController);
    [super dealloc];
}
- (UINavigationController *)navigationController{
    return self.customNavigationController;
}
@end
@interface AppNavigitionController()
@property (nonatomic, retain) UIViewController *wrapperController;
@end
@implementation AppNavigitionController
- (void)dealloc{
    RELEASE(_wrapperController);
    [super dealloc];
}
- (id)rootController{
    id rootController = AppRootNavigationController;
    while ([rootController modalViewController]) {
        rootController = [rootController modalViewController];
    }
    return rootController;
}
- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    int vcCount = [super.viewControllers count];
    DebugLog(@"%d", vcCount);
    if ( vcCount < 1) {
        [super pushViewController:viewController animated:animated];
        return;
    }
    [[self rootController] pushViewController:viewController animated:animated];
}
- (NSArray*)viewControllers{
    return [[self rootController] viewControllers];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    id rootController = [self rootController];
    if (self == rootController) {
        return [super popViewControllerAnimated:animated];
    }
    return [rootController popViewControllerAnimated:animated];
}
- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
    id rootController = [self rootController];
    if (self == rootController) {
        [super presentModalViewController:modalViewController animated:animated];
    }
    [rootController presentModalViewController:modalViewController animated:animated];
}
- (void)dismissModalViewControllerAnimated:(BOOL)flag{
    id vc = [self wrapperController];
    vc = [vc navigationController];
    [vc dismissModalViewControllerAnimated:YES];
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    id rootController = [self rootController];
    return [rootController popToRootViewControllerAnimated:animated];
}
@end

@interface SlidingNavigationController()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *blackMaskView;
@property (nonatomic, assign, getter = isDraging) BOOL  draging;
@property (nonatomic, assign) CGPoint firstTouchPoint;
@end

@implementation SlidingNavigationController

- (void)dealloc{
    RELEASE(_controllers);
    RELEASE(_container);
    RELEASE(_blackMaskView);
    [super dealloc];
}
- (NSMutableArray *)controllers{
    if (!_controllers) {
        _controllers = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _controllers;
}
- (UIView *)container{
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:self.view.bounds];
        _container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _container.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_container];
    }
    return _container;
}
- (void)printView:(UIView *)view level:(int)level{
    NSMutableString *prefix = [NSMutableString stringWithString:@"-"];
    for (int i = 0; i<level; i++) {
        [prefix appendString:@"-"];
    }
    DebugLog(@"%@%@",prefix,view);
    for (int i = 0,n = [view.subviews count]; i < n; i++) {
        [self printView:[view.subviews objectAtIndex:i] level:level+1];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.navigationBar.hidden = YES;
    // add guesture
    
    UIPanGestureRecognizer *pan =
    AUTORELEASE([[UIPanGestureRecognizer alloc]initWithTarget:self
                                                       action:@selector(pan:)]);
    pan.delaysTouchesBegan = YES;
    pan.delegate = self;
    pan.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:pan];
}
- (UIViewController *)wrapperController:(UIViewController *)vc{
    AppNavigitionController *subNav = (id)vc;
    if (![subNav isKindOfClass:[AppNavigitionController class]]) {
        subNav = AUTORELEASE([[AppNavigitionController alloc] initWithRootViewController:vc]);
        subNav.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    AppNavigitionInternalController *wrapper = AUTORELEASE([[AppNavigitionInternalController alloc] init]);
    subNav.wrapperController = wrapper;
    wrapper.view.backgroundColor = [UIColor whiteColor];
    wrapper.appNavigitionController = subNav;
    wrapper.customNavigationController = self;
    subNav.view.frame = wrapper.view.bounds;
    [wrapper.view addSubview:subNav.view];
    if (self.viewControllers.count>=1) {
        vc.navigationItem.leftBarButtonItem = [Theme navBarButtonForKey:@"navigationbar-back-button" withTarget:vc action:@selector(popViewController:)];
    }
    return wrapper;
}
- (UIView *)blackMaskView{
    if (!_blackMaskView) {
        _blackMaskView = [[UIView alloc] initWithFrame:self.container.bounds];
        _blackMaskView.backgroundColor = [UIColor blackColor];
        _blackMaskView.alpha = 0.4;
        _blackMaskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    };
    return _blackMaskView;
}
- (UIView *)currentView{
    return [[self.controllers lastObject] view];
}
- (UIView *)previousView{
    int n = self.controllers.count;
    return n > 1 ? [[self.controllers objectAtIndex:n-2] view] : nil;
}
- (void)relayout{
    //
    if (!self.currentView.superview) {
        [self.container addSubview:self.currentView];
    }
    CGPoint p = self.currentView.frame.origin;
    if (self.blackMaskView.superview!=self.previousView) {
        [self.blackMaskView removeFromSuperview];
        [self.previousView addSubview:self.blackMaskView];
    }
    float alpha = 0.4 - (p.x/800);
    self.blackMaskView.alpha = alpha;
    
    if (self.zooming){
        float scale = (p.x/(self.view.bounds.size.width/0.05))+0.95;
        self.previousView.transform = CGAffineTransformMakeScale(scale, scale);
    }
    if (self.flexible) {
        CGRect previousViewFrame = self.previousView.frame;
        previousViewFrame.origin.x = -previousViewFrame.size.width*0.8 +p.x*0.8;
        self.previousView.frame = previousViewFrame;
    }
}
- (NSArray *)viewControllers{
    return self.controllers;
}
- (void)controllerDisappear:(AppNavigitionInternalController *)internalController{
    UIViewController *vc = internalController.appNavigitionController.topViewController;
    [vc viewWillDisappear:YES];
    [vc viewDidDisappear:YES];
}
- (void)controllerAppear:(AppNavigitionInternalController *)internalController{
    UIViewController *vc = internalController.appNavigitionController.topViewController;
    [vc viewWillAppear:YES];
    [vc viewDidAppear:YES];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    DLOG(@"");
    UIViewController *wrapperController = [self wrapperController:viewController];
    if (self.controllers.count == 0) {
        [self.controllers addObject:wrapperController];
        wrapperController.view.frame = self.container.bounds;
        [self relayout];
        DebugLog(@"controller count:%d",self.controllers.count);
        return;
    }
    [self controllerDisappear:self.controllers.lastObject];
    CGRect viewFrame = self.container.bounds;
    viewFrame.origin.x = viewFrame.size.width;
    wrapperController.view.frame = viewFrame;
    [self.controllers addObject:wrapperController];
    [self relayout];
    
    [self controllerAppear:self.controllers.lastObject];
    if (!animated) {
        wrapperController.view.frame = self.container.bounds;
        return;
    }
    DebugLog(@"controller count:%d",self.controllers.count);
    [self dragToPoint:CGPointZero completion:^(BOOL finished) {
        
    }];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (!animated) {
        AppNavigitionInternalController *lastViewController = [self.controllers lastObject];
        [self controllerDisappear:lastViewController];
        [self.controllers removeLastObject];
        [lastViewController.view removeFromSuperview];
        [self controllerAppear:[self.controllers lastObject]];
        [self currentView].frame = self.container.bounds;
        [self relayout];
        DebugLog(@"controller count:%d",self.controllers.count);
        return lastViewController;
    }
    [self relayout];
    [self dragToPoint:CGPointMake(self.container.bounds.size.width, 0)
           completion:^(BOOL finished) {
               [self popViewControllerAnimated:NO];
           }];
    return [self.controllers lastObject];
}
-(void)popViewController:(id)sender{
    [self popViewControllerAnimated:YES];
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    if (self.viewControllers.count<=1) {
        return [super popToRootViewControllerAnimated:animated];
    }
    NSRange r = {1,0};
    r.length = self.viewControllers.count-2;
    NSArray *removedControllers = [self.viewControllers subarrayWithRange:r];
    for (AppNavigitionInternalController *vc in removedControllers) {
        [vc.view removeFromSuperview];
    }
    [self.controllers removeObjectsInRange:r];
    [self popViewControllerAnimated:animated];
    return removedControllers;
}
/**
 * p为navigation view 的坐标
 * 根据p 设置背景坐标
 */
- (void)dragToPoint:(CGPoint)p completion:(void (^)(BOOL finished))completion
{
    
    //DebugLog(@"Move to:%f",p.x);
    p.x = MIN(self.container.bounds.size.width, p.x);
    p.x = MAX(p.x, 0);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect frame = self.container.bounds;
                         frame.origin = p;
                         self.currentView.frame = frame;
                         [self relayout];
                     }
                     completion:^(BOOL finished) {
                         //DebugLog(@"%d",finished);
                         if (completion) {
                             completion(finished);
                         }
                     }];
    
}

#pragma mark - Gesture Recognizer -

- (void)pan:(UIPanGestureRecognizer *)recoginzer
{
    if ( self.viewControllers.count <= 1 )
        return;
    UIView *refrenceView = [[UIApplication sharedApplication] keyWindow];
    refrenceView = self.view;
    CGPoint touchPoint = [recoginzer locationInView:refrenceView];
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        self.draging = YES;
        self.firstTouchPoint = touchPoint;
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - self.firstTouchPoint.x > 50)
        {
            [self dragToPoint:CGPointMake(self.container.bounds.size.width, 0) completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                self.draging = NO;
            }];
        }
        else
        {
            [self dragToPoint:CGPointZero completion:^(BOOL finished) {
                self.draging = NO;
            }];
            
        }
        return;
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        [self dragToPoint:CGPointZero completion:^(BOOL finished) {
            self.draging = NO;
            
        }];
        
        return;
    }
    // it keeps move with touch
    if (self.draging) {
        CGPoint p = CGPointZero;
        p.x = touchPoint.x - self.firstTouchPoint.x;
        [self dragToPoint:p completion:nil];
    }
}
- (BOOL)canDrag{
    AppNavigitionInternalController *ic = [self.viewControllers lastObject];
    id vc = [[ic appNavigitionController] topViewController];
    if ([vc respondsToSelector:@selector(canDrag)]) {
        return [vc canDrag];
    }
    return YES;
}
#pragma panner delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ( self.viewControllers.count <= 1 || ![self canDrag])
        return NO;
    DLOG(@"flag:%d",YES);
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ( self.viewControllers.count <= 1 )
        return NO;
    return YES;
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
@end