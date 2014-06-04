//
//  MediaCategory.m
//  iVideo
//
//  Created by baboy on 13-8-21.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "Group.h"
@interface Group()
@property (nonatomic, retain) NSMutableDictionary *dict;
@end
@implementation Group
- (void)dealloc{
    RELEASE(_id);
    RELEASE(_name);
    RELEASE(_icon);
    RELEASE(_desc);
    RELEASE(_data);
    RELEASE(_dict);
    [super dealloc];
}
- (id) initWithDictionary:(NSDictionary*)dict{
    if(self = [super init]){
        self.dict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [self setId:[nullToNil([dict valueForKey:@"id"]) description]];
        [self setName:nullToNil([dict valueForKey:@"name"])];
        if (!self.name) {
            [self setName:nullToNil([dict valueForKey:@"title"])];
            
        }
        [self setIcon:nullToNil([dict valueForKey:@"icon"])];
        [self setDesc:nullToNil([dict valueForKey:@"description"])];
    }
    return self;
}
- (id)get:(NSString *)key{
    return [self.dict valueForKey:key];
}
- (NSMutableDictionary *) dict{
    _dict = _dict?:[NSMutableDictionary dictionary];
    if(self.id)
        [_dict setValue:self.id forKey:@"id"];
    if(self.name)
        [_dict setValue:self.name forKey:@"name"];
    if(self.icon)
        [_dict setValue:self.icon forKey:@"icon"];
    if(self.desc)
        [_dict setValue:self.description forKey:@"desc"];
    if(self.data)
        [_dict setValue:self.data forKey:@"data"];
    return _dict;
}
+ (NSArray *)groupsFromArray:(NSArray *)array{
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0, n = [array count]; i < n; i++) {
        id dict = [array objectAtIndex:i];
        id cate = [dict isKindOfClass:[self class]] ? dict : [[Group alloc] initWithDictionary:dict];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            [cate setData:nullToNil([dict valueForKey:@"data"])];
        }
        [list addObject:cate];
    }
    return list;
}
@end
