//
//  ConfigLoader.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@interface AsyncLoader : NSObject

+ (ASIHTTPRequest *)loadConfig:(NSString *)url param:(NSDictionary*)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (ASIHTTPRequest *)loadJSONData:(NSString *)url param:(NSDictionary*)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (ASIHTTPRequest *)loadDataString:(NSString *)url param:(NSDictionary*)param cached:(BOOL)cached success:(void (^)(NSString *s))success failure:(void (^)(NSError *error))failure;
+ (ASIHTTPRequest *)loadData:(NSString *)url param:(NSDictionary*)param cached:(BOOL)cached success:(void (^)(NSData *data))success failure:(void (^)(NSError *error))failure;
+ (ASIHTTPRequest *)post:(NSString *)url param:(NSDictionary*)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (ASIHTTPRequest *)feedback:(NSString *)content success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
