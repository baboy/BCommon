//
//  NSThread+x.m
//  iVideo
//
//  Created by baboy on 13-12-9.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "NSThread+x.h"

@implementation NSThread(x)
+ (void) runOnMainQueue:(void (^)(void))block
{
	if ([NSThread isMainThread])
	{
		block();
	}
	else
	{
		dispatch_sync(dispatch_get_main_queue(), block);
	}
}
@end


void AsyncCall(AsyncCallBlock block, float t, BOOL mainThread){
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*t),
                   (mainThread?dispatch_get_main_queue():dispatch_get_current_queue()),
                   block
                   );
}