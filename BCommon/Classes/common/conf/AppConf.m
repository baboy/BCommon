//
//  Conf.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "AppConf.h"

@implementation AppConf
@synthesize title = _title;
@synthesize icon = _icon;
@synthesize tabName = _tabName;
@synthesize typeApi = _typeApi;
@synthesize listApi = _listApi;
@synthesize hotApi = _hotApi;
@synthesize dict = _dict;
@synthesize url = _url;
@synthesize color = _color;
- (void)dealloc{
    RELEASE(_url);
    RELEASE(_title);
    RELEASE(_icon);
    RELEASE(_tabName);
    RELEASE(_typeApi);
    RELEASE(_listApi);
    RELEASE(_hotApi);
    RELEASE(_dict);
    RELEASE(_color);
    [super dealloc];
}
- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setDict:dict];
        [self setIcon:[dict valueForKey:@"icon"]];
        [self setTitle:[dict valueForKey:@"title"]];
        [self setTabName:[dict valueForKey:@"tabName"]];
        if (!self.tabName) {
            self.tabName = self.title;
        }
        [self setColor:[UIColor colorFromString:[dict valueForKey:@"color"]]];
        NSDictionary *api = [dict valueForKey:@"api"];
        if (!api || ![api isKindOfClass:[NSDictionary class]]) {
            api = dict;
        }
        [self setTypeApi:[api valueForKey:@"type"]];
        [self setListApi:[api valueForKey:@"list"]];
        [self setHotApi:[api valueForKey:@"hot"]];
        [self setUrl:[api valueForKey:@"url"]];
    }
    return self;
}
- (NSDictionary *)actions{
    return [self valueForKey:@"actions"];
}
- (id)valueForKey:(NSString *)key{
    return [_dict valueForKey:key];
}
@end
