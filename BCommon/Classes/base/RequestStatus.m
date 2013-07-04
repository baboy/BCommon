//
//  RequestStatus.m
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-12.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "RequestStatus.h"
NSString *HttpRequestDomain = @"X-Channel request error";
@implementation RequestStatus
+ (id)statusWithDictionary:(NSDictionary *)dict{
    RequestStatus *status = AUTORELEASE([[RequestStatus alloc] initWithDictionary:dict]);
    return status;
}
- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            [self setMsg:nullToNil([dict valueForKey:@"msg"])];
            [self setStatusCode:[nullToNil([dict valueForKey:@"status"]) intValue]];
        }
    }
    return self;
}
- (BOOL)isSuccess{
    return self.statusCode == RequestStatusCodeSuccess;
}
- (NSError *)error{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:self.msg?self.msg:@""};
    NSError *error = [NSError errorWithDomain:HttpRequestDomain code:self.statusCode userInfo:userInfo];
    return error;
}
- (void)dealloc{
    RELEASE(_msg);
    [super dealloc];
}
@end
