//
//  BUser.h
//  iShow
//
//  Created by baboy on 13-6-3.
//  Copyright (c) 2013年 baboy. All rights reserved.
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
//当前登录用户
+ (BUser*) currentUser;
//用该用户信息登录
+ (BOOL)loginWithUser:(BUser *)user;
//登出
+ (void)logout;

//登录调用
+ (BHttpRequestOperation *)loginWithUserName:(NSString *)uname password:(NSString *)pwd success:(void (^)(BUser* user, NSError *error))success failure:(void (^)(NSError *error))failure;
//注册
+ (BHttpRequestOperation *)registerWithUserName:(NSString *)uname email:(NSString *)email password:(NSString *)pwd success:(void (^)(BUser* user,NSError *error))success failure:(void (^)(NSError *error))failure;

@end
