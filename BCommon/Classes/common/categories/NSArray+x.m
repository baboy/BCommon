//
//  NSArray+x.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 7/20/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "NSArray+x.h"

@implementation NSArray(x)
- (NSArray *)reverse {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end



