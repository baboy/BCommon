//
//  MediaCategory.h
//  iVideo
//
//  Created by baboy on 13-8-21.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSArray *data;

- (id) initWithDictionary:(NSDictionary*)dict;
- (NSMutableDictionary *) dict;
- (id)get:(NSString *)key;
+ (NSArray *)groupsFromArray:(NSArray *)array;
@end

