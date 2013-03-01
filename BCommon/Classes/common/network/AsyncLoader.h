//
//  ConfigLoader.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AsyncLoader : NSObject
+ (BHttpRequestOperation *)loadDataString:(NSString *)url param:(NSDictionary*)param cached:(BOOL)cached success:(void (^)(NSString *s))success failure:(void (^)(NSError *error))failure;
+ (BHttpRequestOperation *)loadData:(NSString *)url param:(NSDictionary*)param cached:(BOOL)cached success:(void (^)(NSData *data))success failure:(void (^)(NSError *error))failure;
+ (BHttpRequestOperation *)post:(NSString *)url param:(NSDictionary*)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (BHttpRequestOperation *)feedback:(NSString *)content success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
