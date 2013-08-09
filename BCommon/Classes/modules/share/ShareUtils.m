//
//  ShareUtils.m
//  iShow
//
//  Created by baboy on 13-6-4.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "ShareUtils.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WBApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "SharePlatformViewDelegate.h"

NSString *ShatePlatformSinaWeibo    = @"SinaWeibo";
NSString *ShatePlatformSohuWeibo    = @"SohuWeibo";
NSString *ShatePlatformTencentWeibo = @"TencentWeibo";
NSString *ShatePlatformQZone        = @"QZone";
NSString *ShatePlatformDouban       = @"Douban";
NSString *ShatePlatformRenRen       = @"RenRen";
NSString *ShatePlatformWeChat       = @"WeChat";
NSString *ShatePlatformQQ           = @"QQ";

@implementation SharePlatform

- (void)dealloc{
    RELEASE(_name);
    RELEASE(_platformId);
    RELEASE(_icon);
    RELEASE(_appId);
    RELEASE(_appKey);
    RELEASE(_appSecret);
    RELEASE(_redirectUri);
    [super dealloc];
}
- (id) initWithDictionary:(NSDictionary*)dict{
    if(self = [super init]){
        [self setName:nullToNil([dict valueForKey:@"name"])];
        [self setPlatformId:nullToNil([dict valueForKey:@"platformId"])];
        if (!self.platformId) {
            [self setPlatformId:nullToNil([dict valueForKey:@"id"])];
        }
        NSString *iconName = [dict valueForKey:@"icon"];
        if (iconName) {
            NSString *iconPath = getBundleFileFromBundle(iconName, @"png", @"Resource", @"Icon");
            [self setIcon:iconPath];
        }
        [self setCanBind:[nullToNil([dict valueForKey:@"canBind"]) boolValue]];
        [self setAppId:nullToNil([dict valueForKey:@"appId"])];
        [self setAppKey:nullToNil([dict valueForKey:@"appKey"])];
        [self setAppSecret:nullToNil([dict valueForKey:@"appSecret"])];
        [self setRedirectUri:nullToNil([dict valueForKey:@"redirectUri"])];
        [self setLogin:[[dict valueForKey:@"login"] boolValue]];
        [self setShareType:[[dict valueForKey:@"shareType"] intValue]];
        
        
    }
    return self;
}
- (BOOL) hasAuthorized{
    return [ShareUtils hasAuthorizedWithPlatform:self];
}
- (BOOL) cancelAuth{
    return [ShareUtils cancelAuthWithPlatform:self];
}
- (NSDictionary *) dict{
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:7];
    if(self.name)
        [d setValue:self.name forKey:@"name"];
    if(self.platformId)
        [d setValue:self.platformId forKey:@"platformId"];
    if(self.icon)
        [d setValue:self.icon forKey:@"icon"];
    if(self.appId)
        [d setValue:self.appId forKey:@"appId"];
    if(self.appKey)
        [d setValue:self.appKey forKey:@"appKey"];
    if(self.appSecret)
        [d setValue:self.appSecret forKey:@"appSecret"];
    if(self.redirectUri)
        [d setValue:self.redirectUri forKey:@"redirectUri"];
    [d setValue:[NSNumber numberWithBool:self.login] forKey:@"login"];
    [d setValue:[NSNumber numberWithBool:self.canBind] forKey:@"canBind"];
    [d setValue:[NSNumber numberWithInt:self.shareType] forKey:@"shareType"];
    return d;
}

@end

