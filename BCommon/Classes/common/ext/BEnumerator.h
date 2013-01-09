//
//  BEnumerator.h
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-7-23.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BEnumerator : NSObject
@property (nonatomic, retain) NSArray *array;
@property (nonatomic, readonly) id currentObject;
- (id)initWithArray:(NSArray *)array;
- (id)nextObject;
- (id)firstObject;
@end

@interface NSArray(BEnumerator)
- (BEnumerator *)iterator;
@end
