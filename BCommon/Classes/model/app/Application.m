//
//  Application.m
//  iVideo
//
//  Created by tvie on 13-10-14.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "Application.h"
#import "Group.h"

@implementation Application
- (void)dealloc{
    [super dealloc];
    
    RELEASE(_appName);
    RELEASE(_appSummary);
    RELEASE(_appContent);
    RELEASE(_appScrore);
    RELEASE(_appLink);
    RELEASE(_appDownloadUrl);
    RELEASE(_appIcon);
    RELEASE(_version);
}
- (id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.appContent = nullToNil([dic objectForKey:@"content"]);
        self.appDownloadUrl = nullToNil([dic objectForKey:@"download_url"]);
        self.appIcon = nullToNil([dic objectForKey:@"icon"]);
        self.appLink = nullToNil([dic objectForKey:@"link"]);
        if (!self.appLink) {
            self.appDownloadUrl = nullToNil([dic objectForKey:@"appStore"]);
        }
        self.appName = nullToNil([dic objectForKey:@"name"]);
        self.appScrore = nullToNil([dic objectForKey:@"score"]);
        self.version = nullToNil([[dic objectForKey:@"version"] description]);
        self.appSummary = nullToNil([dic objectForKey:@"summary"]);
    }
    return self;
}
+ (NSArray *)appsFromArray:(NSArray *)array{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0, n = [array count]; i < n; i++) {
        Application *app = AUTORELEASE([[Application alloc] initWithDictionary:[array objectAtIndex:i]]);
        [list addObject:app];
    }
    return list;
}

#pragma mark -- 请求应用列表
+ (BHttpRequestOperation *)getAppListCallback:(void(^)(BHttpRequestOperation *operation, NSArray *response, NSError *error))callback{
    
    
    BHttpClient *client = [BHttpClient defaultClient];
    id param = DeviceParam;
    
    NSURLRequest *request = [client requestWithGetURL:[NSURL URLWithString:ApiQueryAppList] parameters:param];
    BHttpRequestOperation *operation = [client jsonRequestWithURLRequest:request success:^(BHttpRequestOperation *operation, id json) {
        DLOG(@"json = %@",json);
        NSError *error = nil;
        NSArray *groups = nil;
        
        BResponse *response = [BResponse responseWithDictionary:json];
        if ([response isSuccess]) {
            groups = [Group groupsFromArray:[response data]];
            for (Group *group in groups) {
                group.data = [Application appsFromArray:group.data];
            }
        }else{
            error = response.error;
        }
        if (callback) {
            callback(operation,groups,error);
        }
    } failure:^(BHttpRequestOperation *operation, NSError *error) {
        DLOG(@"fail:%@",error);
        if (callback) {
            callback(operation, nil, error);
        }
    }];
    
    [operation setRequestCache:[BHttpRequestCache defaultCache]];
    [client enqueueHTTPRequestOperation:operation];
    return operation;
}


#pragma mark -- 获取关于
+ (BHttpRequestOperation *)getAppAboutCallback:(void(^)(BHttpRequestOperation *operation,id response,NSError *error))callback{
    return [self getAppAboutWithOutput:@"json" callback:callback];
}

+ (BHttpRequestOperation *)getAppAboutWithOutput:(NSString *)output callback:(void(^)(BHttpRequestOperation *operation,id response,NSError *error))callback{
    output = output ?:@"html";
    BHttpClient *client = [BHttpClient defaultClient];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:DeviceParam];
    [param setValue:output forKey:@"output"];
    
    NSURLRequest *request = [client requestWithGetURL:[NSURL URLWithString:ApiQueryAbout] parameters:param];
    BHttpRequestOperation *operation =
    [client dataRequestWithURLRequest:request
                              success:^(BHttpRequestOperation *operation, id data) {
                                  id ret = nil;
                                  id error = nil;
                                  if ([output isEqualToString:@"json"]) {
                                      id json = [data json];
                                      if (json) {
                                          BResponse *res = [BResponse responseWithDictionary:json];
                                          if ([res isSuccess]) {
                                              ret = [res data];
                                          }else{
                                              error = [res error];
                                          }
                                      }
                                  }else{
                                      ret = data;
                                  }
                                  if (callback) {
                                      callback(operation, ret, error);
                                  }
                              }
                              failure:^(BHttpRequestOperation *operation, NSError *error) {
                                  DLOG(@"fail = %@",error);
                                  if (callback) {
                                      callback(operation, nil, error);
                                  }
                              }];
    
    [operation setRequestCache:[BHttpRequestCache defaultCache]];
    [client enqueueHTTPRequestOperation:operation];
    return operation;
}

