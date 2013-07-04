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
    RequestStatusCodeSuccess=1,
    RequestStatusCodeFail, 
}RequestStatusCode;
@interface RequestStatus : NSObject
@property (nonatomic, assign) int statusCode;
@property (nonatomic, retain) NSString *msg;
+ (id)statusWithDictionary:(NSDictionary *)dict;
- (BOOL)isSuccess;
- (NSError *)error;
- (id)initWithDictionary:(NSDictionary *)dict;
@end
