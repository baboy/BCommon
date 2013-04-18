//
//  BEnumerator.m
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-7-23.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "BEnumerator.h"

@interface BEnumerator()
@property (nonatomic, assign) int pos;
@end

@implementation BEnumerator
@synthesize array = _array;
@synthesize pos = _pos;
@synthesize currentObject = _currentObject;
- (void)dealloc{
    RELEASE(_array);
    [super dealloc];
}

- (id)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        [self setArray:array];
    }
    return self;
}
- (void)setArray:(NSArray *)array{
    RELEASE(_array);
    _array = [array retain];
    _pos = -1;
}
- (id)objectInArrayAtIndex:(int)index{    
    if ( [self.array count] > index && index >= 0 ) {
        self.pos = index;
        _currentObject = [self.array objectAtIndex:index];
        return _currentObject;
    }
    return nil;
}
- (id)firstObject{
    self.pos = 0;
    return [self objectInArrayAtIndex:self.pos];
}
- (id)currentObject{
    return _currentObject;
}
- (id)nextObject{
    return [self objectInArrayAtIndex:self.pos+1];
}
- (int)count{
    return [self.array count];
}
@end

@implementation NSArray(BEnumerator)
- (BEnumerator *)iterator{
    return [[[BEnumerator alloc] initWithArray:self] autorelease];
}

@end
