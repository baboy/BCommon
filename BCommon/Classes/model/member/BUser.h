//
//  BUser.h
//  iShow
//
//  Created by baboy on 13-6-3.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Uid         [[BUser user] uid]?:@""
#define UKey        [[BUser user] ukey]?:@""
#define USER        [BUser user]

#define UserParams  [NSMutableDictionary dictionaryWithObjectsAndKeys:UKey, @"ukey", nil]


@interface BUser : NSObject
@property (nonatomic, assign) NSString *uid;
@property (nonatomic, assign) NSString *username;
@property (nonatomic, assign) NSString *nickname;
@property (nonatomic, assign) NSString *password;
@property (nonatomic, assign) NSString *email;
@property (nonatomic, assign) NSString *ukey;
@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *signature;
@property (nonatomic, assign) NSString *desc;
@property (nonatomic, assign) NSString *avatar;
@property (nonatomic, assign) NSString *avatarThumbnail;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSString *education;
@property (nonatomic, assign) NSString *school;
@property (nonatomic, assign) NSString *mobile;
@property (nonatomic, assign) NSDate *birthday;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSDictionary *metadata;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dict;
- (id)get:(NSString *)key;
- (void)setValue:(id)val forKey:(NSString *)key;
+ (BOOL)isLogin;
//当前登录用户
+ (id) user;
//用该用户信息登录
+ (BOOL)loginWithUser:(BUser *)user;
//登出
+ (void)logout;
+ (void)checkLoginWithCallback:(void (^)(BUser* user,NSError *error))callback;

//登录调用
+ (BHttpRequestOperation *)loginWithUserName:(NSString *)uname password:(NSString *)pwd success:(void (^)(BUser* user, NSError *error))success failure:(void (^)(NSError *error))failure;
//注册
+ (BHttpRequestOperation *)registerWithUserName:(NSString *)uname email:(NSString *)email password:(NSString *)pwd success:(void (^)(BUser* user,NSError *error))success failure:(void (^)(NSError *error))failure;

@end
