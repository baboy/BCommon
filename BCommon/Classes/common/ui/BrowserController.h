//
//  WebViewController.h
//  iLook
//
//  Created by Zhang Yinghui on 7/6/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XUIViewController.h"

@interface BrowserController : XUIViewController<UIWebViewDelegate> 
@property (nonatomic, retain) NSURL *url;
- (id) initWithUrlString:(NSString *)urlString;
- (id) initWithURL:(NSURL *)url;
- (void) goBack;
- (void) goForward;
- (void) quit;
+ (void) open:(id)url withController:(UIViewController *)viewController;
@end
