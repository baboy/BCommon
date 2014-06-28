//
//  RootViewController.h
//  iShow
//
//  Created by baboy on 13-3-17.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "IIViewDeckController.h"

@interface SlidingRootViewController : IIViewDeckController<IIViewDeckControllerDelegate>


+ (void)showNetConnectMessage;
- (void)checkAppViersion;
- (void)commentApp;
- (UIAlertView*)alertWithTitle:(NSString *)title message:(NSString *)msg button:(NSString *)buttonTitle,...;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end