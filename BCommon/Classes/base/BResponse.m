//
//  RequestStatus.m
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-12.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "BResponse.h"
NSString *HttpRequestDomain = @"X-Channel request error";
@implementation BResponse
+ (id)responseWithDictionary:(NSDictionary *)dict{
    BResponse *status = AUTORELEASE([[BResponse alloc] initWithDictionary:dict]);
    return status;
}
- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.dict = [NSMutableDictionary dictionaryWithDictionary:dict];
        }
    }
    return self;
}
- (BOOL)isSuccess{
    return self.status == ResponseStatusCodeSuccess;
}
- (void)setDict:(NSMutableDictionary *)dict{
    RELEASE(_dict);
    _dict = [[NSMutableDictionary alloc] initWithDictionary:dict];
}
- (void)setMsg:(NSString *)msg{
    [self.dict setValue:msg forKey:@"msg"];
}
- (NSString *)msg{
    return [self.dict valueForKey:@"msg"];
}
- (void)setStatus:(ResponseStatusCode)status{
    [self.dict setValue:[NSNumber numberWithInt:status] forKey:@"status"];
}
- (ResponseStatusCode)status{
    return [[self.dict valueForKey:@"status"] intValue];
}
- (NSError *)error{
    if (self.isSuccess) {
        return nil;
    }
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:self.msg?self.msg:@""};
    NSError *error = [NSError errorWithDomain:HttpRequestDomain code:self.status userInfo:userInfo];
    return error;
}
- (id)data{
    return [self.dict valueForKey:@"data"];
}
- (void)dealloc{
    RELEASE(_dict);
    [super dealloc];
}
@end
