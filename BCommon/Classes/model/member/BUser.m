//
//  BMember.m
//  iLookForiPhone
//
//  Created by hz on 12-10-18.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "BUser.h"

@implementation BUser
@synthesize uid = _uid;
@synthesize username = _username;
@synthesize password = _password;
@synthesize email = _email;
@synthesize ukey = _ukey;
@synthesize name = _name;
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
+ (BOOL)login:(BUser *)user{
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
@end
