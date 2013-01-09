//
//  RequestStatus.m
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-12.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "RequestStatus.h"
#import "Utils.h"
#import "G.h"

@implementation RequestStatus
@synthesize status = _status;
@synthesize msg = _msg;
- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setMsg:nullToNil([dict valueForKey:@"msg"])];
        [self setStatus:[nullToNil([dict valueForKey:@"status"]) intValue]];
    }
    return self;
}
- (BOOL)isSuccess{
    return self.status == RequestStatusCodeSuccess;
}
- (void)dealloc{
    RELEASE(_msg);
    [super dealloc];
}
@end
