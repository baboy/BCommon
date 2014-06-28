//
//  Application.h
//  iVideo
//
//  Created by tvie on 13-10-14.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>
enum {
    AppUpdateRoleNormal,
    AppUpdateRoleMsg=9,
    AppUpdateRolePrompt,
    AppUpdateRoleUpdate,
    AppUpdateRoleForbidden
};
typedef NSInteger AppUpdateRole;

@interface Application : NSObject

@property (nonatomic, retain) NSString *appName;
@property (nonatomic, retain) NSString *appSummary;
@property (nonatomic, retain) NSString *appContent;
@property (nonatomic, retain) NSString *appScrore;
@property (nonatomic, retain) NSString *appLink;
@property (nonatomic, retain) NSString *appDownloadUrl;
@property (nonatomic, retain) NSString *appIcon;
@property (nonatomic, retain) NSString *version;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (NSArray *)appsFromArray:(NSArray *)array;

//获取应用推荐列表
+ (BHttpRequestOperation *)getAppListCallback:(void(^)(BHttpRequestOperation *operation, NSArray *response, NSError *error))callback;


//获取关于
+ (BHttpRequestOperation *)getAppAboutCallback:(void(^)(BHttpRequestOperation *operation,id response,NSError *error))callback;

+ (BHttpRequestOperation *)getAppAboutWithOutput:(NSString *)output callback:(void(^)(BHttpRequestOperation *operation,id response,NSError *error))callback;
//意见反馈
+ (BHttpRequestOperation *)feedback:(NSString *)content callback:(void (^)(id operation,id response, NSError *error))callback;
@end

@interface ApplicationVersion : NSObject
@property (nonatomic, assign) int role;
@property (nonatomic, strong) NSString *appStore;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *version;
- (id)initWithDictionary:(NSDictionary *)dict;

//检测版本更新
+ (BHttpRequestOperation *)getAppVersionCallback:(void(^)(BHttpRequestOperation *operation, ApplicationVersion *app, NSError *error))callback;

+ (BHttpRequestOperation *)registerNotificationDeviceToken:(NSString *)token callback:(void(^)(BHttpRequestOperation *operation, NSDictionary *json, NSError *error))callback;


@end
