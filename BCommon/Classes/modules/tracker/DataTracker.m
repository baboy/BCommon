//
//  DataTracker.m
//  iVideo
//
//  Created by baboy on 4/25/14.
//  Copyright (c) 2014 baboy. All rights reserved.
//

#import "DataTracker.h"
#define WatchTVLogApi @"http://app.tvie.com.cn/api/v1/live/log/"

@implementation DataTracker

+ (void)trackWatchTV:(id)value{
    id p = [NSMutableDictionary dictionaryWithDictionary:value];
    [BHttpRequest postWithUrl:WatchTVLogApi params:p cache:nil callback:nil];
}
@end
