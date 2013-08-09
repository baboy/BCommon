//
//  BUser.m
//  iShow
//
//  Created by baboy on 13-6-3.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BUser.h"

static id _current_user = nil;

@implementation BUser
- (void)dealloc{
    RELEASE(_uid);
    RELEASE(_username);
    RELEASE(_password);
    RELEASE(_email);
    RELEASE(_ukey);
    RELEASE(_name);
    RELEASE(_origin);
    RELEASE(_metadata);
    RELEASE(_avatar);
    RELEASE(_mobile);
    RELEASE(_avatar);
    RELEASE(_education);
    RELEASE(_school);
    RELEASE(_desc);
    RELEASE(_birthday);
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
        [self setAvatar:nullToNil([dict valueForKey:@"avatar"])];
        [self setGender:[nullToNil([dict valueForKey:@"gender"]) intValue]];
        [self setAge:[nullToNil([dict valueForKey:@"age"]) intValue]];
        
        [self setDesc:nullToNil([dict valueForKey:@"desc"])];
        if (!self.desc) {
            [self setDesc:nullToNil([dict valueForKey:@"description"])];
        }
        [self setMobile:nullToNil([dict valueForKey:@"mobile"])];
        [self setEducation:nullToNil([dict valueForKey:@"education"])];
        [self setSchool:nullToNil([dict valueForKey:@"school"])];
        NSString *bd = nullToNil([dict valueForKey:@"school"]);
        if (bd) {
            [self setBirthday:[bd dateWithFormat:FULLDATEFORMAT]];
        }
        id meta = [dict valueForKey:@"metadata"];
        if ([meta isKindOfClass:[NSString class]]) {
            [self setMetadata:[meta json]];
        }else{
            [self setMetadata:meta];
        }
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
    if(self.avatar) [dict setValue:self.avatar forKey:@"avatar"];
    if(self.metadata) [dict setValue:self.metadata forKey:@"metadata"];
    
    [dict setValue:[NSNumber numberWithInt:self.gender] forKey:@"gender"];
    [dict setValue:[NSNumber numberWithInt:self.age] forKey:@"age"];
    
    if (self.education) [dict setValue:self.education forKey:@"education"];
    if (self.school) [dict setValue:self.school forKey:@"school"];
    if (self.mobile) [dict setValue:self.mobile forKey:@"mobile"];
    if (self.birthday) [dict setValue:self.birthday forKey:@"birthday"];
    if (self.desc) [dict setValue:self.desc forKey:@"desc"];
    
    return dict;
}
- (BOOL)isLogin{
    return USER?YES:NO;
}
+ (BUser *)user{
    @synchronized(self){
        if (!_current_user) {
            NSDictionary *json = [[DBCache valueForKey:@"USER"] objectFromJSONString];
            if (json){
                _current_user = [[[self class] alloc] initWithDictionary:json];
            }
        }
    }
    return _current_user;
}
+ (BOOL)loginWithUser:(BUser *)user{
    if (user) {
        DLOG(@"dict:%@", [[user dict] jsonString]);
        [DBCache setValue:[[user dict] jsonString] forKey:@"USER"];
        RELEASE(_current_user);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyLogin object:nil];
        return YES;
    }
    return NO;
}
+ (void)logout{
    [DBCache removeForKey:@"USER"];
    if (_current_user) {
        RELEASE(_current_user);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyLogout object:nil];
    }
}
+ (BHttpRequestOperation *)loginWithUserName:(NSString *)uname password:(NSString *)pwd success:(void (^)(BUser *, NSError *))success failure:(void (^)(NSError *))failure{
    
    BHttpClient *client = [BHttpClient defaultClient];
    NSDictionary *params = @{@"username":uname,@"password":pwd};
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
    NSDictionary *params = @{@"username":uname,@"password":pwd,@"email":email};
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
