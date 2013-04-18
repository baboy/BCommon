//
//  G.m
//  iLook
//
//  Created by Zhang Yinghui on 5/27/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "Global.h"

@interface G()

+ (void) initData;

@end


@implementation G
static NSMutableDictionary *data;

+ (void) initData{
	if (!data) {
		data = [[NSMutableDictionary alloc] init];
	}
}
+ (void) setValue:(id) val forKey:(id)key{
	[G initData];
	[data setValue:val forKey:key];
}
+ (id) valueForKey:(id)key{
	id v = data?[data valueForKey:key]:nil;
	return v?v:nil;
}
+ (id)remove:(id)key{
    id obj = nil;
    if (data) {
        obj = [self valueForKey:key];
        [data removeObjectForKey:key];
    }
    return obj;
}
+ (NSDictionary *) dict{
	return data;
}
@end
