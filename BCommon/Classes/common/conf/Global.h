//
//  G.h
//  iLook
//
//  Created by Zhang Yinghui on 5/27/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define gConf			@"http://m.tvie.com.cn/mcms/api2/config.php"
#define LT_DEPRECATED() __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA, __MAC_NA, __IPHONE_5_0, __IPHONE_6_0)

#define APP                 [UIApplication sharedApplication]
#define APPDelegate         [[UIApplication sharedApplication] delegate]
#define APPRootController  (id)[(id)[[UIApplication sharedApplication] delegate] rootViewController]
#define AppKeyWindow        [[UIApplication sharedApplication] keyWindow]


#define REQUEST_BATCH_NUM   10

#define AppModNews          @"news"
#define AppModVod           @"vod"
#define AppModLive          @"live"
#define AppModReport        @"report"
///////
#define DLOG(...)  NSLog(@"[DEBUG][%s] - [line:%d] %@",__func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);

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

#define DeviceID                [OpenUDID value]
#define DeviceToken             [DBCache valueForKey:@"deviceToken"]

//notify
#define NotifyLogout    @"NotifyUserLogout"
#define NotifyLogin    @"NotifyUserLogin"

#define SystemVolumeChangeNotify @"AVSystemController_SystemVolumeDidChangeNotification"

#define SystemAudioVolumeNotifyParameter @"AVSystemController_AudioVolumeNotificationParameter"

// AppDelegate notify
#define NotificationAppWillResignActive     @"AppWillResignActive"
#define NotificationAppDidEnterBackground   @"AppDidEnterBackground"
#define NotificationAppWillEnterBackground  @"AppWillEnterBackground"
#define NotificationAppDidBecomeActive      @"AppDidBecomeActive"

@interface G : NSObject {

}
+ (id) valueForKey:(id)key;
+ (void) setValue:(id)val forKey:(id)key;
+ (id)remove:(id)key;
+ (NSDictionary *) dict;
@end



