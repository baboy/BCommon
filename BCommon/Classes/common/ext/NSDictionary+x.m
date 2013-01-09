//
//  NSDictionary+x.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 7/23/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "NSDictionary+x.h"
#import "NSMutableData+x.h"

@implementation NSDictionary(x)

- (NSMutableData *)postData{
    if (![self allKeys]) {
        return nil;
    }
    NSMutableData *postData = [NSMutableData data];
    for (NSString *k in [self allKeys]) {
        [postData appendString:[[self valueForKey:k] description] forKey:k];
    }
    return postData;
}
@end
