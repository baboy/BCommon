//
//  RequestStatus.h
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-12.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>
enum{
    RequestStatusCodeSuccess=1,
    RequestStatusCodeFail, 
}RequestStatusCode;
@interface RequestStatus : NSObject
@property (nonatomic, assign) int status;
@property (nonatomic, retain) NSString *msg;
- (BOOL)isSuccess;
- (id)initWithDictionary:(NSDictionary *)dict;
@end