+ (BHttpRequestOperation *)feedback:(NSString *)content callback:(void (^)(id operation,id response, NSError *error))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:DeviceParam];
    [param setValue:content forKey:@"content"];
    [param setValue:APPID forKey:@"appid"];
    
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithPostURL:[NSURL URLWithString:ApiPostFeedback] parameters:param];
    BHttpRequestOperation *operation = [client jsonRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id json) {
                                                                     BResponse *response = [BResponse responseWithDictionary:json];
                                                                     if ([response isSuccess]) {
                                                                         if (callback) {
                                                                             callback(operation, response, response.error);
                                                                         }
                                                                     } else {
                                                                         if (callback) {
                                                                             callback(operation, nil, response.error);
                                                                         }
                                                                     }
                                                                 }
                                                                 failure:^(BHttpRequestOperation *operation, NSError *error) {
                                                                     DLOG(@"%@", error);
                                                                     if (callback) {
                                                                         callback(operation, nil, error);
                                                                     }
                                                                 }];
    [operation setRequestCache:[BHttpRequestCache defaultCache]];
    [client enqueueHTTPRequestOperation:operation];
    return operation;
}
@end

@implementation ApplicationVersion
- (id)initWithDictionary:(NSDictionary *)dict{
    
    if (self = [super init]) {
        self.role = [nullToNil([dict objectForKey:@"role"]) intValue];
        self.version = nullToNil([[dict objectForKey:@"version"] description]);
        self.appStore = nullToNil([dict objectForKey:@"appStore"]);
        if (!isURL(self.appStore)) {
            self.appStore = nullToNil([dict objectForKey:@"download_url"]);
        }
        if (!isURL(self.appStore)) {
            self.appStore = nullToNil([dict objectForKey:@"link"]);
        }
        self.msg = nullToNil([dict objectForKey:@"msg"]);
    }
    return self;
}
#pragma mark -- 检测版本
+ (BHttpRequestOperation *)getAppVersionCallback:(void(^)(BHttpRequestOperation *operation, ApplicationVersion* app,NSError *error))callback{
    
    
    BHttpClient *client = [BHttpClient defaultClient];
    
    id param = DeviceParam;
    NSURLRequest *request = [client requestWithGetURL:[NSURL URLWithString:ApiQueryAppVersion] parameters:param];
    BHttpRequestOperation *operation = [client jsonRequestWithURLRequest:request success:^(BHttpRequestOperation *operation, id json) {
        DLOG(@"json = %@",json);
        NSError *error = nil;
        ApplicationVersion *app = nil;
        int role = 0;
        BResponse *respone = [BResponse responseWithDictionary:json];
        if ([respone isSuccess]) {
            app = [[ApplicationVersion alloc] initWithDictionary:respone.data];
        }else {
            error = respone.error;
            role = [[respone.data valueForKey:@"role"] intValue];
        }
        
        if (callback) {
            callback(operation,app,error);
        }
        
    } failure:^(BHttpRequestOperation *operation, NSError *error) {
        DLOG(@"fail = %@",error);
        if (callback) {
            callback(operation,nil,error);
        }
    }];
    
    [operation setRequestCache:[BHttpRequestCache defaultCache]];
    [client enqueueHTTPRequestOperation:operation];
    return operation;
}

+ (BHttpRequestOperation *)registerNotificationDeviceToken:(NSString *)token callback:(void(^)(BHttpRequestOperation *operation, NSDictionary *json, NSError *error))callback{
    BHttpClient *client = [BHttpClient defaultClient];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:DeviceParam];
    [param setValue:token forKey:@"token"];
    NSURLRequest *request = [client requestWithPostURL:[NSURL URLWithString:ApiRegisterDeviceToken] parameters:param];
    BHttpRequestOperation *operation = [client jsonRequestWithURLRequest:request success:^(BHttpRequestOperation *operation, id json) {
        BResponse *respone = [BResponse responseWithDictionary:json];
        if (callback) {
            callback(operation, [respone data], [respone error]);
        }
        
    } failure:^(BHttpRequestOperation *operation, NSError *error) {
        DLOG(@"fail = %@",error);
        if (callback) {
            callback(operation,nil,error);
        }
    }];
    
    [operation setRequestCache:[BHttpRequestCache defaultCache]];
    [client enqueueHTTPRequestOperation:operation];
    return operation;
}
@end
