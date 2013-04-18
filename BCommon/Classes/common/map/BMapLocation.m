//
//  CourseLocation.m
//  course
//
//  Created by Yinghui Zhang on 8/23/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "BMapLocation.h"

@implementation BMapLocation
@synthesize address = _address;
@synthesize province = _province;
@synthesize country = _country;
@synthesize district = _district;
@synthesize city = _city;
@synthesize latitude;
@synthesize longitude;
- (void)dealloc{
    RELEASE(_country);
    RELEASE(_province);
    RELEASE(_district);
    RELEASE(_city);
    RELEASE(_address);
    [super dealloc];
}

- (id)initWithGoogleData:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setAddress:[dict valueForKey:@"address"]];
        NSDictionary *p = [dict valueForKey:@"Point"];
        NSArray *c = [p valueForKey:@"coordinates"];
        if ([c count] >=2) {
            [self setLatitude:[[c objectAtIndex:1] doubleValue]];
            [self setLongitude:[[c objectAtIndex:0] doubleValue]];
        }
        NSDictionary *d = [[[dict valueForKey:@"AddressDetails"] valueForKey:@"Country"] valueForKey:@"AdministrativeArea"];;
        [self setCountry:[dict valueForKeyPath:@"AddressDetails.Country.CountryName"]];
        [self setProvince:[d valueForKey:@"AdministrativeAreaName"]];
        
        id cityName = [dict valueForKeyPath:@"AddressDetails.Country.AdministrativeArea.Locality.LocalityName"];
        if (!cityName) {
            cityName = [dict valueForKeyPath:@"AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.LocalityName"];
        }
        if ([cityName isKindOfClass:[NSArray class]]) {
            if ([cityName count] > 0 && [[cityName objectAtIndex:0] isKindOfClass:[NSString class]]) {
                cityName = [cityName objectAtIndex:0];
            }
        }
        
        [self setCity:cityName];
        [self setDistrict:[dict valueForKeyPath:@"AddressDetails.Country.AdministrativeArea.Locality.DependentLocality.DependentLocalityName"]];
    }
    return self;
}
- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setAddress:[dict valueForKey:@"address"]];
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
+ (BMapLocation *)currentLocation{
    return [G valueForKey:@"location"];
}
+ (void)saveCurrentLocation:(BMapLocation *)location{
    [G setValue:location forKey:@"location"];
    NSString *currentAddress = [NSString stringWithFormat:@"%@%@%@", [location country]?[location country]:@"", [location province]?[location province]:@"",([location city] && ![[location city] isEqualToString:[location province]])?[location city]:@""];
    [G setValue:currentAddress forKey:@"CurrentAdress"];
}
+ (BHttpRequestOperation *)getLocationByIpSuccess:(void (^)(BMapLocation *loc))success failure:(void (^)(NSError *error))failure{
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:[NSURL URLWithString:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json"] parameters:nil];
    BHttpRequestOperation *operation = [client jsonRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id json) {
                                                                     BMapLocation *loc = nil;
                                                                     if (json) {
                                                                         loc = [[[BMapLocation alloc] init] autorelease];
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
+ (BHttpRequestOperation *)searchLocation:(NSString *)locationName success:(void (^)(BMapLocation *loc))success failure:(void (^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=json&hl=zh_CN",locationName];
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:[NSURL URLWithString:url] parameters:nil];
    BHttpRequestOperation *operation = [client jsonRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id json) {
                                                                     BMapLocation *loc = nil;
                                                                     if (json && [json valueForKey:@"Placemark"] && [[json valueForKey:@"Placemark"] count]) {
                                                                         loc = [[[BMapLocation alloc] initWithGoogleData:[[json valueForKey:@"Placemark"] objectAtIndex:0]] autorelease];
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
+ (BHttpRequestOperation *)searchCoord:(CLLocationCoordinate2D)coord success:(void (^)(BMapLocation *loc))success failure:(void (^)(NSError *error))failure{
    NSString *q = [NSString stringWithFormat:@"%f,%f",coord.latitude,coord.longitude];
    return [self searchLocation:q success:success failure:failure];
}
@end
