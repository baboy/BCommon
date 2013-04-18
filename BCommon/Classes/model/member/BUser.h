//
//  BMember.h
//  iLookForiPhone
//
//  Created by hz on 12-10-18.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BUser : NSObject
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *ukey;
@property (nonatomic, retain) NSString *name;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dict;
+ (BUser*) user;
+ (BOOL)login:(BUser *)user;
+ (void)logout;
@end
