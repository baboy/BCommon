//
//  CacheURLProtocol.h
//  iLook
//
//  Created by Yinghui Zhang on 2/26/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ImageScheme @"image"
#define VideoScheme @"video"

@interface NSURL(cache)

+ (NSString *) cacheImageURLString:(NSString *)urlString;
+ (NSURL *) cacheImageURLWithString:(NSString *)urlString;
+ (NSURL *) imageURLWithString:(NSString *)urlString;
+ (NSURL *) videoURLWithString:(NSString *)urlString;
+ (NSString*) URLStringWithScheme:(NSString *)scheme urlString:(NSString*)urlString;
+ (BOOL) isCacheImageURL:(NSURL *)url;
- (NSString *)httpURLString;
- (BOOL) isImageURL;
- (BOOL) isVideoURL;
+ (NSString *)imageScheme;
+ (NSString *)videoScheme;
@end

@interface CacheURLProtocol : NSURLProtocol{

}

@end
