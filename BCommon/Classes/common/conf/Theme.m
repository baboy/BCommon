//
//  Theme.m
//  BCommon
//
//  Created by baboy on 13-8-16.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "Theme.h"


@implementation Theme
+ (void)initialize{
    [self setup];
}
+ (void)setup:(NSString *)theme{
    NSString *f = getBundleFile([NSString stringWithFormat:@"%@.theme.plist", theme]);
    NSDictionary *conf = [NSDictionary dictionaryWithContentsOfFile:f];
    for (NSString *k in [conf allKeys]) {
        NSString *v = [conf valueForKey:k];
        [DBCache setValue:v forKey:k domain:@"Theme"];
    }
}
+ (void)setup{
    [self setup:@"default"];
}

+ (UIColor *)colorForKey:(NSString *)key{
	NSString *v = [DBCache valueForKey:key domain:@"Theme"];
	if (v) {
		NSArray *arr = [v split:@","];
        if ([arr count]==1 && (v.length>=6)) {
            return [UIColor colorFromString:v];
        }
        
		int n = [arr count];
		float r,g,b,a;
		r = n>0?[[arr objectAtIndex:0] floatValue]:0;
		g = n>1?[[arr objectAtIndex:1] floatValue]:0;
		b = n>2?[[arr objectAtIndex:2] floatValue]:0;
		a = n>3?[[arr objectAtIndex:3] floatValue]:1;
		UIColor *color = [UIColor colorWithRed:(r>1?(r/255.0):r) green:(g>1?(g/255.0):g) blue:(b>1?(b/255.0):b) alpha:a];
		return color;
	}
	return nil;
}
//形如 16,1代表 16号粗体 16或者16,0 代表16号标准字体
+ (UIFont *)fontForKey:(NSString *)key{
	NSString *v = [DBCache valueForKey:key domain:@"Theme"];
	if (v) {
		NSArray *arr = [v split:@","];
		int n = [arr count];
		float fsize;
		int b;
		fsize = n>0?[[arr objectAtIndex:0] floatValue]:14;
		b = n>1?[[arr objectAtIndex:1] intValue]:0;
		UIFont *font =  b>0 ?[UIFont boldSystemFontOfSize:fsize]:[UIFont systemFontOfSize:fsize];
		return font;
	}
	return [UIFont systemFontOfSize:14];
}
@end
