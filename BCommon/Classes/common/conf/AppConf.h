//
//  Conf.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIUtils.h"

@interface AppConf : NSObject
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSString *tabName;
@property (nonatomic, retain) NSString *typeApi;
@property (nonatomic, retain) NSString *listApi;
@property (nonatomic, retain) NSString *hotApi;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) UIColor  *color;
@property (nonatomic, retain) NSDictionary *dict;
- (id)initWithDictionary:(NSDictionary *)dict;
- (id)valueForKey:(NSString *)key;
- (NSDictionary *)actions;
@end
