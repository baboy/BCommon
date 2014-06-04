//
//  NSThread+x.h
//  iVideo
//
//  Created by baboy on 13-12-9.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AsyncCallBlock)(void);
void AsyncCall(AsyncCallBlock block, float t, BOOL mainThread);

@interface NSThread(x)
+ (void) runOnMainQueue:(void (^)(void))block;
@end
