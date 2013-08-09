//
//  BUser.h
//  iShow
//
//  Created by baboy on 13-6-3.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Uid         [[BUser user] uid]?:@""
#define UKEY        @"4Eg17LaBz60DSIEOA0"
//[[BUser user] ukey]?@""
#define USER        [BUser user]

#define UserParams  [NSMutableDictionary dictionaryWithObjectsAndKeys:UKEY, @"ukey", nil]



@interface BUser : NSObject
@property (nonatomic, retain) NSString *origin;
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *ukey;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, retain) NSString *education;
@property (nonatomic, retain) NSString *school;
@property (nonatomic, retain) NSString *mobile;
@property (nonatomic, retain) NSDate *birthday;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, retain) NSDictionary *metadata;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dict;
- (BOOL)isLogin;
//当前登录用户
+ (BUser*) user;
//用该用户信息登录
+ (BOOL)loginWithUser:(BUser *)user;
//登出
+ (void)logout;

//登录调用
+ (BHttpRequestOperation *)loginWithUserName:(NSString *)uname password:(NSString *)pwd success:(void (^)(BUser* user, NSError *error))success failure:(void (^)(NSError *error))failure;
//注册
+ (BHttpRequestOperation *)registerWithUserName:(NSString *)uname email:(NSString *)email password:(NSString *)pwd success:(void (^)(BUser* user,NSError *error))success failure:(void (^)(NSError *error))failure;

@end
