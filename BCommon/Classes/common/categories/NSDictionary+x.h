//
//  NSDictionary+x.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 7/23/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(x)
- (NSMutableData *)postData;
- (NSData *)jsonData;
- (NSString *)jsonString;
- (NSMutableDictionary *)json;
@end
