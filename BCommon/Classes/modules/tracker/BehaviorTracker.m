//
//  BehaviorTracker.m
//  iVideo
//
//  Created by baboy on 13-11-5.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BehaviorTracker.h"
#define LogApiRegisterDevice    @"http://app.tvie.com.cn/log/"
#define LogApiPostEvent         @"http://app.tvie.com.cn/log/"

#define LOG_SDK_VERSION         @"1.0"

static NSString *DeviceSNO = nil;
static NSString *LogAppKey = @"";
static NSString *LogSessionID = nil;

@implementation BehaviorTracker

+ (void)initialize{
    NSString *sessionID = [NSString stringWithFormat:@"%@%d",[[NSDate date] format:@"yyyyMMddhhmmss"], 10000+(int)(arc4random()%9999)];
    LogSessionID = RETAIN(sessionID);
}
+ (void)setAppKey:(NSString *)appKey{
    LogAppKey = RETAIN(appKey);
}
+(NSString *)appKey{
    return LogAppKey;
}
+ (BHttpRequestOperation *)postWithUrl:(NSString *)url params:(NSDictionary *)params callback:(void(^)(BHttpRequestOperation *operation, id response, NSError *error))callback{
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithPostURL:[NSURL URLWithString:url] parameters:params];
    id operation =
    [client jsonRequestWithURLRequest:request
                              success:^(BHttpRequestOperation *operation, id json) {
                                  if (callback) {
                                      callback(operation, json,nil);
                                  }
                              }
                              failure:^(BHttpRequestOperation *operation, NSError *error) {
                                  if (callback) {
                                      callback(operation, nil,error);
                                  }
                                  
                              }];
    [client enqueueHTTPRequestOperation:operation];
    return operation;
}
+ (NSMutableDictionary *)deviceParam{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:DeviceParam];
    [param setValue:[MacAddress currentAddress] forKeyPath:@"mac"];
    [param setValue:[NetChecker access] forKeyPath:@"access"];
    [param setValue:[self appKey] forKeyPath:@"appkey"];
    [param setValue:LOG_SDK_VERSION forKeyPath:@"sdk_version"];
    if (DeviceSNO) {
        [param setValue:[self appKey] forKeyPath:@"appkey"];
    }
    return param;
    
}
+ (void)startSession{
    [self postWithUrl:LogApiRegisterDevice
               params:@{@"action":@"start",@"data":[@{@"device":[self deviceParam]} jsonString]}
             callback:^(BHttpRequestOperation *operation, id json, NSError *error) {
                 BResponse *response = [BResponse responseWithDictionary:json];
                 if ([response isSuccess]) {
                     DLOG(@"json:%@", json);
                     DeviceSNO = RETAIN([[response data] valueForKey:@"sno"]);
                 }else{
                     DLOG(@"error:%@", error);
                     AsyncCall(^{
                         [BehaviorTracker startSession];
                     }, 3, YES);
                 }
             }];
}
+ (void)trackEvent:(NSString *)event group:(NSString *)group element:(NSString *)ele duration:(int)dur{
    NSMutableDictionary *evtParam = [NSMutableDictionary dictionaryWithDictionary:DeviceParam];
    [evtParam setValue:[[NSDate date] format:@"yyyy-MM-dd HH:mm:ss Z"] forKeyPath:@"date"];
    [evtParam setValue:DeviceSNO forKeyPath:@"sno"];
    [evtParam setValue:event forKeyPath:@"event"];
    [evtParam setValue:group?:@"" forKeyPath:@"group"];
    [evtParam setValue:ele?:@"" forKeyPath:@"element"];
    [evtParam setValue:[NSNumber numberWithInt:dur] forKeyPath:@"duration"];
    [evtParam setValue:LogSessionID forKeyPath:@"session_id"];
    id param = @{@"device":[self deviceParam], @"events":@[evtParam]};
    [self postWithUrl:LogApiPostEvent
               params:@{@"data":[param jsonString]}
             callback:^(BHttpRequestOperation *operation, id json, NSError *error) {
                 DLOG(@"%@",json);
             }];
    
}
+ (void)trackEvent:(NSString *)event group:(NSString *)group element:(NSString *)ele{
    [self trackEvent:event group:group element:ele duration:0];
}

+ (void)trackStartWithGroup:(NSString *)group element:(NSString *)ele{
    NSString *k = [NSString stringWithFormat:@"track_%@",group];
    if (ele) {
        k = [NSString stringWithFormat:@"%@_%@", k, ele];
    }
    [G setValue:[NSDate date] forKey:k];
    [self trackEvent:@"in" group:group element:ele duration:0];
}
+ (void)trackEndWithGroup:(NSString *)group element:(NSString *)ele{
    NSString *k = [NSString stringWithFormat:@"track_%@",group];
    if (ele) {
        k = [NSString stringWithFormat:@"%@_%@", k, ele];
    }
    NSDate *s = [G valueForKey:k];
    int len = 0;
    if(s)
        len = abs( [[NSDate date] timeIntervalSinceDate:s] );
    [self trackEvent:@"out" group:group element:ele duration:len];
    [G remove:k];
}
@end
