//
//  AppBaseViewController.h
//  iShow
//
//  Created by baboy on 13-5-5.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "XUIViewController.h"
/*
@interface AppNavigitionController : XUINavigationController
@property (nonatomic, assign) id rootController;
@end
*/
@interface BaseViewController : XUIViewController
@property (nonatomic, assign) BOOL canPullBack;
- (NSArray *)getInputCheckConfig;
- (BOOL)checkInput;
- (BOOL)checkInput:(NSArray *)config;
+ (void)showNetConnectMessage;

- (void)commentApp;
- (void)checkAppViersion;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
