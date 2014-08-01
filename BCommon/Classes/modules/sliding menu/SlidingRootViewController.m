//
//  RootViewController.m
//  iShow
//
//  Created by baboy on 13-3-17.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "SlidingRootViewController.h"
#define DebugLog(...)    DLOG(__VA_ARGS__)
#define AlertViewTagCheckVersion 11

#define AlertViewCommentApp 20
#define AlertViewCommentAppGoodIndex    2


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
@property (nonatomic, retain) ApplicationVersion *app;
@end

@implementation SlidingRootViewController
- (void)dealloc{
    [super dealloc];
    RELEASE(_app);
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
- (void)commentApp{
    int t = get_current_app_start_times();
    NSString *commentMsg = [DBCache valueForKey:@"app_store_comment_msg"];
    if ( (t>0 && t%3==0) && !get_current_app_comment() && (AppStore && [AppStore isURL]) && [commentMsg length]>10) {
        UIAlertView *alert = [self alertWithTitle:nil
                                          message:commentMsg
                                           button:NSLocalizedString(@"太烂了,不评", nil),
                              NSLocalizedString(@"一般般,不评", nil),
                              NSLocalizedString(@"挺好的,好评", nil),
                              NSLocalizedString(@"取消", nil),nil];
        alert.tag = AlertViewCommentApp;
    }
}

- (void)checkAppViersion{
    [ApplicationVersion getAppVersionCallback:^(BHttpRequestOperation *operation,ApplicationVersion *app, NSError *error) {
        self.app = app;
        NSString *msg = app.msg;
        NSMutableArray *btnTitles = [NSMutableArray array];
        switch (app.role) {
            case AppUpdateRoleMsg:
                [btnTitles addObject:NSLocalizedString(@"确定", nil)];
                break;
            case AppUpdateRolePrompt:
                [btnTitles addObject:NSLocalizedString(@"取消", nil)];
                [btnTitles addObject:NSLocalizedString(@"确定", nil)];
                break;
            case AppUpdateRoleUpdate:
                [btnTitles addObject:NSLocalizedString(@"确定", nil)];
                break;
            case AppUpdateRoleForbidden:
                [btnTitles addObject:NSLocalizedString(@"确定", nil)];
                break;
                
            default:
                break;
        }
        if (btnTitles.count>0) {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                       message:nil
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
            alert.tag = AlertViewTagCheckVersion;
            alert.message = msg;
            for (int i = 0, n = (int)btnTitles.count; i < n; i++) {
                [alert addButtonWithTitle:[btnTitles objectAtIndex:i]];
            }
            [alert show];
            
        }
    }];
}

+ (void)showNetConnectMessage{
    NSString *msg = NoAvailableConnection;
    if ([NetChecker isAvailable]) {
        msg = [NSString stringWithFormat:NSLocalizedString(@"你使用的是%@网络!", nil),
               ([NetChecker isConnectWifi] ? @"WIFI" : @"2G/3G/4G")];
    }
    [BIndicator showMessage:msg duration:2.0f];
}

- (UIAlertView*)alert:(NSString *)msg button:(NSString *)buttonTitle,...{
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:2];
    va_list args;
    va_start(args, buttonTitle);
    id arg;
    if (buttonTitle) {
        [buttons addObject:buttonTitle];
        while ( (arg = va_arg(args, NSString*) ) != nil) {
            [buttons addObject:arg];
        }
    }
    va_end(args);
    return [self alertWithTitle:nil message:msg button:buttons,nil];
}
- (UIAlertView*)alertWithTitle:(NSString *)title message:(NSString *)msg button:(id)buttonTitle,...{
    if (!msg) {
        return nil;
    }
    NSMutableArray *buttons = nil;
    if ([buttonTitle isKindOfClass:[NSArray class]]) {
        buttons = buttonTitle;
    }else{
        buttons = [NSMutableArray arrayWithCapacity:2];
        va_list args;
        va_start(args, buttonTitle);
        id arg;
        if (buttonTitle) {
            [buttons addObject:buttonTitle];
            while ( (arg = va_arg(args, NSString*) ) != nil) {
                [buttons addObject:arg];
            }
        }
        va_end(args);
    }
    if ([buttons count] == 0) {
        buttons = [NSMutableArray arrayWithObject:NSLocalizedString(@"确定", @"alert")];
    }
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", nil)
                                                     message:msg
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil] autorelease];
    int n = [buttons count];
    for (int i=0; i<n; i++) {
        [alert addButtonWithTitle:[buttons objectAtIndex:i]];
    }
    [alert show];
    return alert;
}
#pragma  alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag){
        case AlertViewTagCheckVersion:
            switch (self.app.role) {
                case AppUpdateRolePrompt:
                    if (buttonIndex==1 && isURL(self.app.appStore)) {
                        [APP openURL:[NSURL URLWithString:self.app.appStore]];
                    }
                    break;
                case AppUpdateRoleUpdate:
                    if (isURL(self.app.appStore)) {
                        [APP openURL:[NSURL URLWithString:self.app.appStore]];
                    }
                    break;
                case AppUpdateRoleForbidden:
                    exit(-1);
                    break;
                    
                default:
                    break;
            }
        case AlertViewCommentApp:
            [BehaviorTracker trackEvent:@"comment_app" group:@"app" element:[NSString stringWithFormat:@"%d", buttonIndex]];
            if (buttonIndex == AlertViewCommentAppGoodIndex) {
                DLOG(@"%@",AppStore);
                [APP openURL:[NSURL URLWithString:AppStore]];
            }
            if (buttonIndex!=3) {
                set_current_app_comment(buttonIndex+1);
            }
            break;
    }
}
@end