@implementation ShareUtils
+ (SharePlatform *)confForApp:(NSString *)appid withConfigs:(NSArray *)confs{
    NSString *_id = [appid lowercaseString];
    for (SharePlatform *d in confs) {
        if ([[d.platformId lowercaseString] isEqualToString:_id]) {
            return d;
        }
    }
    return nil;
}
+ (NSArray *)platforms{
    NSArray *confs = [NSArray arrayWithContentsOfFile:getBundleFile(@"share_platform.plist")];
    int n = [confs count];
    NSMutableArray *platforms = [NSMutableArray arrayWithCapacity:n];
    for (int i = 0; i < n; i++) {
        NSDictionary *conf = [confs objectAtIndex:i];
        SharePlatform *platform = [[SharePlatform alloc] initWithDictionary:conf];
        [platforms addObject:platform];
    }
    return platforms;
}
+ (NSArray *)bindPlatforms{
    NSMutableArray *bindPlatforms = [NSMutableArray arrayWithCapacity:5];
    NSArray *platforms = [self platforms];
    for (int i=0, n = [platforms count]; i<n; i++) {
        SharePlatform *platform = [platforms objectAtIndex:i];
        if (platform.canBind) {
            [bindPlatforms addObject:platform];
        }
    }
    return bindPlatforms;
}
+ (void) setupWithKey:(NSString *)key{
    [ShareSDK registerApp:key];
    //添加新浪微博应用
    NSArray *platforms = [self platforms];
    SharePlatform *platform = [self confForApp:ShatePlatformSinaWeibo withConfigs:platforms];
    if (platform)
        [ShareSDK connectSinaWeiboWithAppKey:platform.appKey
                                   appSecret:platform.appSecret
                                 redirectUri:platform.redirectUri];
    
    //添加腾讯微博应用
    platform = [self confForApp:ShatePlatformTencentWeibo withConfigs:platforms];
    if (platform)
        [ShareSDK connectTencentWeiboWithAppKey:platform.appKey
                                      appSecret:platform.appSecret
                                    redirectUri:platform.redirectUri
                                       wbApiCls:[WBApi class]];
    
    //添加QQ空间应用
    platform = [self confForApp:ShatePlatformQZone withConfigs:platforms];
    if (platform)
        [ShareSDK connectQZoneWithAppKey:platform.appKey
                               appSecret:platform.appSecret
                       qqApiInterfaceCls:[QQApiInterface class]
                         tencentOAuthCls:[TencentOAuth class]];
    
    //添加搜狐微博应用
    platform = [self confForApp:ShatePlatformSohuWeibo withConfigs:platforms];
    if (platform)
        [ShareSDK connectSohuWeiboWithConsumerKey:platform.appKey
                                   consumerSecret:platform.appSecret
                                      redirectUri:platform.redirectUri];
    
    //添加豆瓣应用
    platform = [self confForApp:ShatePlatformDouban withConfigs:platforms];
    if (platform)
        [ShareSDK connectDoubanWithAppKey:platform.appKey
                                appSecret:platform.appSecret
                              redirectUri:platform.redirectUri];
    
    //添加人人网应用
    platform = [self confForApp:ShatePlatformRenRen withConfigs:platforms];
    if (platform)
        [ShareSDK connectRenRenWithAppKey:platform.appKey
                                appSecret:platform.appSecret];
    
    //添加微信应用
    platform = [self confForApp:ShatePlatformWeChat withConfigs:platforms];
    if (platform)
        [ShareSDK connectWeChatWithAppId:platform.appId
                               wechatCls:[WXApi class]];
    //添加QQ应用
    platform = [self confForApp:ShatePlatformQQ withConfigs:platforms];
    if (platform)
        [ShareSDK connectQQWithAppId:platform.appId qqApiCls:[QQApi class]];
    
    /*
     
     //添加Facebook应用
     [ShareSDK connectFacebookWithAppKey:@"107704292745179"
     appSecret:@"38053202e1a5fe26c80c753071f0b573"];
     
     //添加Twitter应用
     [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
     consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
     redirectUri:@"http://www.sharesdk.cn"];
     */
}
+ (ShareType)shareTypeForPlatform:(NSString *)platformId{
    NSString *pid = [platformId lowercaseString];
    ShareType shareType = 0;
    //新浪登录
    if ([pid isEqualToString:[ShatePlatformSinaWeibo lowercaseString]]) {
        shareType = ShareTypeSinaWeibo;
    }
    //QQ登录
    else if ([pid isEqualToString:[ShatePlatformQQ lowercaseString]]) {
        shareType = ShareTypeQQ;
    }
    //人人登录
    else if ([pid isEqualToString:[ShatePlatformRenRen lowercaseString]]) {
        shareType = ShareTypeRenren;
    }
    //豆瓣登录
    else if ([pid isEqualToString:[ShatePlatformDouban lowercaseString]]) {
        shareType = ShareTypeDouBan;
    }
    return shareType;
}
+ (void)loginWithPlatform:(SharePlatform *)platform callback:(void (^)(id user, NSError *error))callback{
    SharePlatformViewDelegate *viewDelegate = [SharePlatformViewDelegate defaultDelegate];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:viewDelegate
                                               authManagerViewDelegate:viewDelegate];
    
    //在授权页面中添加关注官方微博
    
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"张斯特罗"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"张斯特罗"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    [ShareSDK getUserInfoWithType:platform.shareType
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                               NSError *err = nil;
                               if (error) {
                                   err = [NSError errorWithDomain:@"Login error" code:[error errorCode] userInfo:[NSDictionary dictionaryWithObject:[error errorDescription] forKey:NSLocalizedDescriptionKey]];
                               }
                               BUser *user = nil;
                               if(result && userInfo){
                                   user = AUTORELEASE([[BUser alloc] init]);
                                   user.uid = userInfo.uid;
                                   user.name = userInfo.nickname;
                                   user.avatar = userInfo.icon;
                                   user.birthday = userInfo.birthday;
                                   user.gender = userInfo.gender;
                                   user.age = userInfo.age;
                                   user.mobile = userInfo.mobile;
                                   user.education = userInfo.education;
                                   user.school = userInfo.school;
                                   NSMutableDictionary *meta = [NSMutableDictionary dictionaryWithDictionary:[userInfo sourceData]];
                                   user.metadata = meta;
                                   
                               }
                               if(callback){
                                   callback(user, err);
                               }
                           }];
}
+ (BOOL) hasAuthorizedWithPlatform:(SharePlatform *)platform{
    return [ShareSDK hasAuthorizedWithType:platform.shareType];
}
+ (BOOL) cancelAuthWithPlatform:(SharePlatform *)platform{
    [ShareSDK cancelAuthWithType:platform.shareType];
    return YES;
}
+ (void) shareOnPlatform:(NSArray *)platforms withContent:(NSString *)content withImagePath:(NSString *)imagePath callback:(void (^)(NSError *error))callback{
    DLOG(@"share Image:%@", [UIImage imageWithContentsOfFile:imagePath]);
    id shareContent = [ShareSDK content:content
                         defaultContent:nil
                                  image:[ShareSDK imageWithPath:imagePath]
                                  title:nil
                                    url:nil
                            description:nil
                              mediaType:SSPublishContentMediaTypeText];
    NSMutableArray *shareList = [NSMutableArray arrayWithCapacity:3];
    for (SharePlatform *platform in platforms) {
        [shareList addObject:[NSNumber numberWithInt:platform.shareType]];
    }
    [ShareSDK oneKeyShareContent:shareContent
                       shareList:shareList
                     authOptions:nil
                   statusBarTips:YES
                          result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                              if ((state != SSPublishContentStateSuccess) && (state != SSPublishContentStateFail)) {
                                  return ;
                              }
                              NSError *err = nil;
                              if (state == SSPublishContentStateFail){
                                  err = [NSError errorWithDomain:@"Login error" code:[error errorCode] userInfo:[NSDictionary dictionaryWithObject:[error errorDescription] forKey:NSLocalizedDescriptionKey]];
                              }
                              if(callback){
                                  callback(err);
                              }
                          }];
}
@end
