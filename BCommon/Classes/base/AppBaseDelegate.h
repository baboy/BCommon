//
//  AppBaseDelegate.h
//  iVideo
//
//  Created by baboy on 6/20/14.
//  Copyright (c) 2014 baboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppBaseDelegate : UIResponder
- (void)registerNotify;
- (UIAlertView*)alertWithTitle:(NSString *)title message:(NSString *)msg button:(NSString *)buttonTitle,...;
@end
