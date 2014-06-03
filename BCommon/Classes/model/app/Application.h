//
//  Application.h
//  iVideo
//
//  Created by tvie on 13-10-14.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHttpClient.h"
enum {
    AppUpdateRoleNormal,
    AppUpdateRoleMsg=9,
    AppUpdateRolePrompt,
    AppUpdateRoleUpdate,
    AppUpdateRoleForbidden
};
typedef NSInteger AppUpdateRole;

@interface Application : NSObject

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appSummary;
@property (nonatomic, strong) NSString *appContent;
@property (nonatomic, strong) NSString *appScrore;
@property (nonatomic, strong) NSString *appLink;
@property (nonatomic, strong) NSString *appDownloadUrl;
@property (nonatomic, strong) NSString *appIcon;
@property (nonatomic, strong) NSString *version;

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

@end
