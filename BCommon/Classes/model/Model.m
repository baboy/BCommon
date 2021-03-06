//
//  Model.m
//  XChannel
//
//  Created by baboy on 8/5/14.
//  Copyright (c) 2014 baboy. All rights reserved.
//

#import "Model.h"
#import <objc/message.h>

@implementation Model
- (id) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self build:dict];
    }
    return self;
}

- (void)setValuesWithDictionary:(NSDictionary*)dict forKeys:(NSArray *)keys{
    for (NSString *k in keys) {
        NSString *field = [[[[k stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString] split:@" "] join:@""];
        id v = nullToNil( [dict valueForKey:k] );
        NSString *act = [NSString stringWithFormat:@"set%@",field];
        SEL sel = NSSelectorFromString(act);
        if ([self respondsToSelector:sel]) {
            IMP imp = [self methodForSelector:sel];
            void(*func)(id, SEL, id) = (void *)imp;
            func(self, sel, v);
        }
    }
}
- (NSMutableDictionary *)dictForFields:(NSArray *)fields{
    DLOG(@"%@",fields);
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    for (NSString *k in fields) {
        NSString *field = k;
        if ( [field rangeOfString:@"_"].length>0 ) {
            field = [[[[k stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString] split:@" "] join:@""];
            field = [NSString stringWithFormat:@"%@%@",[[field substringToIndex:1] lowercaseString],[field substringFromIndex:1]];
        }
        DLOG(@"field:%@",field);
        
        SEL action = NSSelectorFromString(field);
        if (![self respondsToSelector:action]) {
            continue;
        }
        IMP imp = [self methodForSelector:action];
        id (*_propValue)() = (void *)imp;
        id val = _propValue(self, action);
        if (val)
            [d setValue:val forKey:field];
    }
    return d;
}

/***********************/
+ (NSDictionary *)attributeDictionary{
    if ([NSStringFromClass([self class]) isEqualToString:@"Model"]) {
        return nil;
    }
    
    NSDictionary *parentDict = [[self superclass] attributeDictionary];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parentDict];
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        const char *typeName = property_getAttributes(property);
        NSString *classOriginName = [NSString stringWithUTF8String:typeName];
        NSString *className = [self parseClassName:classOriginName];
        [dict setObject:className forKey:propName];
    }
    if (properties) {
        free(properties);
    }
    return dict;
}
+ (NSString*) parseClassName:(NSString *)classOriginName {
    NSString* name = [[classOriginName componentsSeparatedByString:@","] objectAtIndex:0];
    if([name isEqualToString:@"Ti"]){
        return @"int";
    }
    if([name isEqualToString:@"Td"]){
        return @"double";
    }
    if([name isEqualToString:@"Tf"]){
        return @"float";
    }
    if([name isEqualToString:@"Tc"]){
        return @"boolean";
    }
    if([name isEqualToString:@"Tq"]){
        return @"long";
    }
    NSString* className = [[name substringToIndex:[name length]-1] substringFromIndex:3];
    if ([className rangeOfString:@"<"].location != NSNotFound) {
        NSString* subName = [className substringFromIndex:[className rangeOfString:@"<"].location+1];
        return [subName substringToIndex:[subName length]-1];
    }
    return className;
}
- (void)build:(NSDictionary *)data{
    NSDictionary *attributes = [[self class] attributeDictionary];
    for (NSString *key in [data allKeys]){
        id val = nullToNil([data objectForKey:key]);
        NSString *field = [[[[key stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString] split:@" "] join:@""];
        field = [field stringByReplacingCharactersInRange:(NSRange){0,1} withString:[[field substringToIndex:1] lowercaseString]];
        
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [field capitalizedString]]);
        if ([self respondsToSelector:sel]) {
            if (val) {
                NSString* className = [attributes valueForKey:field];
                
                
                if ([className isEqualToString:@"int"]) {
                    int v = [val intValue];
                    // set value
                    IMP imp = [self methodForSelector:sel];
                    void(*func)(id, SEL, int) = (void *)imp;
                    func(self, sel, v);
                    continue;
                }
                if ([className isEqualToString:@"float"]) {
                    int v = [val floatValue];
                    // set value
                    IMP imp = [self methodForSelector:sel];
                    void(*func)(id, SEL, float) = (void *)imp;
                    func(self, sel, v);
                    continue;
                }
                if ([className isEqualToString:@"double"]) {
                    int v = [val doubleValue];
                    // set value
                    IMP imp = [self methodForSelector:sel];
                    void(*func)(id, SEL, double) = (void *)imp;
                    func(self, sel, v);
                    continue;
                }
                if ([className isEqualToString:@"long"]) {
                    int v = [val doubleValue];
                    // set value
                    IMP imp = [self methodForSelector:sel];
                    void(*func)(id, SEL, long long) = (void *)imp;
                    func(self, sel, v);
                    continue;
                }
                
                if ([className isEqualToString:@"boolean"]) {
                    int v = [val boolValue];
                    // set value
                    IMP imp = [self methodForSelector:sel];
                    void(*func)(id, SEL, BOOL) = (void *)imp;
                    func(self, sel, v);
                    continue;
                }
                id v = val;
                if ([val isKindOfClass:[NSArray class]]) {
                    className = [attributes valueForKey:[NSString stringWithFormat:@"%@Item",field]];
                    v = [NSMutableArray array];
                    for (int i = 0, n = [val count]; i < n; i++) {
                        if (className) {
                            id item = AUTORELEASE([[NSClassFromString(className) alloc] initWithDictionary:[val objectAtIndex:i]]);
                            [v addObject:item];
                        }
                    }
                }else if ([className isEqualToString:@"NSDate"]) {
                    v = [val dateWithFormat:FULLDATEFORMAT];
                }else if ([className isEqualToString:@"NSDictionary"]) {
                    v = AUTORELEASE([[NSClassFromString(className) alloc] initWithDictionary:val]);
                }else if([NSClassFromString(className) isSubclassOfClass:[Model class]]){
                    v = AUTORELEASE([[NSClassFromString(className) alloc] initWithDictionary:val]);
                }
                // set value
                IMP imp = [self methodForSelector:sel];
                void(*func)(id, SEL, id) = (void *)imp;
                func(self, sel, v);
            }
        }
    }
}
@end
