//
//  AppBaseDelegate.m
//  iVideo
//
//  Created by baboy on 6/20/14.
//  Copyright (c) 2014 baboy. All rights reserved.
//

#import "AppBaseDelegate.h"

@implementation AppBaseDelegate
- (void)registerNotify{
    if (DeviceToken) {
        return;
    }
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
}
//获取设备号
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [[token description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [DBCache setValue:token forKey:@"device_token"];
    [ApplicationVersion registerNotificationDeviceToken:token
                                               callback:^(BHttpRequestOperation *operation, NSDictionary *json, NSError *error) {
                                                   DLOG(@"token:%@",json);
                                               }];
    DLOG(@"%@", token);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    DLOG(@"");
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAppWillResignActive object:self userInfo:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLOG(@"");
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAppDidEnterBackground object:self userInfo:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLOG(@"");
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAppWillEnterBackground object:self userInfo:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLOG(@"");
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAppDidBecomeActive object:self userInfo:nil];
}


- (UIAlertView*)alertWithTitle:(NSString *)title message:(NSString *)msg button:(NSString *)buttonTitle,...{
    if (!msg) {
        return nil;
    }
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
    if ([buttons count] == 0) {
        [buttons addObject:NSLocalizedString(@"确定", @"alert")];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:msg
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil];
    int n = [buttons count];
    for (int i=0; i<n; i++) {
        [alert addButtonWithTitle:[buttons objectAtIndex:i]];
    }
    [alert show];
    return alert;
}
#pragma -mark alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
}
@end
