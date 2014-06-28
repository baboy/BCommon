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
+ (void)initialize{
    [self setup];
}
+ (void)setup:(NSString *)plist{
    NSString *f = getBundleFile([NSString stringWithFormat:@"%@.conf.plist", plist]);
    NSDictionary *conf = [NSDictionary dictionaryWithContentsOfFile:f];
    for (NSString *k in [conf allKeys]) {
        NSString *v = [conf valueForKey:k];
        [DBCache setValue:v forKey:k];
    }
}
+ (void)setup{
    [self setup:@"default"];
    [G setValue:DeviceParam forKey:@"device_param"];
    [G setValue:URLCommonParam forKey:@"url_common_param"];
}

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
    if (!v) {
        v = [DBCache valueForKey:key];
    }
	return v;
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

+ (void)setConf:(NSString *)conf{
    [self setup:conf];
    [BApi setup:conf];
    [Theme setup:conf];
    [GString setup:conf];
}
@end


void add_app_start_times(){
    [DBCache setValue:[NSNumber numberWithInt:get_app_start_times()+1] forKey:@"app_start_times"];
    add_current_app_start_times();
}
int get_app_start_times(){
    return [DBCache intForKey:@"app_start_times"];
}
void add_current_app_start_times(){
    NSString *k = [NSString stringWithFormat:@"app_start_times_ver%@",BundleVersion];
    [DBCache setValue:[NSNumber numberWithInt:get_current_app_start_times()+1] forKey:k];
}
int get_current_app_start_times(){
    NSString *k = [NSString stringWithFormat:@"app_start_times_ver%@",BundleVersion];
    return [DBCache intForKey:k];
}
void set_current_app_comment(int level){
    NSString *k = [NSString stringWithFormat:@"current_app_comment_ver%@",BundleVersion];
    [DBCache setValue:[NSNumber numberWithInt:level] forKey:k];
}
int get_current_app_comment(){
    NSString *k = [NSString stringWithFormat:@"current_app_comment_ver%@",BundleVersion];
    return [DBCache intForKey:k];
}



