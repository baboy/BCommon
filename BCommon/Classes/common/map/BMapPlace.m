//
//  BMapPlace.m
//  BCommon
//
//  Created by baboy on 13-7-16.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BMapPlace.h"

@implementation BMapPlace
- (void)dealloc{
    RELEASE(_country);
    RELEASE(_province);
    RELEASE(_district);
    RELEASE(_city);
    RELEASE(_address);
    [super dealloc];
}
- (id)initWithGeoData:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setAddress:[dict valueForKey:@"formatted_address"]];
        NSDictionary *location = [dict valueForKeyPath:@"geometry.location"];
        if (location) {
            [self setLatitude:[[location valueForKey:@"lat"] doubleValue]];
            [self setLongitude:[[location valueForKey:@"lng"] doubleValue]];
        }
        NSArray *address_components = [dict valueForKey:@"address_components"];
        int n = [address_components count];
        NSString *city = nil;
        if ( n > 0) {
            for (int i=0; i<n; i++) {
                NSDictionary *component = [address_components objectAtIndex:i];
                NSArray *types = [component valueForKey:@"types"];
                NSString *locality = [types count] > 0 ? [types objectAtIndex:0] : nil;
                if ([locality isEqual:@"sublocality"]) {
                    city = [component valueForKey:@"long_name"];
                }
                if ([locality isEqual:@"locality"]) {
                    city = [component valueForKey:@"long_name"];
                    break;
                }
            }
        }
        [self setCity:city];
    }
    return self;
}
- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setAddress:[dict valueForKey:@"address"]];
        [self setCity:[dict valueForKey:@"city"]];
        [self setLatitude:[[dict valueForKey:@"latitude"] doubleValue]];
        [self setLongitude:[[dict valueForKey:@"longitude"] doubleValue]];
    }
    return self;
}
- (NSDictionary *)dict{
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:3];
    if (self.address)
        [d setValue:self.address forKey:@"address"];
    [d setValue:self.country forKey:@"country"];
    [d setValue:self.city forKey:@"city"];
    [d setValue:self.district forKey:@"district"];
    [d setValue:self.province forKey:@"province"];
    [d setValue:[NSNumber numberWithDouble:self.latitude] forKey:@"latitude"];
    [d setValue:[NSNumber numberWithDouble:self.longitude] forKey:@"longitude"];
    return d;
}
+ (BMapPlace *)currentLocation{
    return [G valueForKey:@"location"];
}
+ (void)saveCurrentLocation:(BMapPlace *)location{
    [G setValue:location forKey:@"location"];
    NSString *currentAddress = [NSString stringWithFormat:@"%@%@%@", [location country]?[location country]:@"", [location province]?[location province]:@"",([location city] && ![[location city] isEqualToString:[location province]])?[location city]:@""];
    [G setValue:currentAddress forKey:@"CurrentAdress"];
}
+ (BHttpRequestOperation *)getLocationByIpSuccess:(void (^)(BMapPlace *loc))success failure:(void (^)(NSError *error))failure{
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:[NSURL URLWithString:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json"] parameters:nil];
    BHttpRequestOperation *operation = [client jsonRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id json) {
                                                                     BMapPlace *loc = nil;
                                                                     if (json) {
                                                                         loc = [[[BMapPlace alloc] init] autorelease];
                                                                         loc.country = [json valueForKey:@"country"];
                                                                         loc.province = [json valueForKey:@"province"];
                                                                         loc.city = [json valueForKey:@"city"];
                                                                         loc.district = [json valueForKey:@"district"];
                                                                     }
                                                                     success(loc);
                                                                     
                                                                 } failure:^(BHttpRequestOperation *operation, NSError *error) {
                                                                     if (failure) {
                                                                         failure(error);
                                                                     }
                                                                 }];
    [operation start];
    return operation;
}
+ (BHttpRequestOperation *)search:(NSString *)location callback:(void (^)(BHttpRequestOperation *operation,NSArray *locs, NSError *error))callback{
    NSString *url = [Utils url:ApiQueryLocation withParam:@{@"q":location}];
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:[NSURL URLWithString:url] parameters:nil];
    BHttpRequestOperation *operation =
    [client jsonRequestWithURLRequest:request
                              success:^(BHttpRequestOperation *operation, id json) {
                                  BResponse *response = [BResponse responseWithDictionary:json];
                                  NSMutableArray *addrs = nil;
                                  NSError *error = nil;
                                  if (response.isSuccess) {
                                      NSArray *list = response.data;
                                      if ([list isKindOfClass:[NSArray class]]) {
                                          addrs = [NSMutableArray array];
                                          int n = [list count];
                                          for (int i=0; i<n; i++) {
                                              BMapPlace *loc = AUTORELEASE([[BMapPlace alloc] initWithGeoData:[list objectAtIndex:i]]);
                                              [addrs addObject:loc];
                                          }
                                      }
                                  }
                                  if ( !addrs || [addrs count] ==0 ) {
                                      NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(@"未获取到地址信息", nil)};
                                      error = [NSError errorWithDomain:HttpRequestDomain code:-1 userInfo:userInfo];
                                  }
                                  callback(operation, addrs, error);
                                  
                              } failure:^(BHttpRequestOperation *operation, NSError *error) {
                                  if (callback) {
                                      callback(operation, nil, error);
                                  }
                              }];
    [operation start];
    return operation;
}
@end
