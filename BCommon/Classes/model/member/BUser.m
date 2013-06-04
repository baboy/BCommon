//
//  BUser.m
//  iShow
//
//  Created by baboy on 13-6-3.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BUser.h"

@implementation BUser
- (void)dealloc{
    RELEASE(_uid);
    RELEASE(_username);
    RELEASE(_password);
    RELEASE(_email);
    RELEASE(_ukey);
    RELEASE(_name);
    [super dealloc];
}
- (id)initWithDictionary:(NSDictionary *)dict{
    if ( self = [super init] ) {
        [self setUid:nullToNil([dict valueForKey:@"uid"])];
        [self setEmail:nullToNil([dict valueForKey:@"email"])];
        [self setUsername:nullToNil([dict valueForKey:@"username"])];
        [self setUkey:nullToNil([dict valueForKey:@"ukey"])];
        [self setName:nullToNil([dict valueForKey:@"name"])];
        [self setPassword:nullToNil([dict valueForKey:@"password"])];
    }
    return self;
}
- (NSDictionary *)dict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if(self.uid) [dict setValue:self.email forKey:@"uid"];
    if(self.email) [dict setValue:self.email forKey:@"email"];
    if(self.username) [dict setValue:self.username forKey:@"username"];
    if(self.name) [dict setValue:self.name forKey:@"name"];
    if(self.password) [dict setValue:self.password forKey:@"password"];
    if(self.ukey) [dict setValue:self.ukey forKey:@"ukey"];
    return dict;
}
+ (BUser *)user{
    if (!USER) {
        NSDictionary *json = [[DBCache valueForKey:@"USER"] objectFromJSONString];
        if(json){
            BUser *user = [[[BUser alloc] initWithDictionary:json] autorelease];
            [G setValue:user forKey:@"USER"];
        }
    }
    return USER;
}
+ (BOOL)loginWithUser:(BUser *)user{
    if (user) {
        [DBCache setValue:[[user dict] JSONString] forKey:@"USER"];
        [G setValue:user forKey:@"USER"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyLogin object:nil];
        return YES;
    }
    return NO;
}
+ (void)logout{
    [DBCache removeForKey:@"USER"];
    BUser *user = [G remove:@"USER"];
    if (user) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyLogout object:nil];
    }
}
+ (BHttpRequestOperation *)loginWithUserName:(NSString *)uname password:(NSString *)pwd success:(void (^)(BUser *, NSError *))success failure:(void (^)(NSError *))failure{
    
    BHttpClient *client = [BHttpClient defaultClient];
    NSDictionary *params = @{UserNameKey:uname,UserPwdKey:pwd};
    NSURLRequest *request = [client requestWithPostURL:[NSURL URLWithString:ApiMemberLogin] parameters:params];
    BHttpRequestOperation *operation = [client dataRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id data) {
                                                                     
                                                                 }
                                                                 failure:^(BHttpRequestOperation *request, NSError *error) {
                                                                     DLOG(@"[BUser] loginWithUserName error:%@",error);
                                                                 }];
    //no cache
    //[operation setRequestCache:[BHttpRequestCache fileCache]];
    [client enqueueHTTPRequestOperation:operation];
    
    return operation;
}
+ (BHttpRequestOperation *)registerWithUserName:(NSString *)uname email:(NSString *)email password:(NSString *)pwd success:(void (^)(BUser *, NSError *))success failure:(void (^)(NSError *))failure{
    
    BHttpClient *client = [BHttpClient defaultClient];
    NSDictionary *params = @{UserNameKey:uname,UserPwdKey:pwd,UserEmailKey:email};
    NSURLRequest *request = [client requestWithPostURL:[NSURL URLWithString:ApiMemberRegister] parameters:params];
    BHttpRequestOperation *operation = [client dataRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id data) {
                                                                     
                                                                 }
                                                                 failure:^(BHttpRequestOperation *request, NSError *error) {
                                                                     DLOG(@"[BUser] registerWithUserName error:%@",error);
                                                                 }];
    //no cache;
    //[operation setRequestCache:[BHttpRequestCache fileCache]];
    [client enqueueHTTPRequestOperation:operation];
    
    return operation;
}
@end
