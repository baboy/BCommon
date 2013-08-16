//
//  GString.m
//  BCommon
//
//  Created by baboy on 13-8-16.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "GString.h"

@implementation GString
+ (void)initialize{
    [self setup];
}
+ (void)setup:(NSString *)string{
    NSString *f = getBundleFile([NSString stringWithFormat:@"%@.string.plist", string]);
    NSDictionary *conf = [NSDictionary dictionaryWithContentsOfFile:f];
    for (NSString *k in [conf allKeys]) {
        NSString *v = [conf valueForKey:k];
        [DBCache setValue:v forKey:k domain:@"string"];
    }
}
+ (void)setup{
    [self setup:@"default"];
}
+ (NSString *)stringForKey:(id)key{
    if (![key isKindOfClass:[NSString class]]) {
        if ([key isKindOfClass:[UIViewController class]]) {
            key = NSStringFromClass([key class]);
        }
    }
    return [DBCache valueForKey:key domain:@"string"];
}
@end
