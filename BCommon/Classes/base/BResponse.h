//
//  RequestStatus.h
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-12.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *HttpRequestDomain;

enum{
    ResponseStatusCodeSuccess=1,
    ResponseStatusCodeFail,
};
typedef int ResponseStatusCode;

@interface BResponse : NSObject
@property (nonatomic, assign) ResponseStatusCode status;
@property (nonatomic, retain) NSString *msg;
@property (nonatomic, retain) NSMutableDictionary *dict;
+ (id)responseWithDictionary:(NSDictionary *)dict;
- (BOOL)isSuccess;
- (NSError *)error;
- (id)initWithDictionary:(NSDictionary *)dict;
- (id)data;
@end
