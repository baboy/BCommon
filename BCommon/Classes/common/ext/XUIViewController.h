//
//  UIViewController+itv.h
//  itv
//
//  Created by Zhang Yinghui on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDropMenu.h"
#import "BDropTitleView.h"
#import "AFHTTPClient.h"

enum{
    AlertViewTagAlert,
    AlertViewTagError,
};
@interface UIViewController (itv)

@end
@interface XUINavigationController:UINavigationController
- (void)setNavBgColor:(UIColor *)color;
@end

@interface XUIViewController : UIViewController<UIAlertViewDelegate,BDropMenuDelegate>{
	CGRect _frame;
}
@property (nonatomic, retain) BDropMenu *topDropMenu;
- (void)setTitle:(NSString *)title withImageURL:(NSURL *)imageURL;
- (void)setDropMenuTitle:(NSString *)title;
- (void)showDropMenu:(id)sender;
- (void)addBackButton;
- (void)reset;
-(id)loadViewFromNibNamed:(NSString*)nibName;
- (BOOL)shouldPopViewController:(UIViewController *)controller;
- (IBAction)popViewController:(id)sender;
- (void)showMessage:(NSString *)msg;
- (void)showMessageAndFadeOut:(NSString *)msg;
- (void)fadeOut;
- (void)fadeOutAfterDelay:(float)t;
- (void)setHttpRequest:(id)request forKey:(NSString *)key;
- (UIAlertView*)alert:(NSString *)msg;
- (UIAlertView*)alert:(NSString *)msg button:(NSString *)buttonTitle,...;
@end
