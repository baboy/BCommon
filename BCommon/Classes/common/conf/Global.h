//
//  G.h
//  iLook
//
//  Created by Zhang Yinghui on 5/27/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GUI.h"
#import "GString.h"

#define gConf			@"http://m.tvie.com.cn/mcms/api2/config.php"

#define APP                 [UIApplication sharedApplication]
#define APPDelegate         [[UIApplication sharedApplication] delegate]
#define APPRootController  (id)[(id)[[UIApplication sharedApplication] delegate] rootViewController]
#define AppKeyWindow        [[UIApplication sharedApplication] keyWindow]
#define AppModNews          @"news"
#define AppModVod           @"video"
#define AppModLive          @"live"
#define AppModReport        @"report"
///////
#define DLOG(...)  NSLog(@"[DEBUG] %@",[NSString stringWithFormat:__VA_ARGS__]);

#define DISPATCH_RELEASE(__OBJ__)   if(__OBJ__) { dispatch_release(__OBJ__); __OBJ__ = NULL; }
#define RELEASE(__POINTER)  [__POINTER release]; __POINTER = nil;
#define RETAIN(__POINTER)  [__POINTER retain];
#define AUTORELEASE(__POINTER)  [__POINTER autorelease]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define G_LOGIN_TIME					@"loginTime"
#define G_APP_MAP_FILE					@"appmap.plist"

#define gVideoExpireTime            3600
#define MinM3u8SliceDuration        10

#define CacheSchemeName                 @"cache-image"

// app icon 参数
#define gAppIconWidth				80
#define gAppIconHeight				80
#define gAppIconTitleHeight			20
#define gAppIconPadding				10

#define gDateTimeFormat             @"EEE, d LLL, yyyy"
#define gTablePicWidth        80
#define gTablePicHeight       80
#define gTablePicBorderColor       [UIColor whiteColor]
#define gTablePicShadowColor        [UIColor colorWithWhite:0 alpha:0.6]

#define gImageCacheDir              @"cache_image"


#define DaySec                      3600*24
#define HourSec                        3600
//全局配置文件


#define gButtonFont                 [UIFont boldSystemFontOfSize:16.0]
#define gButtonTitleShadowColor     [UIColor colorWithWhite:0 alpha:0.5]
#define gButtonTitleColor           [UIColor colorWithWhite:1 alpha:1]

#define gImageSet                   [NSSet setWithObjects:@"gif", @"jpg", @"jpeg", @"bmp", @"png", nil]

#define BundleID [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleIdentifier"]
#define BundleVersion ([[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]?[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"])

#define AppURLTypes  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleURLTypes"]
#define AppURLSchemes [AppURLTypes count]?[[AppURLTypes objectAtIndex:0] valueForKey:@"CFBundleURLSchemes"]:nil
#define AppURLScheme [AppURLSchemes count]?[AppURLSchemes objectAtIndex:0]:nil

#define ShareEmailTitlePrefix     NSLocalizedString(@"Share via Lavatech",nil)
#define ShareEmailContentPrefix  NSLocalizedString(@"Share via iLookForiPhone",nil)
#define ShareContentPostfix  NSLocalizedString(@"via iLookForiPhone", nil)

#define AppLink  @"http://www.tvie.com.cn"

//定义appkey & appsecret
#define SinaWeiboCallback       @"http://m.tvie.com.cn/mcms/api2/mod/sns/callback.php"
#define SinaWeiboAppKey         @"3462974483"
#define SinaWeiboAppSecret      @"a122cf4a45dc4e1e1fbd3da3d822ac49"
#define QQWeiboAppKey           @"801261473"
#define QQWeiboAppSecret        @"f65e9368eb3038f255eac21efce99980"
#define RenrenWeiboAppId        @"217106"
#define RenrenWeiboAppKey       @"2bfa00bfed014943acdfc26a5af1332c"
#define RenrenWeiboAppSecret    @"4571a4799f634b2798e9a5e310ae0710"

#define DeviceID                [OpenUDID value]
#define DeviceToken             [DBCache valueForKey:@"deviceToken"]
//notify
#define NotifyLogout    @"NotifyLogout"
#define NotifyLogin    @"NotifyLogin"
@interface G : NSObject {

}
+ (id) valueForKey:(id)key;
+ (void) setValue:(id)val forKey:(id)key;
+ (id)remove:(id)key;
+ (NSDictionary *) dict;
@end
