//
//  AppBaseViewController.m
//  iShow
//
//  Created by baboy on 13-5-5.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BaseViewController.h"

@implementation AppNavigitionController
- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    DLOG(@"[AppNavigitionController] viewControllers count :%d", [self.viewControllers count]);
    if ([self.viewControllers count] < 1 || !self.rootController) {
        [super pushViewController:viewController animated:animated];
        return;
    }
    //
    if ([self.rootController respondsToSelector:@selector(pushViewController:animated:)]) {
        DLOG(@"[AppNavigitionController] pushViewController");
        AppNavigitionController *nav = (id)viewController;
        if (![viewController isKindOfClass:[UINavigationController class]]) {
            AppNavigitionController *nav = AUTORELEASE([[AppNavigitionController alloc] initWithRootViewController:viewController]);
            nav.rootController = self.rootController;
            
        }else{
            viewController = [nav.viewControllers lastObject];
        }
        
        viewController.navigationItem.leftBarButtonItem = createBarButtonItem(@"Back",  viewController, @selector(popViewControllerAnimated:));
        [self.rootController pushViewController:nav animated:animated];
        
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if ([self.viewControllers count] < 1 || !self.rootController) {
        return [super popViewControllerAnimated:animated];
    }
    if ([self.rootController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.rootController popViewControllerAnimated:animated];
    }
    return [self.viewControllers lastObject];
}
@end

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)shareWithContent:(NSString *)content withImagePath:(NSString *)imagePath{
    SharePlatformView *sharePlatformView = [SharePlatformView sharePlatformView];
    [sharePlatformView setAutoShare:YES];
    [sharePlatformView setShareContent:content];
    [sharePlatformView setShareImagePath:imagePath];
    [sharePlatformView show];
}
- (void)commentWithPlaceholders:(NSString *)placeholders{
    ShareView *shareView = [ShareView shareView];
    [shareView setTitle:NSLocalizedString(@"评论", nil)];
    [shareView setDelegate:self];
    [shareView setShareViewType:ShareViewTypeComment];
    [shareView show];
}

@end