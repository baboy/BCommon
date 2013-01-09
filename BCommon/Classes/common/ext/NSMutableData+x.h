//
//  NSMutableData.h
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-7-23.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData(x)
- (void)appendString:(NSString *)s forKey:(NSString *)key;
- (void)appendData:(NSData *)d forKey:(NSString *)key;
@end
