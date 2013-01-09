//
//  NSMutableData.m
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-7-23.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "NSMutableData+x.h"
#define BodyBoundaryString      @"--HelloBaboy\r\n"

@implementation NSMutableData(x)

- (void)appendData:(NSData *)d forKey:(NSString *)key{
    if ([self length] < 10 ) {   
        [self appendData:[BodyBoundaryString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [self appendData:d];
    [self appendData:[BodyBoundaryString dataUsingEncoding:NSUTF8StringEncoding]];
}
- (void)appendString:(NSString *)s forKey:(NSString *)key{
    NSMutableString *ms=[[[NSMutableString alloc] init] autorelease];
    if ([self length] < 10 ) {        
        [ms appendString:BodyBoundaryString];
    }
    [ms appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",[key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [ms appendFormat:@"%@\r\n",[s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [ms appendString:BodyBoundaryString];
    [self appendData:[ms dataUsingEncoding:NSUTF8StringEncoding]];
}
@end
