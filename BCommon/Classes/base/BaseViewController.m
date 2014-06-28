//
//  AppBaseViewController.m
//  iShow
//
//  Created by baboy on 13-5-5.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BaseViewController.h"

#define AlertViewTagCheckVersion     11
#define AlertViewCommentApp 20
#define AlertViewCommentAppGoodIndex    2

@interface BaseViewController ()
@property (nonatomic, retain) ApplicationVersion *app;
@end

@implementation BaseViewController
- (void)dealloc{
    [super dealloc];
    RELEASE(_app);
}
- (NSArray *)getInputCheckConfig{
    return nil;
}
- (BOOL)checkInput{
    return [self checkInput:[self getInputCheckConfig]];
}
- (BOOL)checkInput:(NSArray *)config{
    
    NSArray* confs = config;
    for (NSDictionary *conf in confs) {
        UITextField *field = [conf valueForKey:@"field"];
        NSString *name = [conf valueForKey:@"name"];
        int minLen = [[conf valueForKey:@"min-len"] intValue];
        int maxLen = [[conf valueForKey:@"max-len"] intValue];
        NSString *regex = [conf valueForKey:@"regex"];
        NSString *regex_desc = [conf valueForKey:@"regex-desc"];
        NSString *val = [field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *errMsg = nil;
        if (regex && ![val testRegex:regex]) {
            errMsg = [NSString stringWithFormat:@"%@格式错误", name];
            if (regex_desc) {
                errMsg = [NSString stringWithFormat:@"%@,%@",errMsg, regex_desc];
            }
        }else if ([val length] == 0) {
            errMsg = [NSString stringWithFormat:@"%@不能为空",name];
        }else if ([val length] < minLen) {
            errMsg = [NSString stringWithFormat:@"%@长度不能小于%d位",name,minLen];
        }else if ( maxLen > 0 && [val length]>maxLen ){
            errMsg = [NSString stringWithFormat:@"%@长度不能大于%d位",name,maxLen];
        }
        if (errMsg) {
            [self alert:errMsg];
            [field becomeFirstResponder];
            return NO;
        }
    }
    return YES;
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
